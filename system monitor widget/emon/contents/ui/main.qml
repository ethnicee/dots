import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.ksysguard.sensors as Sensors

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: fullRepresentation

    fullRepresentation: Item {
        id: container
        anchors.fill: parent

        property real s: Math.max(height / 65, 0.5)
        readonly property string fontFam: "Hack"

        property color cpuColor: "#7aa2f7"
        property color gpuColor: "#bd93f9"

        Sensors.Sensor { id: cpuUsage; sensorId: "cpu/all/usage" }
        Sensors.Sensor { id: gpuUsage; sensorId: "gpu/all/usage" }

        property real realCpu: cpuUsage.value || 0
        property real realGpu: gpuUsage.value || 0

        function pad(v) {
            let t = Math.round(v).toString()
            if (t.length === 1) return "  " + t
                if (t.length === 2) return " " + t
                    return t
        }

        function getBarText(val, targetWidth) {
            // Using a slightly more precise character width for Hack
            let charWidth = (10 * s) * 0.605
            let len = Math.floor(targetWidth / charWidth)

            if (len <= 0) return ""

                // Use Math.ceil so that 99.1% fills the last block
                let filled = Math.ceil((val / 100) * len)

                if (val > 0 && filled === 0) filled = 1
                    if (filled > len) filled = len

                        let out = ""
                        for (let i = 0; i < len; i++) {
                            out += (i < filled) ? "█" : " "
                        }
                        return out
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#444"
                opacity: 0.4
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4 * s
                Layout.bottomMargin: 4 * s
                Layout.leftMargin: 8 * s
                Layout.rightMargin: 8 * s
                spacing: 2 * s

                // CPU Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0 // We handle spacing via margins now

                    Text {
                        text: "CPU"
                        Layout.preferredWidth: 35 * s // Fixed width for labels
                        color: cpuColor
                        font { family: fontFam; pixelSize: 10 * s; bold: true }
                    }

                    Text {
                        id: cpuBarText
                        Layout.fillWidth: true
                        Layout.rightMargin: 4 * s // Small gap before percentage
                        text: getBarText(realCpu, width)
                        color: cpuColor
                        font { family: fontFam; pixelSize: 10 * s }
                        elide: Text.ElideNone
                        horizontalAlignment: Text.AlignLeft
                    }

                    Text {
                        text: pad(realCpu) + "%"
                        color: "#ffffff"
                        font { family: fontFam; pixelSize: 10 * s }
                    }
                }

                // GPU Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "GPU"
                        Layout.preferredWidth: 35 * s
                        color: gpuColor
                        font { family: fontFam; pixelSize: 10 * s; bold: true }
                    }

                    Text {
                        id: gpuBarText
                        Layout.fillWidth: true
                        Layout.rightMargin: 4 * s
                        text: getBarText(realGpu, width)
                        color: gpuColor
                        font { family: fontFam; pixelSize: 10 * s }
                        elide: Text.ElideNone
                        horizontalAlignment: Text.AlignLeft
                    }

                    Text {
                        text: pad(realGpu) + "%"
                        color: "#ffffff"
                        font { family: fontFam; pixelSize: 10 * s }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#444"
                opacity: 0.4
            }
        }
    }
}
