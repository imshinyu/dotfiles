import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import qs.Appearance
import qs.Settings
import qs.Bar.Modules as Modules

Variants {
  model: Quickshell.screens
  Scope {
    id: scope
    required property ShellScreen modelData
    property real borderWidth: 10///18//20
    property real cornerRadius: Appearance.Settings.cornerRadius
    property real widgetRadius: Appearance.Settings.widgetRadius
    property color barsColor: Colors.palette.background
    property color bordercolor: Colors.palette.primary

    PanelWindow {
      id: bottomBar
      screen: scope.modelData
      color: 'transparent'
      anchors {
          right: true
          left: true
          bottom: true
      }
      implicitHeight: 35
      // Rectangle {
      //   id: background
      //   width: 20
      //   height: parent.height - 15
      //   anchors.horizontalCenter: parent.horizontalCenter
      //   color: scope.barsColor
      // }
      Rectangle {
        id:idk
        width: parent.width
        height: parent.height
        anchors.bottom: parent.bottom
        color: scope.barsColor
        // color: 'transparent'
        topRightRadius: scope.cornerRadius
        topLeftRadius: scope.cornerRadius
        RowLayout {
          id: barRow
          anchors.fill: parent
          spacing: 0
          Rectangle {
            id: menu
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rightMargin: 5
            implicitHeight: 25
            implicitWidth: 25
            color: Colors.palette.surface_bright
            radius: widgetRadius
            MouseArea {
              anchors.fill: menu
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                Quickshell.execDetached(["nwg-menu"])
              }
            }
            Text {
              text: ""
              anchors.centerIn: parent
              color: Colors.palette.primary
            }
          }
          Rectangle {
            id: apps
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            Layout.bottomMargin: 25
            Layout.leftMargin: 6
            color: "transparent"
            Modules.TopLevel {}
          }
          Item{
            Layout.minimumWidth: 640
          }
          // Rectangle {
          //   id: layoutArea
          //   Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
          //   implicitHeight: 25
          //   implicitWidth: 70
          //   radius: scope.widgetRadius
          //   color: Colors.palette.surface_bright
          //   Modules.Layout {
          //     anchors.centerIn: layoutArea
          //   }
          //   MouseArea {
          //     id: layoutMouse
          //     anchors.fill: parent
          //     cursorShape: Qt.PointingHandCursor
          //     acceptedButtons: Qt.LeftButton
          //     onClicked: Quickshell.execDetached(["mmsg", "-d", "switch_layout"])
          //   }
          // }
          // Rectangle {
          //   id: workspaceArea
          //   Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
          //   Layout.bottomMargin: 25
          //   color: "transparent"
          //   Modules.Workspace {}
          // }
          Item{
            Layout.minimumWidth: 100
          }
          Modules.Tray{
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rightMargin: -25
            radius: widgetRadius
            color: Colors.palette.surface_bright
          }
          Rectangle{
            id: date
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            implicitHeight: 25
            implicitWidth: 90
            radius: widgetRadius
            color: Colors.palette.surface_bright
            Modules.ClockWidget{
              anchors.fill: parent
            }
          }
          Rectangle {
            id: power
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Layout.rightMargin: 5
            implicitHeight: 25
            implicitWidth: 25
            color: Colors.palette.surface_bright
            radius: widgetRadius
            MouseArea {
              anchors.fill: power
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                // powerMenu.visible = !powerMenu.visible
                powerMenu.popup(-90,-95,power)
                // powerMenu.x = 0
                // powerMenu.y = 40
                powerMenu.open();
              }
            }
              Process {
                  id: logoutProcess
                  command: ["wayland-logout"]
              }
              Process {
                  id: rebootProcess
                  command: ["systemctl", "reboot"]
              }
              Process {
                  id: shutdownProcess
                  command: ["systemctl", "poweroff"]
              }

              Menu {
                  id: powerMenu
                  width: 150
                  height: 40
                  popupType: Popup.Window
                  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                  background: Rectangle {
                      color: Colors.palette.background
                      radius: 10
                      border.width: 1
                      border.color: Colors.palette.surface_bright
                  }
                  WrapperItem {
                    margin: 3
                    bottomMargin: 0
                    topMargin: 3
                    MenuItem {
                        contentItem: Label {
                          color: parent.hovered ? Colors.palette.on_primary : "white"
                          text: " Logout"
                          font.pixelSize: Settings.fontpixelSize
                          font.family: Settings.fontFamily
                        }
                        onTriggered: logoutProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Colors.palette.on_surface : "transparent"
                            height: 25
                            radius: 8
                        }
                    }
                  }
                  WrapperItem {
                    margin: 3
                    bottomMargin: 0
                    topMargin: 0
                    MenuItem {
                        implicitTextPadding: 5
                        contentItem: Label {
                          color: parent.hovered ? Colors.palette.on_primary : "white"
                          text: " Restart"
                          font.pixelSize: Settings.fontpixelSize
                          font.family: Settings.fontFamily
                        }
                        onTriggered: rebootProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Colors.palette.on_surface : "transparent"
                            height: 25
                            radius: 8
                        }
                    }
                  }
                  WrapperItem {
                    bottomMargin: -1
                    leftMargin: 5
                    rightMargin: 5
                    topMargin: 0
                    MenuItem {
                        contentItem: Label {
                          color: parent.hovered ? Colors.palette.on_primary : "white"
                          text: " Shutdown"
                          font.pixelSize: Settings.fontpixelSize
                          font.family: Settings.fontFamily
                        }
                        onTriggered: shutdownProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Colors.palette.on_surface : "transparent"
                            height: 25
                            radius: 7
                        }
                    }
                  }
              }
            Text {
              text: ""
              anchors.centerIn: parent
              color: Colors.palette.primary
            }
          }
        }
      }
    }
  }
}
