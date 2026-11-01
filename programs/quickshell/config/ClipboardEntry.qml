import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: item
    required property string line
    required property var shell
    property bool selected: false
    property string clipId: line.split("\t")[0]
    property string preview: line.slice(line.indexOf("\t") + 1)
    property bool isImage: preview.startsWith("[[ binary data")
    property string thumbnailPath: Quickshell.env("XDG_RUNTIME_DIR") + "/quickshell-clip-" + clipId + ".png"
    property bool thumbnailReady: false
    height: isImage ? 110 : 42
    radius: 6
    color: area.containsMouse || selected ? "#88cfe0" : "#38383c"
    Process {
        running: item.isImage && /^\d+$/.test(item.clipId)
        command: ["sh", "-c", "cliphist decode \"$1\" | magick - -thumbnail 480x300 \"$2\"", "sh", item.clipId, item.thumbnailPath]
        onExited: code => item.thumbnailReady = code === 0
    }
    Image {
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 5 }
        width: item.isImage ? 120 : 0
        visible: item.thumbnailReady
        source: item.thumbnailReady ? "file://" + item.thumbnailPath : ""
        fillMode: Image.PreserveAspectFit
        asynchronous: true
    }
    Text {
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: item.isImage ? 130 : 9; rightMargin: 9 }
        text: item.preview
        color: area.containsMouse || item.selected ? "black" : "white"
        elide: Text.ElideRight
        textFormat: Text.PlainText
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: shell.copyClip(item.line)
    }
}
