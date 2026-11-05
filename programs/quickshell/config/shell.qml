//@ pragma IconTheme Papirus-Dark
//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    readonly property string currentMonitor: Hyprland.focusedMonitor?.name || Quickshell.screens[0]?.name || ""
    property string menu: ""
    property string menuScreen: ""
    property var clips: []
    readonly property var notifications: notificationServer.trackedNotifications.values
    property var wallpapers: ({})
    property string globalWallpaper: ""
    function wallpaperFor(monitor) {
        let value = wallpapers[monitor] || globalWallpaper || ""
        if (!value) value = Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
        return value.startsWith("file://") ? value : "file://" + value
    }
    property var popupNotifications: []
    property bool notificationsSilent: false
    property bool identifyingMonitors: false
    property string cpu: "--"
    property string memory: "--"
    property var previousCpu: null
    function copyClip(line) {
        let id = line.split("\t")[0]
        if (/^\d+$/.test(id)) Quickshell.execDetached(["sh", "-c", "cliphist decode \"$1\" | wl-copy", "sh", id])
        menu = ""
    }
    function hidePopup(id) {
        popupNotifications = popupNotifications.filter(entry => entry.id !== id)
    }
    function activateNotification(notification) {
        let actions = notification?.actions || []
        let action = actions.find(item => item.identifier === "default") || (actions.length === 1 ? actions[0] : null)
        if (!action) return
        hidePopup(notification.id)
        action.invoke()
    }
    function notificationActionLabel(action, index) {
        let label = (action.text || "").trim()
        if (label) return label
        if (action.identifier === "default") return "Open"
        return action.identifier ? "Action: " + action.identifier : "Action " + (index + 1)
    }
    function setWallpaper(monitor, url) {
        let next = Object.assign({}, wallpapers)
        next[monitor] = url
        wallpapers = next
        wallpaperState.setText(JSON.stringify({ global: globalWallpaper, overrides: next }))
    }
    function setWallpaperForAll(url) {
        globalWallpaper = url
        wallpapers = ({})
        wallpaperState.setText(JSON.stringify({ global: url, overrides: {} }))
    }
    function identifyMonitors() {
        identifyingMonitors = true
        identifyTimeout.restart()
    }

    function toggleMenu(name, monitor) {
        let target = monitor || currentMonitor
        if (menu === name && menuScreen === target) {
            menu = ""
        } else {
            menuScreen = target
            menu = name
            if (name === "clipboard") clipboardList.running = true
        }
    }
    function launch(entry) {
        if (!entry) return
        let desktopId = entry.id.endsWith(".desktop") ? entry.id : entry.id + ".desktop"
        Quickshell.execDetached(["uwsm", "app", "--", desktopId])
        menu = ""
    }

    IpcHandler {
        target: "shell"
        function toggle(name: string, monitor: string): void { root.toggleMenu(name, monitor) }
        function startMenu(monitor: string): void { root.toggleMenu("start", monitor) }
        function clipboard(monitor: string): void { root.toggleMenu("clipboard", monitor) }
    }
    Process {
        id: clipboardList
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: root.clips = text.trim().split("\n").filter(x => /^\d+\t/.test(x))
        }
    }
    Process {
        id: systemUsage
        command: ["sh", "-c", "head -n 1 /proc/stat; head -n 3 /proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = text.trim().split("\n")
                let ticks = lines[0].trim().split(/\s+/).slice(1).map(Number)
                let total = ticks.reduce((a, b) => a + b, 0)
                let idle = ticks[3] + ticks[4]
                if (root.previousCpu && total > root.previousCpu.total)
                    root.cpu = Math.round(100 * (1 - (idle - root.previousCpu.idle) / (total - root.previousCpu.total))) + "%"
                root.previousCpu = { total: total, idle: idle }
                let totalMem = Number((lines[1].match(/\d+/) || [0])[0])
                let freeMem = Number((lines[3].match(/\d+/) || [0])[0])
                if (totalMem) root.memory = Math.round(100 * (1 - freeMem / totalMem)) + "%"
            }
        }
    }
    Timer { interval: 3000; repeat: true; running: true; triggeredOnStart: true; onTriggered: systemUsage.running = true }
    FileView {
        id: wallpaperState
        path: Quickshell.env("HOME") + "/.config/quickshell-wallpapers.json"
        printErrors: false
        onLoaded: {
            try {
                let state = JSON.parse(text())
                if (state.overrides || state.global) {
                    root.wallpapers = state.overrides || {}
                    root.globalWallpaper = state.global || ""
                } else root.wallpapers = state
            } catch (e) {}
        }
    }
    NotificationServer {
        id: notificationServer
        persistenceSupported: true
        actionsSupported: true
        onNotification: notification => {
            notification.tracked = true
            if (!root.notificationsSilent) {
                root.hidePopup(notification.id)
                root.popupNotifications = root.popupNotifications.concat([{ id: notification.id, notification: notification, until: Date.now() + 5000 }]).slice(-5)
            }
        }
    }
    Timer {
        interval: 250; repeat: true; running: root.popupNotifications.length > 0
        onTriggered: {
            let remaining = root.popupNotifications.filter(entry => entry.until > Date.now() && entry.notification)
            if (remaining.length !== root.popupNotifications.length) root.popupNotifications = remaining
        }
    }
    Timer { id: identifyTimeout; interval: 3000; onTriggered: root.identifyingMonitors = false }
    Variants {
        model: Quickshell.screens
        Scope {
            required property var modelData
            Background { shell: root; monitor: modelData }
            Bar { shell: root; monitor: modelData }
            MonitorIdentify { shell: root; monitor: modelData }
            NotificationPopup { shell: root; monitor: modelData }
            Menus { shell: root; monitor: modelData }
        }
    }
}
