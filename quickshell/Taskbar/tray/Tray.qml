import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

import ".."

ColumnLayout {
    id: sysTrayCol

    Repeater {
        id: sysTray
        model: SystemTray.items

        MouseArea {
            id: trayItem
            property SystemTrayItem item: modelData

            IconImage {
                id: trayIcon
                source: trayItem.item.icon
                width: parent.width
                height: parent.height
                visible: false
            }
            Loader {
                sourceComponent: MultiEffect {
                    source: trayIcon
                    opacity: mouse.hovered ? 1 : 0.7
                }
            }
            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
