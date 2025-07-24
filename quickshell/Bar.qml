import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      anchors {
        top: false
        left: true
        right: true
        bottom: true
      }
      implicitHeight: 30
      margins{
        top: 0
        left: 0
        right: 0
      }

      Rectangle {
        id: bar
        anchors.fill: parent
        color: "#000000"
        radius: 10
        RowLayout {
          id: layout
          spacing: 0
          anchors.fill: parent
          Clock {
            Layout.alignment: Qt.AlignRight
            color: "#ffffff"
          }
        }
      }
    }
  }
}
