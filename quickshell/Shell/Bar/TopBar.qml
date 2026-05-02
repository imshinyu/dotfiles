import Quickshell
import QtQuick
import QtQuick.Effects
import qs.Appearance
import qs.Settings
import qs.Bar.Modules as Modules

Variants {
  model: Quickshell.screens
  Scope {
    id: scope
    required property ShellScreen modelData
    property color barsColor: Colors.palette.background
    Loader {
        asynchronous: true
        PanelWindow {
            id: leftBar
            screen: scope.modelData
            color: 'transparent'
            anchors {
                top: true
                left: true
                right: true
            }
            implicitWidth: 44
            RectangularShadow {
                anchors.fill: idk
                spread: 2.5
                radius: Settings.cornerRadius
                offset.x: 1
                blur: 3
                color: Qt.rgba(0.1, 0.1, 0.1, 0.61)
            }
            Rectangle {
              id:idk
              width: parent.width
              height: parent.height
              anchors.left: parent.left
              color: Qt.rgba(scope.barsColor.r,scope.barsColor.g,scope.barsColor.b,0.63)
              // color: 'transparent'
              topRightRadius: Settings.cornerRadius
              bottomRightRadius: Settings.cornerRadius
              // Top
              Column {
                  anchors {
                      horizontalCenter: parent.horizontalCenter
                      left: parent.left
                      leftMargin: 10
                  }
                  Modules.Workspace {
                    anchors.horizontalCenter: parent.horizontalCenter
                  }
              }
              // Center
              Column {
                  anchors.centerIn: parent
                    Modules.Layout {
                      anchors.horizontalCenter: parent.horizontalCenter
                    }
                    // Modules.Clipboard {
                    //   anchors.horizontalCenter: parent.horizontalCenter
                    // }
              }
              // Bottom
              Column {
                  anchors {
                      horizontalCenter: parent.horizontalCenter
                      right: parent.right
                      rightMargin: 10
                  }
                  spacing: 5
                  Modules.Tray{
                    anchors.horizontalCenter: parent.horizontalCenter
                  }
                  Modules.ClockWidget{
                    anchors.horizontalCenter: parent.horizontalCenter
                  }
                  Modules.Power {
                    anchors.horizontalCenter: parent.horizontalCenter
                  }
              }
            }
        }
    }
  }
}
