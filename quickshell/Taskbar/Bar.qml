import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtCore
import qs.Taskbar.time as Date
import qs.Taskbar.tray as Tray
import qs.Taskbar.colors as Colors
import qs.Taskbar as Taskbar

Scope {

    // Global menu outside of PanelWindow to avoid width constraints
    Menu {
        id: globalMenu
        width: 120
        MenuItem {
            text: "Logout"
            onTriggered: logoutProcess.running = true
        }
        MenuItem {
            text: "Reboot"
            onTriggered: rebootProcess.running = true
        }
        MenuItem {
            text: "Shutdown"
            onTriggered: shutdownProcess.running = true
        }
    }

    Process {
        id: logoutProcess
        command: ["hyprctl", "dispatch", "exit"]
    }
    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
    }
    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: false
                bottom: true
            }
            implicitWidth: 40
            margins {
                top: 7
                bottom: 8
                left: 2
                right: 0
            }
            color: "transparent"

            MultiEffect {
                source: bar
                anchors.fill: bar
                blurEnabled: true
                blurMax: 64
                blur: 0
            }
            Rectangle {
                id: bar
                anchors.fill: parent
                //color: Qt.rgba(00,00,00,0.4)
                color: Colors.Colour.palette.background
                radius: 10
                border.width: 2
                border.color: Colors.Colour.palette.primary
                Process {
                    id: logoutProcess
                    command: ["hyprctl", "dispatch", "exit"]
                }
                Process {
                    id: rebootProcess
                    command: ["systemctl", "reboot"]
                }
                Process {
                    id: shutdownProcess
                    command: ["systemctl", "poweroff"]
                }

                // Fixed workspace area in center
                Rectangle {
                    id: workspaceArea
                    anchors {

                        verticalCenter: parent.verticalCenter
                    }
                    height: 200  // Fixed height for workspace area
                    width: 24
                    color: "transparent"

                    Workspace {
                        id: workspace
                        screen: modelData
                        anchors.leftMargin: 10
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.verticalCenter: barBackground.verticalCenter
                    }
                    /* Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
              model: Hyprland.workspaces
              Rectangle {
                height: 30
                width: 24
                radius: 10
                color: modelData.active ? bar.border.color : "transparent"
                MouseArea {
                  anchors.fill: parent
                  onClicked: Hyprland.dispatch(`workspace ` + modelData.id)
                }
                Text {
                  text: modelData.id
                  anchors.centerIn: parent
                  color: modelData.active ? "#000000" : "#ffffff"
                }
              }
            }

          } */
                }

                // Fixed system tray above clock
                Tray.Tray {
                    id: sysTray
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: clock.top
                        bottomMargin: 5
                    }
                    property var panelWindow: panelWindow
                }

                // Fixed clock above power button
                Date.Clock {
                    id: clock
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: power.top
                        bottomMargin: 5
                    }
                }

                // Fixed power button at bottom
                Rectangle {
                    id: power
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 5
                    }
                    height: 30
                    width: 30
                    color: bar.border.color
                    radius: 9

                    MouseArea {
                        anchors.fill: parent
                        onClicked: menu.popup()
                    }

                    Menu {
                        id: menu
                        parent: null
                        width: 150

                        background: Rectangle {
                            color: Colors.Colour.palette.background
                            radius: 10
                        }

                        MenuItem {
                            text: "Logout"
                            onTriggered: logoutProcess.running = true
                            background: Rectangle {
                                color: parent.hovered ? Colors.Colour.palette.primary : "transparent"
                                radius: 8
                                anchors.fill: parent
                                anchors.margins: 2
                            }
                        }
                        MenuItem {
                            text: "Reboot"
                            onTriggered: rebootProcess.running = true
                            background: Rectangle {
                                color: parent.hovered ? Colors.Colour.palette.primary : "transparent"
                                radius: 8
                                anchors.fill: parent
                                anchors.margins: 2
                            }
                        }
                        MenuItem {
                            text: "Shutdown"
                            onTriggered: shutdownProcess.running = true
                            background: Rectangle {
                                color: parent.hovered ? Colors.Colour.palette.primary : "transparent"
                                radius: 8
                                anchors.fill: parent
                                anchors.margins: 2
                            }
                        }
                    }
                    Text {
                        text: ""
                        anchors.centerIn: parent
                        color: Colors.Colour.palette.background
                    }
                }
            }
        }
    }
}
