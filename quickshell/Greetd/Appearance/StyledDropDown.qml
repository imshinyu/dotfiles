import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import qs.Appearance as Appearance

Item {
    id: root
    width: 200
    height: 56

    property string label: "Select option"
    property var model: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    property int currentIndex: -1
    property string currentText: currentIndex >= 0 ? model[currentIndex] ?? "" : ""
    property bool enabled: true

    signal selectedIndexChanged(int index)

    Rectangle {
        id: container
        anchors.fill: parent
        color: "transparent"
        border.color: dropdown.activeFocus ? Appearance.Colors.palette.primary : Appearance.Colors.palette.surface_container
        border.width: dropdown.activeFocus ? 2 : 1
        radius: 15


        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: root.enabled
            hoverEnabled: true

            onClicked: {
                if (!dropdown.popup.visible) {
                    dropdown.popup.open()
                } else {
                    dropdown.popup.close()
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 15
                color: Appearance.Colors.palette.primary
                opacity: mouseArea.pressed ? 0.12 : mouseArea.containsMouse ? 0.08 : 0

            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 12
            spacing: 12

            Text {
                id: labelText
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: root.currentIndex >= 0 ? root.currentText : root.label
                color: root.currentIndex >= 0
                    ? Appearance.Colors.palette.on_surface
                    : Appearance.Colors.palette.on_surface_variant
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
            }

        }
    }

    ComboBox {
        id: dropdown
        visible: true
        opacity: 0
        model: root.model
        currentIndex: root.currentIndex
        enabled: root.enabled

        onCurrentIndexChanged: {
            root.currentIndex = currentIndex
            root.selectedIndexChanged(currentIndex)
        }

        popup: Popup {
            y: root.height + 4
            width: root.width
            padding: 0
            closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
            background: Rectangle {
                color: Appearance.Colors.palette.surface_container
                radius: 15
                border.color: Appearance.Colors.palette.surface
                border.width: 1
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: Appearance.Colors.palette.shadow
                    shadowBlur: 0.4
                    shadowVerticalOffset: 8
                    shadowHorizontalOffset: 0
                }
            }
            enter: Transition {
                NumberAnimation { 
                    property: "y"
                    from: root.height - 10 // Start slightly higher
                    to: root.height + 4
                    duration: 200
                    easing.type: Easing.OutCubic 
                }
                NumberAnimation { 
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 200 
                }
            }

            // Slide up and Fade out
            exit: Transition {
                NumberAnimation { 
                    property: "y"
                    from: root.height + 4
                    to: root.height - 10
                    duration: 150
                    easing.type: Easing.InCubic 
                }
                NumberAnimation { 
                    property: "opacity"
                    from: 1.0
                    to: 0.0
                    duration: 150 
                }
            }

            contentItem: ListView {
                id: listView
                clip: true
                implicitHeight: contentHeight > 300 ? 300 : contentHeight
                model: dropdown.popup.visible ? dropdown.model : null
                currentIndex: dropdown.currentIndex

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: ItemDelegate {
                    width: listView.width
                    height: 48

                    background: Rectangle {
                        topRightRadius: {
                            if (index === 0) return 15
                            else return 0
                        }
                        topLeftRadius: {
                            if (index === 0) return 15
                            else return 0
                        }
                        bottomRightRadius: {
                            if (index === listView.count-1) return 15
                            else return 0
                        }
                        bottomLeftRadius: {
                            if (index === listView.count-1) return 15
                            else return 0
                        }
                        color: {
                            if (itemMouse.pressed) return Appearance.Colors.palette.primary
                            if (itemMouse.containsMouse) return Appearance.Colors.palette.primary
                            if (index === root.currentIndex) return Appearance.Colors.palette.primary
                            return "transparent"
                        }

                    }

                    contentItem: Text {
                        text: modelData
                        color: (index === root.currentIndex || itemMouse.containsMouse) ? Appearance.Colors.palette.on_primary : Appearance.Colors.palette.primary
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 16
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            dropdown.currentIndex = index
                            dropdown.popup.close()
                        }
                    }
                }
            }


        }
    }

    focus: true
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
            dropdown.popup.visible ? dropdown.popup.close() : dropdown.popup.open()
            event.accepted = true
        }
    }
}
