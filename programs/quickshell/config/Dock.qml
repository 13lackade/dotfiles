import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: dock
    required property var shell
    required property var monitor
    screen: monitor
    anchors { bottom: true }
    margins.bottom: 12
    implicitWidth: Math.max(1, row.implicitWidth + 16)
    implicitHeight: 52
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    visible: shell.proximity[monitor.name] || hover.containsMouse || dockPopup.visible
    property string popupKey: ""
    property real popupX: 0
    readonly property var popupItem: items.find(item => item.key === popupKey) || null
    property var items: {
        let groups = []
        let byId = {}
        for (let id of shell.pinned) {
            let app = DesktopEntries.byId(id) || DesktopEntries.heuristicLookup(id)
            let key = app ? app.id : id
            if (byId[key]) continue
            byId[key] = { key: key, app: app, windows: [], pinned: true }
            groups.push(byId[key])
        }
        for (let m of shell.workspaceView.monitors) {
            for (let ws of m.workspaces) {
                for (let win of ws.windows) {
                    let app = DesktopEntries.heuristicLookup(win.appId || "")
                    let key = app ? app.id : (win.appId || win.id)
                    if (!byId[key]) {
                        byId[key] = { key: key, app: app, windows: [], pinned: false }
                        groups.push(byId[key])
                    }
                    byId[key].windows.push(win)
                }
            }
        }
        for (let item of groups) item.windows.sort((a, b) => b.lastFocusedAt - a.lastFocusedAt)
        return groups
    }
    function openItemMenu(key, x) {
        if (dockPopup.visible && popupKey === key) {
            dockPopup.visible = false
            return
        }
        dockPopup.visible = false
        popupKey = key
        popupX = x
        dockPopup.visible = true
    }
    Rectangle { anchors.fill: parent; radius: 10; color: "#d91f2229"; border.color: "#332f3b4b" }
    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4
        Repeater {
            model: dock.items
            Rectangle {
                id: itemButton
                required property var modelData
                width: 40; height: 40; radius: 8
                color: itemHit.containsMouse ? "#554a4a4a" : "transparent"
                border.width: modelData.windows.some(win => win.focused) ? 1 : 0
                border.color: "#88cddd"
                Image { anchors.centerIn: parent; width: 28; height: 28; source: (modelData.app ? Quickshell.iconPath(modelData.app.icon, true) : "") || Qt.resolvedUrl("assets/application.svg") }
                Row {
                    anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
                    spacing: 2
                    Repeater {
                        model: Math.min(itemButton.modelData.windows.length, 3)
                        Rectangle { width: 4; height: 3; radius: 2; color: "#88cddd" }
                    }
                }
                MouseArea {
                    id: itemHit
                    anchors.fill: parent; hoverEnabled: true; acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton) dock.openItemMenu(modelData.key, row.x + itemButton.x + itemButton.width / 2)
                        else if (modelData.windows.length) shell.send("windows.activate", { windowId: modelData.windows[0].id })
                        else shell.launch(modelData.app)
                    }
                }
                ToolTip.visible: itemHit.containsMouse && !dockPopup.visible
                ToolTip.text: modelData.app?.name || modelData.windows[0]?.title || "Application"
                ToolTip.delay: 700
            }
        }
    }
    MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true; acceptedButtons: Qt.NoButton }

    PopupWindow {
        id: dockPopup
        anchor.window: dock
        anchor.rect.x: dock.popupX
        anchor.rect.y: 0
        anchor.gravity: Edges.Top | Edges.Right
        grabFocus: true
        color: "transparent"
        implicitWidth: 270
        implicitHeight: Math.min(400, popupContent.implicitHeight + 16)
        onVisibleChanged: if (!visible) dock.popupKey = ""

        Rectangle { anchors.fill: parent; radius: 9; color: "#f02b2b2b"; border.color: "#55474747" }
        ColumnLayout {
            id: popupContent
            anchors { fill: parent; margins: 8 }
            spacing: 4
            Text {
                Layout.fillWidth: true
                text: dock.popupItem?.app?.name || dock.popupItem?.windows[0]?.title || "Application"
                color: "white"; font.bold: true; elide: Text.ElideRight; textFormat: Text.PlainText
            }
            ListView {
                id: windowList
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(count * 38, 228)
                implicitHeight: Math.min(count * 38, 228)
                clip: true
                spacing: 4
                model: dock.popupItem?.windows || []
                delegate: Rectangle {
                    id: windowButton
                    required property var modelData
                    width: windowList.width; height: 34; radius: 5
                    color: windowHit.containsMouse ? "#88cddd" : "#383838"
                    Text { anchors { fill: parent; margins: 8 } text: windowButton.modelData.title || "Window"; color: windowHit.containsMouse ? "#111111" : "#eeeeee"; elide: Text.ElideRight; textFormat: Text.PlainText }
                    MouseArea { id: windowHit; anchors.fill: parent; hoverEnabled: true; onClicked: { shell.send("windows.activate", { windowId: windowButton.modelData.id }); dockPopup.visible = false } }
                }
            }
            Rectangle {
                visible: dock.popupItem?.app !== null && dock.popupItem?.app !== undefined
                Layout.fillWidth: true; implicitHeight: 34; radius: 5; color: pinHit.containsMouse ? "#88cddd" : "#383838"
                Text { anchors.centerIn: parent; text: dock.popupItem?.pinned ? "Unpin from dock" : "Pin to dock"; color: pinHit.containsMouse ? "#111111" : "#eeeeee" }
                MouseArea { id: pinHit; anchors.fill: parent; hoverEnabled: true; onClicked: { if (dock.popupItem?.app) shell.togglePin(dock.popupItem.app.id); dockPopup.visible = false } }
            }
            Rectangle {
                visible: dock.popupItem?.app !== null && dock.popupItem?.app !== undefined
                Layout.fillWidth: true; implicitHeight: 34; radius: 5; color: launchHit.containsMouse ? "#88cddd" : "#383838"
                Text { anchors.centerIn: parent; text: "New window"; color: launchHit.containsMouse ? "#111111" : "#eeeeee" }
                MouseArea { id: launchHit; anchors.fill: parent; hoverEnabled: true; onClicked: { shell.launch(dock.popupItem?.app); dockPopup.visible = false } }
            }
        }
    }
}
