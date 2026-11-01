import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

PanelWindow {
    id: bar
    required property var shell
    required property var monitor
    screen: monitor
    anchors { top: true; left: true; right: true }
    implicitHeight: 32
    color: "#70151515"
    property var wsMonitor: shell.monitor(monitor.name)
    property var activeWorkspace: wsMonitor ? wsMonitor.workspaces.find(w => w.active) : null
    readonly property var wifi: Networking.devices.values.find(device => device.type === DeviceType.Wifi) || null
    readonly property var currentWifi: wifi ? wifi.networks.values.find(network => network.connected) || null : null
    readonly property string wifiIcon: !Networking.wifiEnabled || !currentWifi ? "wifi-off" : currentWifi.signalStrength >= 0.7 ? "wifi-full" : currentWifi.signalStrength >= 0.4 ? "wifi-midium" : "wifi-low"
    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    TrayMenu {
        id: trayMenu
        shell: bar.shell
        screenHeight: bar.monitor.height
    }

    component BarButton: Rectangle {
        id: button
        property string label: ""
        property bool selected: false
        signal clicked()
        implicitWidth: textItem.implicitWidth + 18
        implicitHeight: 26
        radius: 7
        color: selected ? "#88cddd" : area.containsMouse ? "#55393939" : "transparent"
        Text { id: textItem; anchors.centerIn: parent; text: button.label; color: button.selected ? "#111111" : "#f4f4f4"; font.pixelSize: 13 }
        MouseArea { id: area; anchors.fill: parent; hoverEnabled: true; onClicked: button.clicked() }
    }
    Row {
        anchors { left: parent.left; leftMargin: 4; verticalCenter: parent.verticalCenter }
        spacing: 5
        Rectangle {
            property bool selected: shell.menu === "start" && shell.menuScreen === monitor.name
            width: 26; height: 26; radius: 8
            color: selected ? "#88cddd" : startHit.containsMouse ? "#55393939" : "transparent"
            Image { anchors.centerIn: parent; width: 18; height: 18; source: Qt.resolvedUrl(parent.selected ? "assets/nixos-black.svg" : "assets/nixos-white.svg") }
            MouseArea { id: startHit; anchors.fill: parent; hoverEnabled: true; onClicked: shell.toggleMenu("start", monitor.name) }
        }
        Rectangle {
            width: layoutRow.implicitWidth + 16; height: 26; radius: 7
            color: layoutHit.containsMouse ? "#55393939" : "transparent"
            Row {
                id: layoutRow; anchors.centerIn: parent; spacing: 6
                StatusIcon { anchors.verticalCenter: parent.verticalCenter; icon: bar.activeWorkspace?.isTiled ? "tiled" : "float"; iconSize: 16 }
                Text { anchors.verticalCenter: parent.verticalCenter; text: bar.activeWorkspace?.isTiled ? "Tiled" : "Float"; color: "#f5f5f5"; font.family: "monospace"; font.pixelSize: 13 }
            }
            MouseArea { id: layoutHit; anchors.fill: parent; hoverEnabled: true; onClicked: shell.send("workspaces.toggleTiling", { monitor: monitor.name }) }
        }
        Repeater {
            model: bar.wsMonitor ? bar.wsMonitor.workspaces : []
            Rectangle {
                required property var modelData
                width: 24; height: 24; radius: 6
                color: modelData.active ? "transparent" : "#552a2a2a"
                border.width: modelData.active ? 1 : 0; border.color: "#c0c0c0"
                Text { anchors.centerIn: parent; color: modelData.active || modelData.windowCount ? "#f5f5f5" : "#c0c0c0"; text: modelData.index; font.pixelSize: 12 }
                MouseArea { anchors.fill: parent; onClicked: shell.send("workspaces.activate", { monitor: monitor.name, index: modelData.index }) }
            }
        }
    }
    SystemClock { id: clock; precision: SystemClock.Minutes }
    BarButton {
        anchors.centerIn: parent
        label: Qt.formatDateTime(clock.date, "MM/dd ddd HH:mm")
        selected: shell.menu === "clock" && shell.menuScreen === monitor.name
        onClicked: shell.toggleMenu("clock", monitor.name)
    }
    Row {
        anchors { right: parent.right; rightMargin: 4; verticalCenter: parent.verticalCenter }
        spacing: 7
        Row {
            anchors.verticalCenter: parent.verticalCenter; spacing: 4
            Text { anchors.verticalCenter: parent.verticalCenter; text: shell.cpu; color: "white"; font.pixelSize: 11 }
            StatusIcon { anchors.verticalCenter: parent.verticalCenter; icon: "cpu"; iconSize: 14 }
        }
        Row {
            anchors.verticalCenter: parent.verticalCenter; spacing: 4
            Text { anchors.verticalCenter: parent.verticalCenter; text: shell.memory; color: "white"; font.pixelSize: 11 }
            StatusIcon { anchors.verticalCenter: parent.verticalCenter; icon: "memory"; iconSize: 14 }
        }
        Repeater {
            model: SystemTray.items
            Rectangle {
                id: trayItem
                required property var modelData
                anchors.verticalCenter: parent.verticalCenter
                width: 26; height: 26; radius: 6; color: "#33444444"
                Image { anchors.centerIn: parent; width: 17; height: 17; source: modelData.icon }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (trayItem.modelData.hasMenu) {
                            if (trayMenu.visible && trayMenu.trayItem === trayItem.modelData) {
                                trayMenu.visible = false
                            } else {
                                trayMenu.visible = false
                                bar.shell.menu = ""
                                trayMenu.trayItem = trayItem.modelData
                                trayMenu.anchorItem = trayItem
                                trayMenu.visible = true
                            }
                        } else trayItem.modelData.activate()
                    }
                }
            }
        }
        Rectangle {
            property bool selected: shell.menu === "battery" && shell.menuScreen === monitor.name
            property real charge: UPower.displayDevice.percentage
            anchors.verticalCenter: parent.verticalCenter
            visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery && UPower.displayDevice.isPresent
            width: batteryRow.implicitWidth + 16; height: 26; radius: 7
            color: selected ? "#88cddd" : batteryHit.containsMouse ? "#55393939" : "transparent"
            Row {
                id: batteryRow; anchors.centerIn: parent; spacing: 4
                Text { anchors.verticalCenter: parent.verticalCenter; text: Math.round(parent.parent.charge * 100) + "%"; color: parent.parent.selected ? "#111111" : "white"; font.pixelSize: 12 }
                StatusIcon {
                    anchors.verticalCenter: parent.verticalCenter; iconSize: 15; dark: parent.parent.selected
                    icon: UPower.displayDevice.state === UPowerDeviceState.Charging ? "battery-charging" : parent.parent.charge > 0.75 ? "battery-full" : parent.parent.charge > 0.45 ? "battery-midium" : parent.parent.charge > 0.2 ? "battery-low" : "battery-very-low"
                }
            }
            MouseArea { id: batteryHit; anchors.fill: parent; hoverEnabled: true; onClicked: shell.toggleMenu("battery", monitor.name) }
        }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            property bool selected: shell.menu === "wallpaper" && shell.menuScreen === monitor.name
            width: 28; height: 26; radius: 7; color: selected ? "#88cddd" : wallpaperHit.containsMouse ? "#55393939" : "transparent"
            StatusIcon { anchors.centerIn: parent; icon: "wallpaper"; dark: parent.selected; iconSize: 15 }
            MouseArea { id: wallpaperHit; anchors.fill: parent; hoverEnabled: true; onClicked: shell.toggleMenu("wallpaper", monitor.name) }
        }
        Rectangle {
            id: statusButton
            property bool selected: shell.menu === "status" && shell.menuScreen === monitor.name
            anchors.verticalCenter: parent.verticalCenter
            width: statusIcons.implicitWidth + 16; height: 26; radius: 7
            color: selected ? "#88cddd" : statusHit.containsMouse ? "#55393939" : "transparent"
            Row {
                id: statusIcons; anchors.centerIn: parent; spacing: 4
                StatusIcon { icon: bar.wifiIcon; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { visible: Bluetooth.defaultAdapter?.enabled ?? false; icon: "bluetooth"; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { icon: PowerProfiles.profile === PowerProfile.PowerSaver ? "leaf" : PowerProfiles.profile === PowerProfile.Performance ? "lightning" : "balanced"; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { icon: shell.notificationsSilent ? "bell-no" : "bell"; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { icon: "music"; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { icon: Pipewire.defaultAudioSink?.audio?.muted || Pipewire.defaultAudioSink?.audio?.volume === 0 ? "volume-off" : "volume"; dark: statusButton.selected; iconSize: 14 }
                StatusIcon { icon: "sun"; dark: statusButton.selected; iconSize: 14 }
            }
            MouseArea { id: statusHit; anchors.fill: parent; hoverEnabled: true; onClicked: shell.toggleMenu("status", monitor.name) }
        }
    }
}
