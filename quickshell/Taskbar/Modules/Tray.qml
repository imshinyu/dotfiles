import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.Taskbar.Modules as Modules
import qs.Appearance as Appearance

Rectangle {
    id: systemTray
    visible: SystemTray.items.values.length > 0
    // clip: true

    property var selectedMenu: null
    property var trayMenu: Modules.CustomTrayMenu{}

    property int itemCount: SystemTray.items.values.length

    ColumnLayout {
        spacing: 0
        id: trayRow
        anchors {
            fill: parent
            bottomMargin: 30
            verticalCenter: parent.verticalCenter
        }

        Repeater {
            model: SystemTray.items

            Item {
                id: trayIcon
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: 40

                property bool isOpen: false


                Image {
                    source: parent.modelData.icon
                    height: 20
                    width: 20
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

MouseArea {
    id: trayMouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (mouse) => {
        if (!modelData) return;
        
        if (mouse.button === Qt.LeftButton) {
            // Close any open menu first
            if (trayMenu && trayMenu.visible) {
                trayMenu.hideMenu()
            }
            
            if (!modelData.onlyMenu) {
                modelData.activate()
            }
        } else if (mouse.button === Qt.MiddleButton) {
            // Close any open menu first
            if (trayMenu && trayMenu.visible) {
                trayMenu.hideMenu()
            }
            
            modelData.secondaryActivate && modelData.secondaryActivate()
        } else if (mouse.button === Qt.RightButton) {
            console.log("Right click on", modelData.id, "hasMenu:", modelData.hasMenu, "menu:", modelData.menu)
            // If menu is already visible, close it
            if (trayMenu && trayMenu.visible) {
                trayMenu.hideMenu()
                return
            }
            
            if (modelData.hasMenu && modelData.menu && trayMenu) {
                // Get the global position of the tray icon
                var iconGlobalPos = trayMouseArea.mapToGlobal(0, 0)
                
                // Calculate absolute coordinates like the power menu
                // Position menu centered below the icon
                var menuX = iconGlobalPos.x + (width / 2) - (trayMenu.width / 2)
                var menuY = iconGlobalPos.y + height + 20
                
                // Alternative: Use fixed offset like power menu (30, 645)
                // var menuX = 30
                // var menuY = 645
                
                trayMenu.menu = modelData.menu
                
                // Use absolute positioning
                trayMenu.showAtAbsolute(menuX, menuY)
                
                // Or if you added a showAtPosition function:
                // trayMenu.showAtPosition(menuX, menuY)
            } else {
                // console.log("No menu available for", modelData.id, "or trayMenu not set")
            }
        }
    }
}                }

                MenuList {
                    id: itemMenu

                    items: trayMenu == null ? [] : trayMenu.children
                    offset: systemTray.itemCount - SystemTray.items.indexOf(trayIcon.modelData)
                    visible: itemMenu == systemTray.selectedMenu && trayIcon.isOpen

                    Connections {
                        target: systemTray

                        function onSelectedMenuChanged() {
                            if (systemTray.selectedMenu != itemMenu) {
                                itemMenu.targetVisible = false;
                            }
                        }
                    }
                }
            }
        }
    }

    // Hover {
    //     item: parent
    // }

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }
}
