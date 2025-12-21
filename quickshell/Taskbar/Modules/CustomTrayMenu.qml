pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Appearance as Appearance

PopupWindow {
    id: trayMenu
    property alias traymenu: trayMenu
    implicitWidth: 180
    implicitHeight: Math.max(40, listView.contentHeight + 12)
    visible: false
    color: "transparent"
    property QsMenuHandle menu
    // Keep anchor properties for backward compatibility
    property var anchorItem: null
    property real x
    property real y
    anchor.item: anchorItem ? anchorItem : null
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY - 4
    
    // New function for absolute positioning
    // Add this function to Tray.qml
    function showAtAbsolute(x, y) {
        // Disable anchor system temporarily
        anchor.enabled = false
        // Set absolute position
        this.x = x
        this.y = y
        // Show the menu
        this.visible = true
        // Re-enable anchor system after showing (optional)
        Qt.callLater(() => {
            anchor.enabled = true
        })
    }    
    function hideMenu() {
        trayMenu.visible = false
    }

    Item {
        anchors.fill: parent
        Keys.onEscapePressed: trayMenu.hideMenu()
    }

    QsMenuOpener {
        id: opener
        menu: trayMenu.menu
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Appearance.Colors.palette.background || "#222"
        radius: 12
        z: 0
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 6
        spacing: 2
        interactive: false
        enabled: trayMenu.visible
        clip: true

        model: ScriptModel {
            values: opener.children ? [...opener.children.values] : []
        }

        delegate: Rectangle {
            id: entry
            required property var modelData

            width: listView.width
            height: (modelData?.isSeparator) ? 8 : 32
            color: "transparent"
            radius: 12

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 20
                height: 1
                color: Qt.darker(Appearance.Colors.palette.surface || "#222", 1.4)
                visible: modelData?.isSeparator ?? false
            }

            Rectangle {
                id: bg
                anchors.fill: parent
                color: mouseArea.containsMouse ? Appearance.Colors.palette.primary : "transparent"
                radius: 8
                visible: !(modelData?.isSeparator ?? false)
                property color hoverTextColor: mouseArea.containsMouse ? Appearance.Colors.palette.on_primary : Appearance.Colors.palette.on_background

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        color: (modelData?.enabled ?? true) ? bg.hoverTextColor : Appearance.Colors.palette.inverse_primary
                        text: modelData?.text ?? ""
                        font.family: Appearance.Colors.family
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    Image {
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: modelData?.icon ?? ""
                        visible: (modelData?.icon ?? "") !== ""
                        fillMode: Image.PreserveAspectFit
                    }
                }

                // If MouseArea causes issues, try using a simple Rectangle with TapHandler
                TapHandler {
                    enabled: (modelData?.enabled ?? true) || !(modelData?.isSeparator ?? false) && trayMenu.visible
                    onTapped: {
                        if (modelData && !modelData.isSeparator) {
                            modelData.triggered()
                            trayMenu.hideMenu()
                        }
                    }
                }
                
                // OR if you prefer MouseArea and it's available:
                /*
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: (modelData?.enabled ?? true) || !(modelData?.isSeparator ?? false) && trayMenu.visible
                    onClicked: {
                        if (modelData && !modelData.isSeparator) {
                            modelData.triggered()
                            trayMenu.hideMenu()
                        }
                    }
                }
                */
            }
        }
    }
}
