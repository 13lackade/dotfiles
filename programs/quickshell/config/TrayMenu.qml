import QtQuick
import Quickshell

PopupWindow {
    id: popup
    required property var shell
    property var trayItem: null
    property Item anchorItem: null
    property real screenHeight: 600

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 4
    implicitWidth: 300
    implicitHeight: Math.min(menuItems.implicitHeight + 16, Math.max(100, screenHeight - 48))
    color: "transparent"
    grabFocus: true
    visible: false

    QsMenuOpener {
        id: menuOpener
        menu: popup.visible && popup.trayItem ? popup.trayItem.menu : null
    }
    Connections {
        target: popup.shell
        function onMenuChanged() { if (popup.shell.menu !== "") popup.visible = false }
    }
    Shortcut { sequence: "Escape"; enabled: popup.visible; onActivated: popup.visible = false }

    Rectangle {
        anchors.fill: parent
        color: "#ed202024"
        radius: 10
        border.color: "#334e4e52"
    }
    Flickable {
        anchors { fill: parent; margins: 8 }
        clip: true
        contentWidth: width
        contentHeight: menuItems.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        TrayMenuItems {
            id: menuItems
            width: parent.width
            entries: menuOpener.children
            closeMenu: () => { popup.visible = false }
        }
    }
}
