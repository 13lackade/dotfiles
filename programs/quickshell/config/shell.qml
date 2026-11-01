import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    property var workspaceView: ({ monitors: [], currentMonitor: "" })
    property var proximity: ({})
    property var previews: ({})
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
    property var pinned: []
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
    function togglePin(id) {
        let next = pinned.slice()
        let selected = DesktopEntries.byId(id) || DesktopEntries.heuristicLookup(id)
        let index = next.findIndex(existing => {
            let entry = DesktopEntries.byId(existing) || DesktopEntries.heuristicLookup(existing)
            return entry && selected ? entry.id === selected.id : existing === id
        })
        if (index < 0) next.push(id); else next.splice(index, 1)
        pinned = next
        dockState.setText(JSON.stringify(next))
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
        let target = monitor || workspaceView.currentMonitor || Quickshell.screens[0]?.name || ""
        if (menu === name && menuScreen === target) {
            menu = ""
        } else {
            menuScreen = target
            menu = name
            if (name === "clipboard") clipboardList.running = true
        }
    }
    function monitor(name) {
        return workspaceView.monitors.find(m => m.name === name)
            || workspaceView.monitors.find(m => m.name === workspaceView.currentMonitor)
            || workspaceView.monitors[0] || null
    }
    function send(method, params) {
        if (shoji.connected) {
            shoji.write(JSON.stringify({ method: method, params: params }) + "\n")
            shoji.flush()
        }
    }
    function launch(entry) {
        if (!entry) return
        let id = entry.id.replace(/\.desktop$/, "").toLowerCase()
        if (id === "slack" || id === "discord") send("apps.launch", { app: id })
        else entry.execute()
        menu = ""
    }

    Socket {
        id: shoji
        path: Quickshell.env("XDG_RUNTIME_DIR") + "/shojiwm-" + Quickshell.env("WAYLAND_DISPLAY") + ".sock"
        connected: true
        onConnectedChanged: if (connected) {
            write('{"id":1,"method":"workspaces.get"}\n')
            flush()
        }
        parser: SplitParser {
            onRead: data => {
                try {
                    let msg = JSON.parse(data)
                    if (msg.event === "workspaces.changed" || msg.id === 1)
                        root.workspaceView = msg.payload || msg.result
                    else if (msg.event === "dock.proximity") {
                        let p = Object.assign({}, root.proximity)
                        p[msg.payload.monitor] = msg.payload.inside
                        root.proximity = p
                    } else if (msg.event === "snap.preview") {
                        let p = Object.assign({}, root.previews)
                        p[msg.payload.monitor] = msg.payload.rect
                        root.previews = p
                    }
                } catch (error) { console.warn("ShojiWM IPC:", error) }
            }
        }
    }
    Timer {
        interval: 1000
        running: !shoji.connected
        repeat: true
        onTriggered: shoji.connected = true
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
        id: dockState
        path: Quickshell.env("HOME") + "/.config/quickshell-dock.json"
        printErrors: false
        onLoaded: { try { root.pinned = JSON.parse(text()) } catch (e) {} }
    }
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
            SnapPreview { shell: root; monitor: modelData }
            MonitorIdentify { shell: root; monitor: modelData }
            NotificationPopup { shell: root; monitor: modelData }
            Menus { shell: root; monitor: modelData }
            Dock { shell: root; monitor: modelData }
        }
    }
}
