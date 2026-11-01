import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property var shell
    required property var monitor
    screen: monitor
    anchors { top: true; right: true; bottom: true; left: true }
    visible: shell.identifyingMonitors
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}
    color: "transparent"
    Rectangle {
        anchors.centerIn: parent
        width: Math.max(180, identity.implicitWidth + 60)
        height: 120
        radius: 14
        color: "#e62b2b2b"
        border.width: 2
        border.color: "#88cddd"
        Column {
            id: identity
            anchors.centerIn: parent
            spacing: 4
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: Quickshell.screens.indexOf(monitor) + 1; color: "#88cddd"; font.pixelSize: 42; font.bold: true }
            Text { anchors.horizontalCenter: parent.horizontalCenter; text: monitor.name; color: "white"; font.pixelSize: 14 }
        }
    }
}
