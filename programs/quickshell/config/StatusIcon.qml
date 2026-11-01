import QtQuick

Item {
    id: root
    required property string icon
    property bool dark: false
    property int iconSize: 16
    implicitWidth: iconSize
    implicitHeight: iconSize
    width: iconSize
    height: iconSize
    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl("assets/" + root.icon + (root.dark ? "-dark" : "") + ".svg")
        sourceSize.width: root.iconSize * 2
        sourceSize.height: root.iconSize * 2
        fillMode: Image.PreserveAspectFit
    }
}
