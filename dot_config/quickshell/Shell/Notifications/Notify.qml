pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.Appearance
import qs.Settings

Scope {
LazyLoader {
    loading: true
    PanelWindow {
        id: root
        property bool active: false
        implicitWidth: screen.width / 5
    
        mask: itemRegion
        color: "transparent"
    
        exclusionMode: ExclusionMode.Ignore
        namespace: "QsNotifs"
    
        margins {
            top: 8
            right: 8
            left: 8
        }
    
        anchors {
            top: true
            right: true
            left: true
        }
    
        Region { id: itemRegion; item: listView }
    
        NotificationServer { id: notificationServer; onNotification: notif => notif.tracked = true }
        Rectangle {
            height: parent.height
            width: parent.width
            anchors.centerIn: parent
            color: Colors.palette.surface
            radius: Settings.cornerRadius
            ListView {
                id: listView
                model: notificationServer.trackedNotifications
                implicitWidth: root.implicitWidth
                implicitHeight: Math.min(contentHeight, root.height)
                spacing: 12
                delegate: Rectangle {
                    implicitWidth: root.implicitWidth
                    implicitHeight: 120
    
                    color: Colors.palette.primary
                    radius: Settings.widgetRadius
                }
            }
        }
    }
}
        IpcHandler {
              target: "root"
              function togglenotify() {
                  root.active = !root.active; // Toggle the active state
              }
        }
}
