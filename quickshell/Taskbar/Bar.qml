import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "time" as Date
import qs.Date
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
        color: Qt.rgba(00,00,00,0.4)
        radius: 10
        border.width: 2
        border.color: "#9BCBFB"
        ColumnLayout {
          id: layout
          spacing: 6
          anchors.fill: parent
          Repeater {
            model: Hyprland.workspaces
            Rectangle {
              height: 30
              radius: 10
              Layout.alignment: Qt.AlignTop
              Layout.fillWidth: true
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
          
          Date.Clock {
            Layout.alignment: Qt.AlignBottom
            color: "#ffffff"
          }
        }
      }
    }
  }
}
