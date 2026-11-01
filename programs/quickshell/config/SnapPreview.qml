import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property var shell
    required property var monitor
    property var preview: shell.previews[monitor.name] || null
    screen: monitor
    anchors { top: true; bottom: true; left: true; right: true }
    visible: preview !== null
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    mask: Region {}
    color: "transparent"
    Rectangle {
        x: preview ? preview.x : 0
        y: preview ? preview.y : 0
        width: preview ? preview.width : 0
        height: preview ? preview.height : 0
        radius: 12
        color: "#5588cfe0"
        border.color: "#aaddf4"
        border.width: 2
    }
}
