import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.DBusMenu
import qs.Appearance as Appearance
Rectangle {
    id: root
    width: col.width + 22
    height: col.height
    radius: 5
    color: Appearance.Colors.palette.background
    // anchors.fill: parent

    required property var entry
    property int offset
    property bool showChildren: false

    Timer {
        id: closeTray
        interval: 100
        running: false
        repeat: false

        onTriggered: {
            children.targetVisible = false;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        visible: !entry.isSeparator

        onEntered: {
            if (!entry.enabled)
                return;

            parent.color = Appearance.Colors.palette.primary;

            if (entry.hasChildren) {
                const window = QsWindow.window;
                const widgetRect = window.contentItem.mapFromItem(root, root.width - (root.offset * 30), root.height + 10);

                // childrenMenuLoader.item.anchor.rect = widgetRect;
                // childrenMenuLoader.item.targetVisible = true;
            }
        }

        onExited: {
            parent.color = "transparent";

            if (entry.hasChildren) {
                closeTray.running = true;
            }
        }

        onClicked: {
            entry.triggered();

            if (entry.buttonType == QsMenuButtonType.None) {
                itemMenu.targetVisible = false;
            }
        }
    }

    ColumnLayout {
        id: col
        property bool isOpen: false

        Item {
            id: buttonItem
            implicitWidth: 22
            implicitHeight: 22

            Text {
                text: "⮜"
                visible: entry.hasChildren
                anchors.centerIn: parent
                color: Appearance.colors.pallete.text
                // font.family: Cfg.font
                font.pixelSize: 26
            }

            Text {
                text: entry.checkState === Qt.Checked ? "󰡖" : ""
                visible: entry.buttonType == QsMenuButtonType.CheckBox
                anchors.centerIn: parent
                color: Appearance.colors.palette.text
                // font.family: Cfg.font
                font.pixelSize: entry.checkState === Qt.Checked ? 28 : 24
            }

            Text {
                text: entry.checkState === Qt.Checked ? "󰪥" : ""
                visible: entry.buttonType == QsMenuButtonType.RadioButton
                anchors.centerIn: parent
                color: Appearance.Colors.palette.text
                // font.family: Cfg.font
                font.pixelSize: entry.checkState === Qt.Checked ? 28 : 22
            }
        }

        Text {
            text: entry.text
            color: Appearance.Colors.palette.text
            font.bold: !entry.enabled
            font.family: Appearance.Colors.palette.family
            font.pixelSize: 18
        }
    }

    QsMenuOpener {
        id: openChildren

        Component.onCompleted: {
            if (entry.hasChildren) {
                openChildren.menu = entry;
            }
        }
    }

    // Loader {
    //     id: childrenMenuLoader
    //
    //     onLoaded: {
    //         item.offset = 0;
    //         item.items = openChildren.children;
    //         item.visible = children.targetVisible || children.hovered || col.isOpen;
    //     }
    // }
    //
    // Component.onCompleted: {
    //     if (entry.hasChildren) {
    //         childrenMenuLoader.source = "MenuList.qml";
    //     }
    // }
}
