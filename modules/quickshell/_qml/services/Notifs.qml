pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property var popups: []
    property alias dnd: persist.dnd
    readonly property var tracked: server.trackedNotifications.values

    function timeoutFor(n) {
        if (n.urgency === NotificationUrgency.Critical)
            return 0;
        if (n.expireTimeout > 0)
            return n.expireTimeout;
        return n.expireTimeout === 0 ? 0 : 5000;
    }

    function removePopup(n) {
        popups = popups.filter(p => p !== n);
    }

    function clearAll() {
        const all = server.trackedNotifications.values.slice();
        for (const n of all)
            n.dismiss();
    }

    readonly property NotificationServer server: NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: n => {
            n.tracked = true;
            const all = server.trackedNotifications.values;
            if (all.length > 50)
                all[0].dismiss();
            if (!persist.dnd)
                root.popups = root.popups.concat([n]).slice(-5);
        }
    }

    PersistentProperties {
        id: persist

        reloadableId: "notifs"

        property bool dnd: false
    }
}
