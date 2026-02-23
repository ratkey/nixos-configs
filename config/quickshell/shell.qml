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
            right: true
        }
        height: 32
        color: bg

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 16

            // --- Workspaces ---
            Row {
                Layout.alignment: Qt.AlignLeft
                spacing: 6

                Repeater {
                    model: Hyprland.workspaces
                    
                    Rectangle {
                        width: 24; height: 24; radius: 4
                        color: modelData.active ? yellow : bg
                        border.color: modelData.active ? yellow : gray
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.id
                            color: modelData.active ? bg : fg
                            font.family: root.fontName
                            font.pixelSize: 14
                            font.bold: modelData.active
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true } // Spacer

            // --- CPU & RAM Usage ---
            Row {
                spacing: 12
                Text { 
                    text: "󰍛 CPU: " + root.cpuText 
                    font.family: root.fontName
                    color: aqua 
                    font.pixelSize: 14
                }
                Text { 
                    text: "󰘚 RAM: " + root.ramText 
                    font.family: root.fontName
                    color: blue 
                    font.pixelSize: 14
                }
            }

            // --- Network & Volume ---
            Row {
                spacing: 12
                Text { 
                    text: "󰖩 " + root.wifiText 
                    font.family: root.fontName
                    color: green 
                    font.pixelSize: 14
                }
                Text { 
                    text: "󰕾 " + root.volumeText 
                    font.family: root.fontName
                    color: purple 
                    font.pixelSize: 14
                }
            }

            // --- Battery ---
            Text {
                text: root.batteryText
                font.family: root.fontName
                color: parseInt(root.batteryText.replace(/[^0-9]/g, '')) < 20 && !root.batteryText.includes("󰂄") ? red : fg 
                font.pixelSize: 14
            }

            // --- Time ---
            Text {
                id: clock
                color: yellow
                font.family: root.fontName
                font.pixelSize: 14
                font.bold: true

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm AP")
                }
                
                Component.onCompleted: clock.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm AP")
            }
        }
    }
}
