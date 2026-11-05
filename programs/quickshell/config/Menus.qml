import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Bluetooth

PanelWindow {
    id: panel
    required property var shell
    required property var monitor
    screen: monitor
    visible: shell.menu !== "" && shell.menuScreen === monitor.name
    anchors.top: true
    anchors.left: shell.menu === "start" || shell.menu === "clipboard"
    anchors.right: shell.menu === "status" || shell.menu === "wallpaper" || shell.menu === "battery"
    margins.top: 36
    margins.left: 8
    margins.right: 8
    implicitWidth: 370
    implicitHeight: shell.menu === "clock" ? 460 : shell.menu === "battery" ? 175 : shell.menu === "status" ? 620 : 560
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    HyprlandFocusGrab {
        windows: [panel]
        active: panel.visible
        onCleared: {
            if (panel.visible) panel.shell.menu = ""
        }
    }
    Item {
        Window.onActiveChanged: {
            if (!Window.active && panel.visible && shell.menuScreen === monitor.name)
                shell.menu = ""
        }
    }
    Shortcut { sequence: "Escape"; enabled: panel.visible; onActivated: shell.menu = "" }
    property real brightness: -1
    property int calendarOffset: 0
    property bool showPower: false
    property bool wallpaperAllScreens: false
    property date calendarDate: new Date(clock.date.getFullYear(), clock.date.getMonth() + calendarOffset, 1)
    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
    Process {
        id: brightnessRead
        command: ["brightnessctl", "-m", "-c", "backlight"]
        stdout: StdioCollector { onStreamFinished: { let fields = text.trim().split(","); panel.brightness = fields.length > 3 ? parseInt(fields[3]) / 100 : -1 } }
    }
    Timer { interval: 5000; repeat: true; running: true; triggeredOnStart: true; onTriggered: brightnessRead.running = true }

    function prepareMenu() {
        if (!visible) return
        if (shell.menu === "start") {
            search.text = ""
            search.forceActiveFocus()
        }
        if (shell.menu === "clipboard") {
            clipSearch.text = ""
            clipSearch.forceActiveFocus()
        }
        if (shell.menu === "wallpaper") {
            wallpaperModel.folder = ""
            wallpaperModel.folder = "file://" + Quickshell.env("HOME") + "/Pictures/wallpapers"
        }
    }
    function batteryTime(seconds) {
        if (seconds <= 0) return "—"
        let minutes = Math.round(seconds / 60)
        return Math.floor(minutes / 60) + "h " + (minutes % 60) + "m"
    }
    onVisibleChanged: prepareMenu()
    Connections {
        target: shell
        function onMenuChanged() { Qt.callLater(panel.prepareMenu) }
    }
    Rectangle { anchors.fill: parent; color: "#ed202024"; radius: 10 }

    component MenuButton: Rectangle {
        id: btn
        property string label: ""
        signal clicked()
        implicitHeight: 38
        implicitWidth: buttonText.implicitWidth + 24
        radius: 6
        color: mouse.containsMouse ? "#88cfe0" : "#39393d"
        Text { id: buttonText; anchors.centerIn: parent; text: btn.label; color: mouse.containsMouse ? "#101010" : "#f4f4f4"; font.pixelSize: 13 }
        MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; onClicked: btn.clicked() }
    }

    ColumnLayout {
        anchors { fill: parent; margins: 12 }
        spacing: 8
        visible: shell.menu === "start"
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 38; radius: 6; color: "#48484b"
            TextInput {
                id: search
                anchors { fill: parent; margins: 9 }
                color: "white"; font.pixelSize: 14; clip: true
                Keys.onEscapePressed: shell.menu = ""
                onTextChanged: apps.currentIndex = 0
                Keys.onDownPressed: if (apps.count) apps.currentIndex = Math.min(apps.currentIndex + 1, apps.count - 1)
                Keys.onUpPressed: if (apps.count) apps.currentIndex = Math.max(apps.currentIndex - 1, 0)
                Keys.onReturnPressed: if (apps.count && apps.currentIndex >= 0) shell.launch(apps.model[apps.currentIndex])
                Text { anchors.fill: parent; text: "Search..."; color: "#aaa"; visible: !search.text }
            }
        }
        ListView {
            id: apps
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true; spacing: 2
            model: DesktopEntries.applications.values.filter(app => !search.text || (app.name + " " + app.genericName).toLowerCase().includes(search.text.toLowerCase())).sort((a, b) => a.name.localeCompare(b.name))
            delegate: Rectangle {
                required property var modelData
                required property int index
                property bool selected: appMouse.containsMouse || apps.currentIndex === index
                width: apps.width; height: 40; radius: 6; color: selected ? "#88cddd" : "transparent"
                Row {
                    anchors { fill: parent; leftMargin: 8 } spacing: 12
                    Image { anchors.verticalCenter: parent.verticalCenter; width: 26; height: 26; source: Quickshell.iconPath(modelData.icon, true) || Qt.resolvedUrl("assets/application.svg") }
                    Text { anchors.verticalCenter: parent.verticalCenter; text: modelData.name; color: parent.parent.selected ? "black" : "white"; font.pixelSize: 14 }
                }
                MouseArea {
                    id: appMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: shell.launch(modelData)
                }
            }
        }
        RowLayout {
            visible: panel.showPower
            Layout.fillWidth: true
            MenuButton { Layout.fillWidth: true; label: "Power off"; onClicked: Quickshell.execDetached(["systemctl", "poweroff"]) }
            MenuButton { Layout.fillWidth: true; label: "Restart"; onClicked: Quickshell.execDetached(["systemctl", "reboot"]) }
            MenuButton { Layout.fillWidth: true; label: "Log out"; onClicked: Quickshell.execDetached(["uwsm", "stop"]) }
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: Quickshell.env("USER"); color: "white"; Layout.fillWidth: true; font.bold: true }
            MenuButton {
                label: "Lock"
                onClicked: {
                    shell.menu = ""
                    Quickshell.execDetached(["swaylock", "--daemonize", "--color", "202024", "--indicator-idle-visible", "--inside-color", "29292d", "--ring-color", "88cddd", "--line-uses-inside", "--show-failed-attempts"])
                }
            }
            MenuButton { label: "Power"; onClicked: panel.showPower = !panel.showPower }
        }
    }
    ColumnLayout {
        anchors { fill: parent; margins: 12 } spacing: 8
        visible: shell.menu === "clipboard"
        Text { text: "Clipboard"; color: "white"; font.pixelSize: 18; font.bold: true }
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 38; radius: 6; color: "#48484b"
            TextInput {
                id: clipSearch
                anchors { fill: parent; margins: 9 }
                color: "white"; font.pixelSize: 14; clip: true
                onTextChanged: clips.currentIndex = 0
                Keys.onEscapePressed: shell.menu = ""
                Keys.onDownPressed: if (clips.count) clips.currentIndex = Math.min(clips.currentIndex + 1, clips.count - 1)
                Keys.onUpPressed: if (clips.count) clips.currentIndex = Math.max(clips.currentIndex - 1, 0)
                Keys.onReturnPressed: if (clips.count && clips.currentIndex >= 0) shell.copyClip(clips.model[clips.currentIndex])
                Text { anchors.fill: parent; text: "Search clipboard..."; color: "#aaa"; visible: !clipSearch.text }
            }
        }
        ListView {
            id: clips
            Layout.fillWidth: true; Layout.fillHeight: true; clip: true; spacing: 3
            model: shell.clips.filter(line => line.toLowerCase().includes(clipSearch.text.trim().toLowerCase())).slice(0, 100)
            delegate: ClipboardEntry {
                required property string modelData
                required property int index
                width: clips.width
                line: modelData
                shell: panel.shell
                selected: clips.currentIndex === index
            }
        }
        Text { Layout.alignment: Qt.AlignHCenter; visible: clips.count === 0; text: clipSearch.text ? "No matching entries" : "Clipboard is empty"; color: "#aaaaaa" }
    }
    SystemClock { id: clock; precision: SystemClock.Seconds }
    ColumnLayout {
        anchors { fill: parent; margins: 12 } spacing: 10
        visible: shell.menu === "clock"
        Text { Layout.alignment: Qt.AlignHCenter; text: Qt.formatDate(clock.date, "yyyy年M月d日 (ddd)"); color: "#bbbbbb"; font.pixelSize: 15 }
        Text { Layout.alignment: Qt.AlignHCenter; text: Qt.formatTime(clock.date, "HH:mm:ss"); color: "white"; font.bold: true; font.pixelSize: 38 }
        RowLayout {
            Layout.fillWidth: true
            MenuButton { label: "‹"; onClicked: panel.calendarOffset-- }
            Text { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: Qt.formatDate(panel.calendarDate, "yyyy年 M月"); color: "white"; font.pixelSize: 18 }
            MenuButton { label: "›"; onClicked: panel.calendarOffset++ }
        }
        GridLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; columns: 7
            Repeater {
                model: ["日", "月", "火", "水", "木", "金", "土"]
                Text { required property string modelData; Layout.alignment: Qt.AlignCenter; text: modelData; color: "#aaaaaa" }
            }
            Repeater {
                model: 42
                Rectangle {
                    required property int index
                    property int firstDay: new Date(panel.calendarDate.getFullYear(), panel.calendarDate.getMonth(), 1).getDay()
                    property int day: index - firstDay + 1
                    property int days: new Date(panel.calendarDate.getFullYear(), panel.calendarDate.getMonth() + 1, 0).getDate()
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: 6
                    color: day === clock.date.getDate() && panel.calendarOffset === 0 ? "#88cfe0" : "transparent"
                    Text { anchors.centerIn: parent; text: parent.day > 0 && parent.day <= parent.days ? parent.day : ""; color: parent.day === clock.date.getDate() && panel.calendarOffset === 0 ? "black" : "white" }
                }
            }
        }
    }
    StatusPanel {
        anchors.fill: parent
        visible: shell.menu === "status" && panel.visible
        shell: panel.shell
        monitor: panel.monitor
        brightness: panel.brightness
    }
    ColumnLayout {
        anchors { fill: parent; margins: 14 }
        spacing: 7
        visible: shell.menu === "battery"
        Text { text: "Battery"; color: "white"; font.bold: true; font.pixelSize: 18 }
        RowLayout {
            Layout.fillWidth: true
            Text { text: Math.round(UPower.displayDevice.percentage * 100) + "%"; color: "#88cddd"; font.bold: true; font.pixelSize: 26 }
            Text { Layout.fillWidth: true; text: UPower.displayDevice.state === UPowerDeviceState.Charging ? "Charging" : UPower.displayDevice.state === UPowerDeviceState.Discharging ? "Discharging" : UPower.displayDevice.state === UPowerDeviceState.FullyCharged ? "Fully charged" : "Connected"; color: "#dddddd"; horizontalAlignment: Text.AlignRight }
        }
        Rectangle { Layout.fillWidth: true; height: 1; color: "#484848" }
        RowLayout {
            Layout.fillWidth: true
            Text { text: UPower.displayDevice.state === UPowerDeviceState.Charging ? "Time to full" : "Time remaining"; color: "#aaaaaa"; Layout.fillWidth: true }
            Text { text: panel.batteryTime(UPower.displayDevice.state === UPowerDeviceState.Charging ? UPower.displayDevice.timeToFull : UPower.displayDevice.timeToEmpty); color: "white" }
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: "Power"; color: "#aaaaaa"; Layout.fillWidth: true }
            Text { text: Math.abs(UPower.displayDevice.changeRate).toFixed(1) + " W"; color: "white" }
        }
        Item { Layout.fillHeight: true }
    }
    ColumnLayout {
        anchors { fill: parent; margins: 12 }
        visible: shell.menu === "wallpaper"
        RowLayout {
            Layout.fillWidth: true
            Text { text: "Wallpaper"; color: "white"; font.pixelSize: 18; Layout.fillWidth: true }
            MenuButton { label: "Identify displays"; onClicked: shell.identifyMonitors() }
        }
        RowLayout {
            Layout.fillWidth: true
            Text { text: "~/Pictures/wallpapers"; color: "#aaaaaa"; Layout.fillWidth: true }
            MenuButton { label: panel.wallpaperAllScreens ? "All displays" : monitor.name; onClicked: panel.wallpaperAllScreens = !panel.wallpaperAllScreens }
        }
        GridView {
            id: wallpaperGrid
            Layout.fillWidth: true; Layout.fillHeight: true; clip: true
            cellWidth: 112; cellHeight: 90
            model: FolderListModel {
                id: wallpaperModel
                folder: "file://" + Quickshell.env("HOME") + "/Pictures/wallpapers"
                nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
                showDirs: false
            }
            delegate: Item {
                required property url fileUrl
                width: wallpaperGrid.cellWidth; height: wallpaperGrid.cellHeight
                Image { anchors { fill: parent; margins: 3 } source: fileUrl; fillMode: Image.PreserveAspectCrop; asynchronous: true }
                MouseArea { anchors.fill: parent; onClicked: { if (panel.wallpaperAllScreens) shell.setWallpaperForAll(fileUrl.toString()); else shell.setWallpaper(monitor.name, fileUrl.toString()); shell.menu = "" } }
            }
        }
    }
}
