import QtQuick
import QtQuick.Layouts

Rectangle {
    id: button
    property string label: ""
    property string icon: ""
    property bool selected: false
    property bool active: true
    property bool chevron: false
    signal clicked()

    implicitHeight: 34
    implicitWidth: 130
    radius: 7
    color: selected ? "#88cddd" : mouse.containsMouse ? "#555559" : "#3a3a3d"
    opacity: active ? 1 : 0.55

    RowLayout {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        spacing: 7
        StatusIcon { visible: button.icon !== ""; icon: button.icon; dark: button.selected; iconSize: 16 }
        Text {
            Layout.fillWidth: true
            text: button.label
            color: button.selected ? "#111111" : "#f5f5f5"
            font.pixelSize: 13
            font.bold: button.selected
            elide: Text.ElideRight
        }
        Text { visible: button.chevron; text: "›"; color: button.selected ? "#222222" : "#bbbbbb"; font.pixelSize: 18 }
    }
    MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; enabled: button.active; onClicked: button.clicked() }
}
