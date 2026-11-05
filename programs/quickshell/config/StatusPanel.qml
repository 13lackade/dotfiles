import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Item {
    id: status
    required property var shell
    required property var monitor
    required property real brightness
    property string section: "notifications"
    property var selectedNetwork: null
    property string networkError: ""
    property bool needsPassword: false
    property string pendingPair: ""
    property bool startedBluetoothScan: false
    readonly property var wifi: Networking.devices.values.find(device => device.type === DeviceType.Wifi) || null
    readonly property var connectedWifi: wifi ? wifi.networks.values.find(network => network.connected) || null : null
    readonly property var player: Mpris.players.values.find(candidate => candidate.isPlaying) || Mpris.players.values[0] || null

    function mediaTime(seconds) {
        let value = Math.max(0, Math.floor(seconds || 0))
        return Math.floor(value / 60) + ":" + String(value % 60).padStart(2, "0")
    }

    Timer {
        interval: 1000
        repeat: true
        running: status.visible && (status.player?.isPlaying ?? false)
        onTriggered: if (status.player) status.player.positionChanged()
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

    function stopDiscovery() {
        if (wifi) wifi.scannerEnabled = false
        if (startedBluetoothScan && Bluetooth.defaultAdapter)
            Bluetooth.defaultAdapter.discovering = false
        startedBluetoothScan = false
    }
    function openSection(name) {
        stopDiscovery()
        selectedNetwork = null
        needsPassword = false
        wifiPassword.text = ""
        networkError = ""
        section = name
        if (name === "wifi" && wifi && Networking.wifiEnabled) wifi.scannerEnabled = true
    }
    function beginBluetoothScan() {
        let adapter = Bluetooth.defaultAdapter
        if (adapter && adapter.enabled && !adapter.discovering) {
            adapter.discovering = true
            startedBluetoothScan = true
        }
    }
    onVisibleChanged: if (!visible) {
        stopDiscovery()
        selectedNetwork = null
        needsPassword = false
        wifiPassword.text = ""
        section = "notifications"
    }
    Component.onDestruction: stopDiscovery()

    Connections {
        target: status.selectedNetwork
        function onConnectionFailed(reason) {
            status.networkError = ConnectionFailReason.toString(reason)
            if (reason === ConnectionFailReason.NoSecrets || reason === ConnectionFailReason.WifiAuthTimeout || reason === ConnectionFailReason.WifiClientFailed) {
                status.needsPassword = true
                wifiPassword.forceActiveFocus()
            }
        }
        function onConnectedChanged() {
            if (status.selectedNetwork?.connected) {
                status.needsPassword = false
                wifiPassword.text = ""
            }
        }
    }

    component Card: Rectangle {
        color: "#f02b2b2b"
        radius: 9
    }
    component SmallButton: Rectangle {
        id: button
        property string label: ""
        signal clicked()
        implicitWidth: caption.implicitWidth + 20
        implicitHeight: 27
        radius: 6
        color: hit.containsMouse ? "#555555" : "#3a3a3a"
        Text { id: caption; anchors { fill: parent; leftMargin: 10; rightMargin: 10 } verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; text: button.label; color: "#f5f5f5"; font.pixelSize: 11; elide: Text.ElideRight; textFormat: Text.PlainText }
        MouseArea { id: hit; anchors.fill: parent; hoverEnabled: true; onClicked: button.clicked() }
    }
    component StatusSlider: Slider {
        id: slider
        implicitHeight: 26
        from: 0
        to: 1
        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 4
            radius: 2
            color: "#454545"
            Rectangle { width: slider.visualPosition * parent.width; height: parent.height; radius: 2; color: "#88cddd" }
        }
        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: 14; height: 14; radius: 7; color: "#88cddd"
        }
    }

    ColumnLayout {
        anchors { fill: parent; margins: 8 }
        spacing: 8

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ColumnLayout {
                anchors { fill: parent; margins: 10 }
                spacing: 7
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 6; columnSpacing: 6
                    AccentButton {
                        Layout.fillWidth: true
                        label: status.connectedWifi ? status.connectedWifi.name : Networking.wifiEnabled ? "Wi-Fi" : "Wi-Fi off"
                        icon: Networking.wifiEnabled ? "wifi-full" : "wifi-off"
                        selected: status.section === "wifi"
                        chevron: true
                        onClicked: status.openSection("wifi")
                    }
                    AccentButton {
                        Layout.fillWidth: true
                        label: Bluetooth.defaultAdapter ? (Bluetooth.defaultAdapter.enabled ? "Bluetooth on" : "Bluetooth off") : "Bluetooth"
                        icon: "bluetooth"
                        selected: status.section === "bluetooth"
                        chevron: true
                        onClicked: status.openSection("bluetooth")
                    }
                    AccentButton {
                        Layout.fillWidth: true
                        label: PowerProfile.toString(PowerProfiles.profile)
                        icon: PowerProfiles.profile === PowerProfile.PowerSaver ? "leaf" : PowerProfiles.profile === PowerProfile.Performance ? "lightning" : "balanced"
                        selected: status.section === "power"
                        chevron: true
                        onClicked: status.openSection("power")
                    }
                    AccentButton {
                        Layout.fillWidth: true
                        label: "Notifications"
                        icon: shell.notificationsSilent ? "bell-no" : "bell"
                        selected: status.section === "notifications"
                        chevron: true
                        onClicked: status.openSection("notifications")
                    }
                }
                Rectangle { Layout.fillWidth: true; height: 1; color: "#484848" }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    ColumnLayout {
                        anchors.fill: parent
                        visible: status.section === "notifications"
                        RowLayout {
                            Layout.fillWidth: true
                            Text { Layout.fillWidth: true; text: "Notifications (" + shell.notifications.length + ")"; color: "#f5f5f5"; font.bold: true; font.pixelSize: 13 }
                            SmallButton { label: shell.notificationsSilent ? "Silent: on" : "Silent"; onClicked: shell.notificationsSilent = !shell.notificationsSilent }
                            SmallButton { label: "Clear"; onClicked: { shell.popupNotifications = []; for (let n of shell.notifications.slice()) n.dismiss() } }
                        }
                        Text { Layout.fillWidth: true; Layout.fillHeight: true; visible: shell.notifications.length === 0; text: "No notifications"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; color: "#aaaaaa"; font.pixelSize: 12 }
                        ListView {
                            id: notifications
                            Layout.fillWidth: true; Layout.fillHeight: true
                            visible: shell.notifications.length > 0
                            clip: true; spacing: 4; model: shell.notifications
                            delegate: Rectangle {
                                id: row
                                required property var modelData
                                width: notifications.width; height: Math.max(58, notificationContent.implicitHeight + 16)
                                radius: 6; color: "#393939"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: shell.activateNotification(row.modelData)
                                }
                                Column {
                                    id: notificationContent
                                    anchors { fill: parent; margins: 8 }
                                    Text { width: parent.width - 24; text: row.modelData.summary; color: "#f5f5f5"; font.bold: true; elide: Text.ElideRight; textFormat: Text.PlainText }
                                    Text { width: parent.width; text: row.modelData.body; color: "#c0c0c0"; elide: Text.ElideRight; textFormat: Text.PlainText }
                                    Flow {
                                        id: notificationActions
                                        width: parent.width
                                        spacing: 4
                                        Repeater {
                                            model: row.modelData.actions
                                            SmallButton { required property var modelData; required property int index; width: Math.min(implicitWidth, notificationActions.width); label: shell.notificationActionLabel(modelData, index); onClicked: modelData.invoke() }
                                        }
                                    }
                                }
                                Text {
                                    anchors { top: parent.top; right: parent.right; margins: 7 }
                                    text: "×"; color: "#cccccc"; font.pixelSize: 18
                                    MouseArea { anchors.fill: parent; anchors.margins: -5; onClicked: { shell.hidePopup(row.modelData.id); row.modelData.dismiss() } }
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        visible: status.section === "wifi"
                        RowLayout {
                            Layout.fillWidth: true
                            Text { Layout.fillWidth: true; text: "Wi-Fi"; color: "white"; font.bold: true }
                            SmallButton {
                                label: Networking.wifiEnabled ? "On" : "Off"
                                onClicked: {
                                    Networking.wifiEnabled = !Networking.wifiEnabled
                                    if (status.wifi) status.wifi.scannerEnabled = Networking.wifiEnabled
                                }
                            }
                        }
                        Text { Layout.fillWidth: true; visible: !status.wifi; text: "No Wi-Fi adapter"; color: "#aaaaaa"; font.pixelSize: 12 }
                        Text { Layout.fillWidth: true; visible: status.wifi && !Networking.wifiHardwareEnabled; text: "Wi-Fi is disabled by a hardware switch"; color: "#d5a77e"; wrapMode: Text.Wrap; font.pixelSize: 12 }
                        Text { Layout.fillWidth: true; visible: status.networkError !== ""; text: status.networkError; color: "#ef9a9a"; wrapMode: Text.Wrap; font.pixelSize: 12 }
                        ListView {
                            id: networks
                            Layout.fillWidth: true; Layout.fillHeight: true
                            clip: true; spacing: 3
                            model: status.wifi && Networking.wifiEnabled ? status.wifi.networks.values : []
                            delegate: Rectangle {
                                required property var modelData
                                width: networks.width; height: 38; radius: 5
                                color: wifiHit.containsMouse ? "#484848" : "transparent"
                                RowLayout {
                                    anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
                                    StatusIcon { icon: modelData.signalStrength >= 0.7 ? "wifi-full" : modelData.signalStrength >= 0.4 ? "wifi-midium" : "wifi-low"; iconSize: 16 }
                                    Text { Layout.fillWidth: true; text: modelData.name || "<hidden>"; color: "white"; elide: Text.ElideRight; textFormat: Text.PlainText }
                                    Text { text: modelData.stateChanging ? "Connecting…" : modelData.connected ? "Connected" : modelData.security === WifiSecurityType.Open ? "Open" : "🔒"; color: "#bbbbbb"; font.pixelSize: 11 }
                                }
                                MouseArea {
                                    id: wifiHit; anchors.fill: parent; hoverEnabled: true
                                    onClicked: {
                                        status.networkError = ""
                                        wifiPassword.text = ""
                                        status.needsPassword = false
                                        if (modelData.connected) {
                                            status.selectedNetwork = null
                                            modelData.disconnect()
                                        } else {
                                            status.selectedNetwork = modelData
                                            if (modelData.known || modelData.security === WifiSecurityType.Open || modelData.security === WifiSecurityType.Owe) modelData.connect()
                                            else if (modelData.security === WifiSecurityType.WpaPsk || modelData.security === WifiSecurityType.Wpa2Psk || modelData.security === WifiSecurityType.Sae) {
                                                status.needsPassword = true
                                                wifiPassword.forceActiveFocus()
                                            } else status.networkError = "Use network settings for this security type"
                                        }
                                    }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            visible: status.needsPassword && status.selectedNetwork && !status.selectedNetwork.connected
                            Rectangle {
                                Layout.fillWidth: true; Layout.preferredHeight: 30; radius: 5; color: "#454545"
                                TextInput {
                                    id: wifiPassword
                                    anchors { fill: parent; margins: 7 }
                                    echoMode: TextInput.Password; color: "white"; clip: true
                                    onAccepted: { if (status.selectedNetwork && text) { status.selectedNetwork.connectWithPsk(text); text = "" } }
                                    Text { anchors.fill: parent; visible: !wifiPassword.text; text: "Password for " + (status.selectedNetwork?.name || ""); color: "#aaaaaa"; elide: Text.ElideRight }
                                }
                            }
                            SmallButton { label: "Connect"; onClicked: { if (status.selectedNetwork && wifiPassword.text) { status.selectedNetwork.connectWithPsk(wifiPassword.text); wifiPassword.text = "" } } }
                        }
                        SmallButton { label: "Network settings"; onClicked: Quickshell.execDetached(["nm-connection-editor"]) }
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        visible: status.section === "bluetooth"
                        RowLayout {
                            Layout.fillWidth: true
                            Text { Layout.fillWidth: true; text: "Bluetooth"; color: "white"; font.bold: true }
                            SmallButton { label: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"; onClicked: if (Bluetooth.defaultAdapter) Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled }
                            SmallButton { label: Bluetooth.defaultAdapter?.discovering ? "Scanning…" : "Scan"; onClicked: status.beginBluetoothScan() }
                        }
                        Text { Layout.fillWidth: true; visible: !Bluetooth.defaultAdapter; text: "No Bluetooth adapter"; color: "#aaaaaa"; font.pixelSize: 12 }
                        ListView {
                            id: devices
                            Layout.fillWidth: true; Layout.fillHeight: true; clip: true; spacing: 3
                            model: Bluetooth.defaultAdapter?.devices || null
                            delegate: Rectangle {
                                id: deviceRow
                                required property var modelData
                                width: devices.width; height: 39; radius: 5; color: deviceHit.containsMouse ? "#484848" : "transparent"
                                Connections {
                                    target: deviceRow.modelData
                                    function onPairedChanged() {
                                        if (deviceRow.modelData.paired && status.pendingPair === deviceRow.modelData.address) {
                                            status.pendingPair = ""
                                            deviceRow.modelData.connect()
                                        }
                                    }
                                }
                                RowLayout {
                                    anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                                    Image { Layout.preferredWidth: 18; Layout.preferredHeight: 18; source: Quickshell.iconPath(deviceRow.modelData.icon, "bluetooth") }
                                    Text { Layout.fillWidth: true; text: deviceRow.modelData.name || deviceRow.modelData.address; color: "white"; elide: Text.ElideRight; textFormat: Text.PlainText }
                                    Text { text: deviceRow.modelData.pairing ? "Pairing…" : deviceRow.modelData.connected ? "Connected" : deviceRow.modelData.paired ? "Paired" : "Pair"; color: "#bbbbbb"; font.pixelSize: 11 }
                                }
                                MouseArea {
                                    id: deviceHit; anchors.fill: parent; hoverEnabled: true
                                    onClicked: {
                                        if (deviceRow.modelData.connected) deviceRow.modelData.disconnect()
                                        else if (deviceRow.modelData.paired) deviceRow.modelData.connect()
                                        else { status.pendingPair = deviceRow.modelData.address; deviceRow.modelData.pair() }
                                    }
                                }
                            }
                        }
                        SmallButton { label: "Bluetooth settings"; onClicked: Quickshell.execDetached(["blueman-manager"]) }
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        visible: status.section === "power"
                        Text { text: "Power profile"; color: "white"; font.bold: true }
                        AccentButton { Layout.fillWidth: true; label: "Power saver"; icon: "leaf"; selected: PowerProfiles.profile === PowerProfile.PowerSaver; onClicked: PowerProfiles.profile = PowerProfile.PowerSaver }
                        AccentButton { Layout.fillWidth: true; label: "Balanced"; icon: "balanced"; selected: PowerProfiles.profile === PowerProfile.Balanced; onClicked: PowerProfiles.profile = PowerProfile.Balanced }
                        AccentButton { Layout.fillWidth: true; visible: PowerProfiles.hasPerformanceProfile; label: "Performance"; icon: "lightning"; selected: PowerProfiles.profile === PowerProfile.Performance; onClicked: PowerProfiles.profile = PowerProfile.Performance }
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: status.brightness >= 0 ? 98 : 54
            ColumnLayout {
                anchors { fill: parent; margins: 8 }
                RowLayout {
                    Layout.fillWidth: true
                    StatusIcon { icon: Pipewire.defaultAudioSink?.audio?.muted ? "volume-off" : "volume"; iconSize: 16
                        MouseArea { anchors.fill: parent; onClicked: if (Pipewire.defaultAudioSink?.audio) Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted }
                    }
                    Text { text: Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100); color: "#dddddd"; font.pixelSize: 11; Layout.preferredWidth: 28 }
                    StatusSlider { Layout.fillWidth: true; value: Pipewire.defaultAudioSink?.audio?.volume ?? 0; onMoved: if (Pipewire.defaultAudioSink?.audio) Pipewire.defaultAudioSink.audio.volume = value }
                }
                RowLayout {
                    Layout.fillWidth: true; visible: status.brightness >= 0
                    StatusIcon { icon: "sun"; iconSize: 16 }
                    Text { text: Math.round(Math.max(0, status.brightness) * 100); color: "#dddddd"; font.pixelSize: 11; Layout.preferredWidth: 28 }
                    StatusSlider { Layout.fillWidth: true; value: Math.max(0, status.brightness); onMoved: Quickshell.execDetached(["brightnessctl", "-c", "backlight", "set", Math.max(1, Math.round(value * 100)) + "%"]) }
                }
            }
        }
        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 155
            ColumnLayout {
                anchors { fill: parent; margins: 10 }
                spacing: 5
                RowLayout {
                    Layout.fillWidth: true
                    Image { Layout.preferredWidth: 42; Layout.preferredHeight: 42; source: status.player?.trackArtUrl || ""; fillMode: Image.PreserveAspectCrop; visible: source !== "" }
                    StatusIcon { visible: !status.player?.trackArtUrl; icon: "music"; iconSize: 36 }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { Layout.fillWidth: true; text: status.player?.trackTitle || "No media"; color: "white"; font.bold: true; elide: Text.ElideRight }
                        Text { Layout.fillWidth: true; text: status.player?.trackArtist || "Open a player"; color: "#bbbbbb"; font.pixelSize: 11; elide: Text.ElideRight }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: status.mediaTime(status.player?.position); color: "#aaaaaa"; font.pixelSize: 10 }
                    StatusSlider {
                        Layout.fillWidth: true
                        enabled: (status.player?.canSeek ?? false) && (status.player?.positionSupported ?? false) && (status.player?.lengthSupported ?? false)
                        value: (status.player?.length ?? 0) > 0 ? Math.min(1, (status.player?.position ?? 0) / status.player.length) : 0
                        onMoved: if (enabled && status.player) status.player.position = value * status.player.length
                    }
                    Text { text: status.mediaTime(status.player?.length); color: "#aaaaaa"; font.pixelSize: 10 }
                }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    SmallButton { label: "⏮"; onClicked: if (status.player?.canGoPrevious) status.player.previous() }
                    SmallButton { label: status.player?.isPlaying ? "❚❚" : "▶"; onClicked: if (status.player?.canTogglePlaying) status.player.togglePlaying() }
                    SmallButton { label: "⏭"; onClicked: if (status.player?.canGoNext) status.player.next() }
                }
            }
        }
    }
}
