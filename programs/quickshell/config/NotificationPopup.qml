import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: popup
    required property var shell
    required property var monitor
    screen: monitor
    anchors { top: true; right: true }
    margins { top: 40; right: 8 }
    implicitWidth: 340
    implicitHeight: notificationList.implicitHeight
    visible: shell.popupNotifications.length > 0 && monitor.name === (shell.workspaceView.currentMonitor || Quickshell.screens[0]?.name)
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    Column {
        id: notificationList
        width: parent.width
        spacing: 6
        Repeater {
            model: shell.popupNotifications
            Rectangle {
                id: card
                required property var modelData
                readonly property var notification: modelData.notification
                width: notificationList.width
                height: content.implicitHeight + 20
                radius: 9
                color: "#ed29292d"
                border.color: "#554e4e53"
                Connections {
                    target: card.notification
                    function onClosed() { shell.hidePopup(card.modelData.id) }
                }
                ColumnLayout {
                    id: content
                    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        Image {
                            visible: source !== ""
                            Layout.preferredWidth: 18; Layout.preferredHeight: 18
                            source: card.notification?.appIcon ? Quickshell.iconPath(card.notification.appIcon, true) : ""
                            fillMode: Image.PreserveAspectFit
                        }
                        Text { Layout.fillWidth: true; text: card.notification?.appName || "Notification"; color: "#bcbcc1"; font.pixelSize: 11; elide: Text.ElideRight; textFormat: Text.PlainText }
                        Text {
                            text: "×"; color: closeHit.containsMouse ? "white" : "#bbbbbb"; font.pixelSize: 18
                            MouseArea { id: closeHit; anchors.fill: parent; anchors.margins: -4; hoverEnabled: true; onClicked: { let notification = card.notification; shell.hidePopup(card.modelData.id); notification?.dismiss() } }
                        }
                    }
                    Text { Layout.fillWidth: true; text: card.notification?.summary || ""; color: "white"; font.bold: true; elide: Text.ElideRight; textFormat: Text.PlainText }
                    Text { Layout.fillWidth: true; visible: text !== ""; text: card.notification?.body || ""; color: "#dddddd"; elide: Text.ElideRight; maximumLineCount: 3; wrapMode: Text.Wrap; textFormat: Text.PlainText }
                    Row {
                        spacing: 5
                        visible: children.length > 0
                        Repeater {
                            model: card.notification?.actions || []
                            Rectangle {
                                required property var modelData
                                width: actionText.implicitWidth + 18; height: 28; radius: 5
                                color: actionHit.containsMouse ? "#88cddd" : "#48484c"
                                Text { id: actionText; anchors.centerIn: parent; text: parent.modelData.text; color: actionHit.containsMouse ? "#111111" : "white"; font.pixelSize: 12 }
                                MouseArea { id: actionHit; anchors.fill: parent; hoverEnabled: true; onClicked: { let action = parent.modelData; shell.hidePopup(card.modelData.id); action.invoke() } }
                            }
                        }
                    }
                }
            }
        }
    }
}
