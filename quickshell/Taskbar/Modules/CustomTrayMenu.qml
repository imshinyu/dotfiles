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
    property var anchorItem: null
    property real anchorX
    property real anchorY
    anchor.item: anchorItem ? anchorItem : null
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY - 4

    function showAt(item, x, y) {
        if (!item) {
            console.warn("CustomTrayMenu: anchorItem is undefined, not showing menu.");
            return;
        }
        anchorItem = item
        anchorX = x
        anchorY = y
        visible = true
        forceActiveFocus()
        Qt.callLater(() => trayMenu.anchor.updateAnchor())
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
            }
        }
    }
}
