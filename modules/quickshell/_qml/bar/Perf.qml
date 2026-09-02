pragma ComponentBehavior: Bound
import QtQuick
import qs
import qs.lib
import qs.services

Item {
    id: root

    readonly property real memPct: (Metrics.memUsed / Math.max(Metrics.memTotal, 1)) * 100
    readonly property int cpuLevel: root.severity(Metrics.cpuPct, 70, 90)
    readonly property int tempLevel: root.severity(Metrics.tempC, 75, 90)
    readonly property int memLevel: root.severity(root.memPct, 80, 92)

    function severity(value, warning, critical) {
        if (value >= critical)
            return 2;
        if (value >= warning)
            return 1;
        return 0;
    }

    function severityColor(level) {
        if (level === 2)
            return Config.base08;
        if (level === 1)
            return Config.base0A;
        return Config.base04;
    }

    function tint(level) {
        return level > 0 ? root.severityColor(level) : Config.base0D;
    }

    function capacity(blocks) {
        const gib = blocks / 1048576;
        return gib >= 1024 ? `${(gib / 1024).toFixed(1)}T` : `${gib.toFixed(0)}G`;
    }

    implicitWidth: readout.implicitWidth
    implicitHeight: readout.implicitHeight

    Text {
        id: readout

        text: "󰓅"
        color: root.severityColor(root.severity(Math.max(Metrics.cpuPct, root.memPct - 10), 70, 90))
        font.family: Config.iconFamily
        font.pixelSize: Config.fontSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: popup.visible = !popup.visible
        }
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "System"
        minWidth: 280
        visible: false

        headerContent: [
            TextAction {
                visible: Config.systemMonitorCommand !== ""
                text: "󱂬 monitor"
                onTriggered: {
                    Config.launchApp(Config.systemMonitorCommand);
                    popup.visible = false;
                }
            }
        ]

        Column {
            id: cards

            readonly property real innerWidth: width - leftPadding - rightPadding

            width: parent ? parent.width : implicitWidth
            spacing: Theme.gap
            leftPadding: Theme.gap
            rightPadding: Theme.gap
            bottomPadding: Theme.gap

            CompoundPill {
                width: cards.innerWidth
                showExpandArea: false
                hoverable: Config.processorCommand !== ""
                iconName: "󰻠"
                primaryText: "CPU"
                secondaryText: `${Metrics.cpuPct}%`
                isActive: true
                accentColor: root.tint(root.cpuLevel)
                meterValue: Metrics.cpuPct / 100
                meterColor: root.tint(root.cpuLevel)
                onToggled: {
                    Config.launchApp(Config.processorCommand);
                    popup.visible = false;
                }
            }

            CompoundPill {
                width: cards.innerWidth
                showExpandArea: false
                hoverable: Config.temperatureCommand !== ""
                iconName: "󰔏"
                primaryText: Metrics.tempChip
                secondaryText: `${Metrics.tempC}°C`
                isActive: true
                accentColor: root.tint(root.tempLevel)
                meterValue: Metrics.tempC / 100
                meterColor: root.tint(root.tempLevel)
                onToggled: {
                    Config.launchApp(Config.temperatureCommand);
                    popup.visible = false;
                }
            }

            CompoundPill {
                width: cards.innerWidth
                showExpandArea: false
                hoverable: Config.memoryCommand !== ""
                iconName: ""
                primaryText: "Memory"
                secondaryText: `${Metrics.memUsed.toFixed(1)}G / ${Metrics.memTotal.toFixed(1)}G`
                isActive: true
                accentColor: root.tint(root.memLevel)
                meterValue: root.memPct / 100
                meterColor: root.tint(root.memLevel)
                onToggled: {
                    Config.launchApp(Config.memoryCommand);
                    popup.visible = false;
                }
            }

            Repeater {
                model: Metrics.diskNames

                CompoundPill {
                    id: diskCard

                    required property string modelData

                    readonly property var info: Metrics.disks[diskCard.modelData]
                    readonly property int busy: diskCard.info ? diskCard.info.busy : 0
                    readonly property real usedK: diskCard.info ? diskCard.info.usedK : 0
                    readonly property real totalK: diskCard.info ? diskCard.info.totalK : 0
                    readonly property int ioLevel: root.severity(diskCard.busy, 80, 92)
                    readonly property int capLevel: diskCard.totalK > 0 ? root.severity(diskCard.usedK / diskCard.totalK * 100, 80, 92) : 0

                    width: cards.innerWidth
                    showExpandArea: false
                    hoverable: Config.diskCommand !== ""
                    iconName: "󰋊"
                    primaryText: diskCard.modelData
                    secondaryText: diskCard.totalK > 0 ? `${diskCard.busy}% busy  ${root.capacity(diskCard.usedK)} / ${root.capacity(diskCard.totalK)}` : `${diskCard.busy}% busy  not mounted`
                    isActive: true
                    accentColor: root.tint(Math.max(diskCard.ioLevel, diskCard.capLevel))
                    meterValue: diskCard.busy / 100
                    meterColor: root.tint(diskCard.ioLevel)
                    subMeterValue: diskCard.totalK > 0 ? diskCard.usedK / diskCard.totalK : -1
                    subMeterColor: diskCard.capLevel > 0 ? root.severityColor(diskCard.capLevel) : Config.base03
                    onToggled: {
                        Config.launchApp(Config.diskCommand);
                        popup.visible = false;
                    }
                }
            }
        }
    }
}
