import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property var shell
    required property var monitor
    screen: monitor
    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}
    color: "#12181d"
    Image {
        anchors.fill: parent
        source: shell.wallpaperFor(monitor.name)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
}
