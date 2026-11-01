import QtQuick
import Quickshell

Column {
    id: items
    required property var entries
    required property var closeMenu
    property int depth: 0
    spacing: 2

    Repeater {
        model: items.entries
        delegate: Column {
            id: entryColumn
            required property var modelData
            property bool expanded: false
            width: items.width
            onExpandedChanged: {
                if (expanded) {
                    nested.setSource(Qt.resolvedUrl("TrayMenuItems.qml"), {
                        entries: Qt.binding(() => submenu.children),
                        depth: items.depth + 1,
                        closeMenu: items.closeMenu
                    })
                } else nested.setSource("")
            }

            QsMenuOpener {
                id: submenu
                menu: entryColumn.expanded ? entryColumn.modelData : null
            }
            Rectangle {
                id: row
                width: parent.width
                height: entryColumn.modelData.isSeparator ? 9 : 36
                radius: 6
                color: !entryColumn.modelData.isSeparator && entryColumn.modelData.enabled && hit.containsMouse ? "#55393939" : "transparent"

                Rectangle {
                    visible: entryColumn.modelData.isSeparator
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 10; rightMargin: 10 }
                    height: 1
                    color: "#554f4f53"
                }
                Text {
                    anchors { left: parent.left; leftMargin: 9 + items.depth * 12; verticalCenter: parent.verticalCenter }
                    width: 18
                    visible: !entryColumn.modelData.isSeparator && entryColumn.modelData.buttonType !== QsMenuButtonType.None
                    text: entryColumn.modelData.checkState === Qt.Checked ? (entryColumn.modelData.buttonType === QsMenuButtonType.RadioButton ? "●" : "✓") : ""
                    color: "#88cddd"
                    font.pixelSize: 13
                }
                Image {
                    id: icon
                    anchors { left: parent.left; leftMargin: 29 + items.depth * 12; verticalCenter: parent.verticalCenter }
                    width: 18; height: 18
                    sourceSize.width: width; sourceSize.height: height
                    visible: !entryColumn.modelData.isSeparator && source !== ""
                    source: entryColumn.modelData.isSeparator ? "" : entryColumn.modelData.icon
                    opacity: entryColumn.modelData.enabled ? 1 : 0.45
                }
                Text {
                    anchors { left: icon.right; leftMargin: 8; right: arrow.left; rightMargin: 6; verticalCenter: parent.verticalCenter }
                    visible: !entryColumn.modelData.isSeparator
                    text: entryColumn.modelData.isSeparator ? "" : entryColumn.modelData.text
                    textFormat: Text.PlainText
                    elide: Text.ElideRight
                    color: entryColumn.modelData.enabled ? "#f4f4f4" : "#77777b"
                    font.pixelSize: 13
                }
                Text {
                    id: arrow
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                    visible: !entryColumn.modelData.isSeparator && entryColumn.modelData.hasChildren
                    text: entryColumn.expanded ? "⌄" : "›"
                    color: entryColumn.modelData.enabled ? "#bcbcc1" : "#77777b"
                    font.pixelSize: 18
                }
                MouseArea {
                    id: hit
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: !entryColumn.modelData.isSeparator && entryColumn.modelData.enabled
                    onClicked: {
                        if (entryColumn.modelData.hasChildren) entryColumn.expanded = !entryColumn.expanded
                        else {
                            entryColumn.modelData.triggered()
                            items.closeMenu()
                        }
                    }
                }
            }
            Loader {
                id: nested
                width: parent.width
            }
        }
    }
}
