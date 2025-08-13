import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

import ".."

ColumnLayout {
    id: sysTrayCol

    // Accept window reference from parent component
    property var panelWindow: null

    // Try to find window dynamically
    function findWindow() {
        var item = sysTrayCol
        while (item && item.parent) {
            item = item.parent
            console.log("Checking item:", item, "toString:", item.toString())
            if (item.toString().indexOf("PanelWindow") !== -1) {
                console.log("Found PanelWindow:", item)
                return item
            }
        }
        console.log("No PanelWindow found, returning top item:", item)
        return item
    }

    // Monitor for tray item changes to ensure proper cleanup
    property var currentItems: []

    function updateItems() {
        currentItems = []
        for (var i = 0; i < SystemTray.items.length; i++) {
            currentItems.push(SystemTray.items[i])
        }
    }

    Component.onCompleted: {
        console.log("SystemTray items count:", SystemTray.items.length)
        console.log("Panel window from parent:", panelWindow)
        var foundWindow = findWindow()
        console.log("Found window:", foundWindow)
        updateItems()
    }

    // Monitor changes to the SystemTray.items model
    Connections {
        target: SystemTray
        function onItemsChanged() {
            console.log("SystemTray items changed, new count:", SystemTray.items.length)
            updateItems()
        }
    }

    Repeater {
        id: sysTray
        model: SystemTray.items

        delegate: MouseArea {
            id: trayItem
            property SystemTrayItem item: modelData

            Component.onCompleted: {
                console.log("Tray item created:", item ? item.title : "null", "icon:", item ? item.icon : "null")
            }

            Component.onDestruction: {
                console.log("Tray item destroyed:", item ? item.title : "null")
            }

            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignHCenter

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: function(mouse) {
                if (!trayItem.item) return

                if (mouse.button === Qt.LeftButton) {
                    trayItem.item.activate()
                } else if (mouse.button === Qt.RightButton) {
                    if (trayItem.item.hasMenu) {
                        console.log("Displaying context menu for:", trayItem.item.title)
                        var windowToUse = sysTrayCol.panelWindow || sysTrayCol.findWindow()
                        console.log("Window to use:", windowToUse, "type:", typeof windowToUse)
                        if (windowToUse) {
                            // Convert to global coordinates
                            var globalPos = trayItem.mapToGlobal(trayItem.width, 0)
                            trayItem.item.display(windowToUse, globalPos.x, globalPos.y)
                        } else {
                            console.log("No valid window found for context menu")
                        }
                    }
                }
            }

            IconImage {
                id: trayIcon
                source: trayItem.item ? trayItem.item.icon : ""
                anchors.centerIn: parent
                width: 20
                height: 20
                opacity: mouse.hovered ? 1 : 0.7
            }

            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
