import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Appearance as Appearance

PopupWindow {
    id: root
    anchor.rect.x: 0
    anchor.rect.y: 0
    width: menuColumn.width + 22
    height: menuColumn.height + 22
    color: "transparent"

    required property var items
    required property int offset
    property real maxWidth: 0
    property bool hovered: false
    property bool targetVisible: false

    mask: Region {
        item: itemList
    }

    onTargetVisibleChanged: {
        if (targetVisible) {
            itemList.opacity = 1;
            trayIcon.isOpen = true;
        } else {
            itemList.opacity = 0;
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            hovered = true;
        }

        onExited: {
            hovered = false;
        }

        Rectangle {
            id: itemList
            width: menuColumn.width + 22
            height: menuColumn.height + 22
            radius: 10
            opacity: 0.1
            color: Theme.colors.bg.base

            border.color: Theme.colors.primary
            border.width: Theme.borderWeight

            onOpacityChanged: {
                if (itemList.opacity == 0) {
                    trayIcon.isOpen = false;
                }
            }

            ColumnLayout {
                id: menuColumn
                spacing: 3
                anchors.centerIn: parent

                Repeater {
                    model: items

                    MenuItem {
                        id: menuItem

                        height: modelData.isSeparator ? 14 : childrenRect.height
                        width: childrenRect.width

                        required property var modelData

                        entry: modelData
                        offset: root.offset

                        Component.onCompleted: {
                            if (root.maxWidth < width) {
                                root.maxWidth = width;
                            } else {
                                width = root.maxWidth;
                            }
                        }

                        Connections {
                            target: root

                            function onMaxWidthChanged() {
                                if (menuItem.width < root.maxWidth) {
                                    menuItem.width = root.maxWidth;
                                }
                            }
                        }

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors {
                                fill: parent
                                topMargin: 6
                                bottomMargin: 6
                            }
                        }
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 50
                }
            }
        }
    }
}
