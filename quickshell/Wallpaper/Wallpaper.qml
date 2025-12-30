pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.folderlistmodel
import Qt.labs.animation
import qs.Appearance

Scope {
    id: root
    property bool active: false
    PanelWindow {
        anchors {
            top: true
            bottom: true
            right: true
        }
        implicitWidth: 1
        color: 'transparent'
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.active = true
        }
    }

    LazyLoader {
        loading: true

        PanelWindow {
            id: panel
            focusable: true
            aboveWindows: true
            color: 'transparent'
            implicitWidth: (root.active) ? 250 : 0
            exclusionMode: ExclusionMode.Normal
            // WlrLayershell.keyboardFocus: (myTumbler.visible) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            anchors {
                top: true
                right: true
                bottom: true
            }
            Rectangle {
                width: 40
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                color: (root.active) ? Colors.palette.background : 'transparent'
            }
            Rectangle {
                width: parent.width
                height: parent.height
                // color: (root.active) ? Colors.palette.background : 'transparent'
                color: 'transparent'
                topLeftRadius: Settings.radius
                bottomLeftRadius: Settings.radius
                MouseArea {
                    id: select
                    anchors.fill: walCol
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                }
                ColumnLayout {
                    id: walCol
                    anchors.fill: parent
                    spacing: 1
                    // Rectangle {
                    //     id: exit
                    //     Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    //     Layout.topMargin: 11
                    //     implicitHeight: 30
                    //     implicitWidth: 30
                    //     color: (root.active) ? Colors.palette.primary : 'transparent'
                    //     radius: Settings.radius
                    //     Text {
                    //         text: ""
                    //         anchors.centerIn: parent
                    //         color: Colors.palette.background
                    //     }
                    //     MouseArea {
                    //         id: selectExit
                    //         anchors.fill: exit
                    //         hoverEnabled: false
                    //         cursorShape: Qt.PointingHandCursor
                    //         acceptedButtons: Qt.LeftButton
                    //         onClicked: root.active = false
                    //     }
                    // }
                    FolderListModel {
                        id: folderModel
                        nameFilters: ["*.jpeg", "*.jpg", "*.png"]
                        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
                    }
                    ClippingWrapperRectangle {
                        radius: Settings.radius
                        Layout.alignment: Qt.AlignHCenter
                        color: "transparent"
                        Tumbler {
                            id: myTumbler
                            implicitWidth: panel.width / 1.1
                            implicitHeight: panel.height
                            model: folderModel
                            padding: 0
                            wrap: true
                            visibleItemCount: 6
                            focus:true
                            Behavior on currentIndex {
                                id: indexBehavior
                                enabled: true
                                NumberAnimation {
                                    duration: 10  // Adjust for desired smoothness (ms)
                                    easing.type: Easing.OutCubic
                                }
                            }
                            WheelHandler {
                                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                                onWheel: event => {
                                    const step = event.angleDelta.y < 0 ? 1 : -1;
                                    myTumbler.currentIndex = (myTumbler.currentIndex + step + myTumbler.count) % myTumbler.count;
                                }
                            }
                            delegate: WrapperItem {
                                id: contentItem
                                margin: 5
                                required property string filePath
                                ClippingWrapperRectangle {
                                    radius: Settings.radius
                                    Layout.alignment: Qt.AlignHCenter
                                    border.width: 3
                                    border.color: (selectImage.containsMouse) ? Colors.palette.primary : 'transparent'
                                    color: "transparent"
                                    Image {
                                        id: image
                                        source: contentItem.filePath
                                        sourceSize {
                                            width: 200
                                            height: 150
                                        }
                                        asynchronous: true
                                        retainWhileLoading: true
                                        fillMode: Image.PreserveAspectCrop
                                        MouseArea {
                                            id: selectImage
                                            anchors.fill: image
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            acceptedButtons: Qt.LeftButton
                                            onClicked: Quickshell.execDetached(["sh", "-c", `awww img ${contentItem.filePath} --transition-type any --transition-step 63 --transition-fps 60 --transition-duration 2 && matugen image ${contentItem.filePath}`])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            IpcHandler {
                target: "panel"
                function openclosepanel() {
                    if (root.active == true)
                        return root.active = false;
                    else if (root.active == false)
                        return root.active = true;
                }
            }
        }
    }
}
