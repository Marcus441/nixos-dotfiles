pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    property var popups: []
    property alias dnd: persist.dnd
    readonly property var tracked: server.trackedNotifications.values

    function timeoutFor(n: Notification): int {
        if (n.urgency === NotificationUrgency.Critical)
            return 0;
        if (n.expireTimeout > 0)
            return n.expireTimeout;
        return n.expireTimeout === 0 ? 0 : 5000;
    }

    function removePopup(n: Notification): void {
        root.popups = root.popups.filter(p => p !== n);
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

    // popups is a plain array, so QML cannot null an entry whose notification
    // the server destroys; the service drops it on closed itself rather than
    // leaving that to whichever view happens to have a card on screen
    Instantiator {
        model: root.popups

        delegate: QtObject {
            id: entry

            required property Notification modelData

            readonly property Connections conn: Connections {
                target: entry.modelData

                function onClosed(): void {
                    root.removePopup(entry.modelData);
                }
            }
        }
    }

    PersistentProperties {
        id: persist

        reloadableId: "notifs"

        property bool dnd: false
    }
}
