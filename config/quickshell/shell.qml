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

    readonly property string fontName: "JetBrainsMono Nerd Font"

    // Map window class to nerd font icon
    function getAppIcon(windowClass) {
        if (!windowClass) return ""
        let cls = windowClass.toLowerCase()
        if (cls.includes("kitty") || cls.includes("alacritty") || cls.includes("foot") || cls.includes("terminal") || cls.includes("konsole")) return ""
        if (cls.includes("firefox") || cls.includes("librewolf")) return ""
        if (cls.includes("chrome") || cls.includes("chromium") || cls.includes("brave")) return ""
        if (cls.includes("code") || cls.includes("vscodium")) return "󰨞"
        if (cls.includes("discord")) return "󰙯"
        if (cls.includes("spotify")) return ""
        if (cls.includes("steam")) return ""
        if (cls.includes("obsidian")) return "󰠮"
        if (cls.includes("thunar") || cls.includes("nautilus") || cls.includes("dolphin") || cls.includes("files")) return ""
        if (cls.includes("gimp") || cls.includes("krita")) return ""
        if (cls.includes("blender")) return "󰂫"
        if (cls.includes("telegram")) return ""
        if (cls.includes("slack")) return "󰒱"
        if (cls.includes("nvim") || cls.includes("neovim") || cls.includes("vim")) return ""
        if (cls.includes("mpv") || cls.includes("vlc")) return "󰕼"
        if (cls.includes("zathura") || cls.includes("evince") || cls.includes("pdf")) return ""
        if (cls.includes("thunderbird") || cls.includes("mail")) return "󰇮"
        if (cls.includes("vesktop")) return "󰙯"
        return ""
    }

    // Get focused window class for a workspace
    function getWorkspaceWindowClass(workspaceId) {
        for (let i = 0; i < Hyprland.windows.values.length; i++) {
            let win = Hyprland.windows.values[i]
            if (win.workspace && win.workspace.id === workspaceId && win.focused) {
                return win.wm_class || ""
            }
        }
        // If no focused window, get the first window in workspace
        for (let i = 0; i < Hyprland.windows.values.length; i++) {
            let win = Hyprland.windows.values[i]
            if (win.workspace && win.workspace.id === workspaceId) {
                return win.wm_class || ""
            }
        }
        return ""
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

    // Run everything once on launch
    Component.onCompleted: {
        cpuProc.running = true
        ramProc.running = true
        volProc.running = true
        wifiProc.running = true
        batProc.running = true
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
                        property string windowClass: root.getWorkspaceWindowClass(wsId)
                        property string appIcon: root.getAppIcon(windowClass)
                        width: 32; height: 32; radius: 4
                        color: wsActive ? yellow : bg
                        border.color: wsActive ? yellow : gray
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: wsButton.appIcon !== "" ? wsButton.appIcon : wsButton.wsId
                            color: wsButton.wsActive ? bg : fg
                            font.family: root.fontName
                            font.pixelSize: wsButton.appIcon !== "" ? 16 : 14
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
}
