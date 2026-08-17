import Quickshell.Services.UPower
import QtQuick
import qs
import qs.lib

BarWidget {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property real pct: (device?.percentage ?? 0) * 100
    readonly property bool charging: device?.state === UPowerDeviceState.Charging

    visible: device?.isLaptopBattery ?? false
    text: {
        if (device?.state === UPowerDeviceState.FullyCharged)
            return "󰂅";
        const icons = charging ? ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"] : ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
        return icons[Math.max(0, Math.min(9, Math.floor(pct / 10)))];
    }
    baseColor: {
        if (charging)
            return Config.base0B;
        if (pct <= 10)
            return Config.base08;
        if (pct <= 20)
            return Config.base0A;
        return Config.base03;
    }
}
