import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    id: root // We need this ID to reference properties from inside our processes

    // Gruvbox Dark Palette
    readonly property color bg: "#282828"
    readonly property color fg: "#ebdbb2"
    readonly property color gray: "#928374"
    readonly property color red: "#cc241d"
    readonly property color green: "#98971a"
    readonly property color yellow: "#d79921"
    readonly property color blue: "#458588"
    readonly property color purple: "#b16286"
    readonly property color aqua: "#689d6a"

    // --- State Properties ---
    property string cpuText: "--%"
    property string ramText: "--%"
    property string volumeText: "--%"
    property string wifiText: "Checking..."
    property string batteryText: "󰁹 --%"

    // Wallpaper state
    property var wallpaperList: []
    property bool wallpaperPanelVisible: false
    property string wallpaperDir: "/home/cother/walls"
    property string lastToggleValue: ""

    readonly property string fontName: "JetBrainsMono Nerd Font"

    // Workspace colors cycling through Gruvbox palette
    readonly property var wsColors: [red, green, yellow, blue, purple, aqua]
    function getWsColor(wsId) {
        return wsColors[(wsId - 1) % wsColors.length]
    }

    // --- Background Processes (Timer-driven) ---

    // CPU Process
    Process {
        id: cpuProc
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print int(100 - $1)\"%\"}'"]
        stdout: StdioCollector {
            // .trim() removes the trailing newline from bash
            onStreamFinished: root.cpuText = this.text.trim()
        }
    }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: cpuProc.running = true }

    // RAM Process
    Process {
        id: ramProc
        command: ["bash", "-c", "free | grep Mem | awk '{print int($3/$2 * 100)\"%\"}'"]
        stdout: StdioCollector {
            onStreamFinished: root.ramText = this.text.trim()
        }
    }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: ramProc.running = true }

    // Volume Process
    Process {
        id: volProc
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)\"%\"}'"]
        stdout: StdioCollector {
            onStreamFinished: root.volumeText = this.text.trim()
        }
    }
    Timer { interval: 1000; running: true; repeat: true; onTriggered: volProc.running = true }

    // Wi-Fi Process (Using NetworkManager)
    Process {
        id: wifiProc
        // Grabs the active Wi-Fi connection's SSID. If empty, outputs "Disconnected"
        command: [
            "bash", 
            "-c", 
            "ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 | head -n 1); if [ -n \"$ssid\" ]; then echo \"$ssid\"; else echo 'Disconnected'; fi"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                let output = this.text.trim()
                root.wifiText = output !== "" ? output : "Disconnected"
            }
        }
    }
    Timer { interval: 5000; running: true; repeat: true; onTriggered: wifiProc.running = true }

    // Battery Process
    Process {
        id: batProc
        command: ["bash", "-c", "status=$(cat /sys/class/power_supply/BAT*/status | head -1); cap=$(cat /sys/class/power_supply/BAT*/capacity | head -1); if [ \"$status\" = \"Charging\" ]; then echo \"󰂄 $cap%\"; else echo \"󰁹 $cap%\"; fi"]
        stdout: StdioCollector {
            onStreamFinished: root.batteryText = this.text.trim()
        }
    }
    Timer { interval: 10000; running: true; repeat: true; onTriggered: batProc.running = true }

    // Wallpaper List Process
    Process {
        id: wallpaperListProc
        command: ["bash", "-c", "ls -1 " + root.wallpaperDir + "/*.{jpg,jpeg,png,gif,webp} 2>/dev/null | sort"]
        stdout: StdioCollector {
            onStreamFinished: {
                let output = this.text.trim()
                if (output !== "") {
                    root.wallpaperList = output.split("\n")
                }
            }
        }
    }

    // Wallpaper Set Process (dynamically set command)
    Process {
        id: wallpaperSetProc
        property string wallpaperPath: ""
        command: ["swww", "img", wallpaperPath, "--transition-type", "grow", "--transition-pos", "center", "--transition-duration", "1"]
    }

    // IPC: Watch for toggle signal from Hyprland keybind
    Process {
        id: toggleWatchProc
        command: ["cat", "/tmp/qs-wallpaper-toggle"]
        stdout: StdioCollector {
            onStreamFinished: {
                let val = this.text.trim()
                if (val !== "" && val !== root.lastToggleValue) {
                    root.lastToggleValue = val
                    root.wallpaperPanelVisible = !root.wallpaperPanelVisible
                    if (root.wallpaperPanelVisible) {
                        wallpaperListProc.running = true
                    }
                }
            }
        }
    }
    Timer { interval: 100; running: true; repeat: true; onTriggered: toggleWatchProc.running = true }

    // Initialize lastToggleValue from file to prevent false toggle on startup
    Process {
        id: initToggleProc
        command: ["cat", "/tmp/qs-wallpaper-toggle"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.lastToggleValue = this.text.trim()
            }
        }
    }

    // Run everything once on launch
    Component.onCompleted: {
        initToggleProc.running = true
        cpuProc.running = true
        ramProc.running = true
        volProc.running = true
        wifiProc.running = true
        batProc.running = true
        wallpaperListProc.running = true
    }

    // --- UI Layout ---

    PanelWindow {
        anchors {
            top: true
            left: true
            bottom: true
        }
        implicitWidth: 48
        color: Qt.rgba(40/255, 40/255, 40/255, 0.50)

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            spacing: 0

            // --- Workspaces (Top) ---
            Column {
                Layout.alignment: Qt.AlignHCenter
                spacing: 6

                Repeater {
                    model: Hyprland.workspaces

                    Rectangle {
                        id: wsButton
                        property int wsId: modelData.id
                        property bool wsActive: modelData.active
                        property color wsColor: root.getWsColor(wsId)
                        width: 32; height: 32; radius: 4
                        color: wsActive ? wsColor : bg
                        border.color: wsActive ? wsColor : gray
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: wsButton.wsId
                            color: wsButton.wsActive ? bg : wsButton.wsColor
                            font.family: root.fontName
                            font.pixelSize: 14
                            font.bold: wsButton.wsActive
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Hyprland.dispatch("workspace " + wsButton.wsId)
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true } // Spacer

            // --- Wallpaper Button ---
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 8
                width: 36
                height: 36
                radius: 6
                color: root.wallpaperPanelVisible ? root.yellow : Qt.rgba(40/255, 40/255, 40/255, 0.85)
                border.color: root.yellow
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "󰸉"
                    font.family: root.fontName
                    font.pixelSize: 18
                    color: root.wallpaperPanelVisible ? root.bg : root.yellow
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.wallpaperPanelVisible = !root.wallpaperPanelVisible
                        if (root.wallpaperPanelVisible) {
                            wallpaperListProc.running = true
                        }
                    }
                }
            }

            // --- System Indicators (Bottom) ---
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 40
                height: indicatorColumn.height + 16
                radius: 6
                color: Qt.rgba(40/255, 40/255, 40/255, 0.85)

                Column {
                    id: indicatorColumn
                    anchors.centerIn: parent
                    spacing: 8

                    // CPU
                    Column {
                        width: 32
                        spacing: 2
                        Text {
                            text: "󰍛"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: aqua
                            font.pixelSize: 18
                        }
                        Text {
                            text: root.cpuText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: aqua
                            font.pixelSize: 10
                        }
                    }

                    // RAM
                    Column {
                        width: 32
                        spacing: 2
                        Text {
                            text: "󰘚"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: blue
                            font.pixelSize: 18
                        }
                        Text {
                            text: root.ramText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: blue
                            font.pixelSize: 10
                        }
                    }

                    // Wi-Fi
                    Column {
                        width: 32
                        spacing: 2
                        Text {
                            text: root.wifiText === "Disconnected" ? "󰖪" : "󰖩"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: root.wifiText === "Disconnected" ? gray : green
                            font.pixelSize: 18
                        }
                    }

                    // Volume
                    Column {
                        width: 32
                        spacing: 2
                        Text {
                            text: root.volumeText === "0%" ? "󰖁" : "󰕾"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: purple
                            font.pixelSize: 18
                        }
                        Text {
                            text: root.volumeText
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: purple
                            font.pixelSize: 10
                        }
                    }

                    // Battery
                    Column {
                        width: 32
                        property int batLevel: parseInt(root.batteryText.replace(/[^0-9]/g, '')) || 0
                        property bool isCharging: root.batteryText.includes("󰂄")
                        spacing: 2
                        Text {
                            text: parent.isCharging ? "󰂄" : (parent.batLevel < 20 ? "󰁺" : "󰁹")
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: (!parent.isCharging && parent.batLevel < 20) ? red : fg
                            font.pixelSize: 18
                        }
                        Text {
                            text: parent.batLevel + "%"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: root.fontName
                            color: (!parent.isCharging && parent.batLevel < 20) ? red : fg
                            font.pixelSize: 10
                        }
                    }
                }
            }

            // --- Clock (Bottom) ---
            Column {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 12
                spacing: 2

                Text {
                    id: clockHour
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: yellow
                    font.family: root.fontName
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    id: clockMin
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: yellow
                    font.family: root.fontName
                    font.pixelSize: 14
                    font.bold: true
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        let now = new Date()
                        clockHour.text = now.toLocaleTimeString(Qt.locale(), "hh")
                        clockMin.text = now.toLocaleTimeString(Qt.locale(), "mm")
                    }
                }

                Component.onCompleted: {
                    let now = new Date()
                    clockHour.text = now.toLocaleTimeString(Qt.locale(), "hh")
                    clockMin.text = now.toLocaleTimeString(Qt.locale(), "mm")
                }
            }
        }
    }

    // --- Wallpaper Selector Panel (Full Height, Keyboard Navigable) ---
    PanelWindow {
        id: wallpaperPanel
        visible: root.wallpaperPanelVisible
        anchors {
            top: true
            left: true
            bottom: true
        }
        margins.left: 0
        implicitWidth: 520
        color: Qt.rgba(40/255, 40/255, 40/255, 0.50)

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // Header (styled like system indicators)
                Rectangle {
                    width: parent.width
                    height: 48
                    radius: 6
                    color: Qt.rgba(40/255, 40/255, 40/255, 0.85)

                    // Left side: icon + title
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Text {
                            text: "󰸉"
                            font.family: root.fontName
                            font.pixelSize: 22
                            color: root.yellow
                        }

                        Text {
                            text: "Wallpapers"
                            font.family: root.fontName
                            font.pixelSize: 14
                            font.bold: true
                            color: root.fg
                        }
                    }

                }

                // Wallpaper Grid
                Flickable {
                    id: wallpaperFlickable
                    width: parent.width
                    height: parent.height - 60
                    contentHeight: wallpaperGrid.height
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    Grid {
                        id: wallpaperGrid
                        width: parent.width
                        columns: 3
                        spacing: 12

                        Repeater {
                            model: root.wallpaperList

                            Rectangle {
                                id: wallpaperItem
                                width: 156
                                height: 108
                                radius: 8
                                color: root.bg
                                border.color: wallItemArea.containsMouse ? root.aqua : root.gray
                                border.width: wallItemArea.containsMouse ? 2 : 1
                                clip: true

                                Image {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    source: "file://" + modelData
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                }

                                // Filename overlay
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: 3
                                    height: 24
                                    radius: 5
                                    color: Qt.rgba(40/255, 40/255, 40/255, 0.9)

                                    Text {
                                        anchors.centerIn: parent
                                        width: parent.width - 10
                                        text: modelData.split("/").pop().replace(/\.[^/.]+$/, "")
                                        font.family: root.fontName
                                        font.pixelSize: 11
                                        color: root.fg
                                        elide: Text.ElideMiddle
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    id: wallItemArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        wallpaperSetProc.wallpaperPath = modelData
                                        wallpaperSetProc.running = true
                                        root.wallpaperPanelVisible = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
