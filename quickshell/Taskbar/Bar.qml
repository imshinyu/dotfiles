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
import "time" as Date
import "tray" as Tray
import "colors" as Colors
Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      anchors {
        top: true
        left: true
        right: false
        bottom: true
      }
      implicitWidth: 40
      margins{
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
        ColumnLayout {
          id: layout
          spacing: -500
          uniformCellSizes: true
          anchors.fill: parent
          Repeater {
            model: Hyprland.workspaces
            Rectangle {
              height: 30
              radius: 10
              Layout.alignment: Qt.AlignHCenter
              Layout.preferredWidth: 24
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
          Tray.Tray {
            Layout.alignment: Qt.AlignBottom
            id: sysTray
          }

          Date.Clock {
            Layout.alignment: Qt.AlignBottom
            color: "#ffffff"
          }
          Button {
            id: power
            height: 30
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            onClicked: menu.popup()
            Menu {
              id: menu
              MenuItem {
                text: "Logout"
                onTriggered: QuickShell.shellExec("hyprctl dispatch exit")
              }
              MenuItem {
                text: "Reboot"
                    onTriggered: {
                      const proc = Qt.createQmlObject(`Process {command: ["systemctl", "reboot"]}`, parent);
                      proc.start();
                    }
              }
              MenuItem {
                text: "Shutdown"
                onTriggered: QuickShell.shellExec("systemctl poweroff")
              }
            }

            Image {
              height: 20
              Layout.fillWidth: true
              fillMode: Image.PreserveAspectFit
              source: "/home/khalyl/Downloads/turn-off.png"
              anchors.centerIn: parent
            }
          }
        }
      }
    }
  }
}
