import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import qs.Appearance as Appearance
import qs.Services as Time
import qs.Taskbar.Modules as Module

Variants {
  model: Quickshell.screens
  Scope {
    id: scope
    required property ShellScreen modelData
    property real borderWidth: 10///18//20
    property real cornerRadius: Appearance.Settings.radius
    property real widgetRadius: Appearance.Settings.radius
    property color barsColor: Appearance.Colors.palette.background
    property color bordercolor: Appearance.Colors.palette.primary

    PanelWindow {
        id: leftBar
        screen: scope.modelData
        color: 'transparent'
        margins {
          top: 10
          bottom: 10
          left: 5
        }
        anchors {
            top: true
            left: true
            bottom: true
        }
        implicitWidth: 40
        Rectangle {
          width: parent.width
          height: parent.height
          anchors.left: parent.left
          color: barsColor
          radius: cornerRadius
          ColumnLayout {
            anchors.fill: parent
            spacing: 5
            Rectangle {
              id: workspaceArea
              Layout.alignment: Qt.AlignTop
              Layout.topMargin: 10
              Layout.leftMargin: 6
              color: "transparent"
              Module.Workspace {}
            }
            Item{
              Layout.fillHeight: true
            }
            Item{
              Layout.fillHeight: true
            }
            Module.Tray{
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              MarginWrapperManager {margin: 7}
              radius: widgetRadius
              color: Appearance.Colors.palette.primary
            }
            Rectangle{
              id: date
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              MarginWrapperManager {margin: 7}
              radius: widgetRadius
              color: Appearance.Colors.palette.primary
              Module.ClockWidget{
                anchors.fill: parent
              }
            }
            Rectangle {
              id: power
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              Layout.bottomMargin: 11
              height: 28
              width: 28
              color: Appearance.Colors.palette.primary
              radius: widgetRadius
              MouseArea {
                anchors.fill: power
                onClicked: {
                  // powerMenu.visible = !powerMenu.visible
                  powerMenu.popup(40,660,power)
                  // powerMenu.x = 40
                  // powerMenu.y = 0
                  powerMenu.open();
                }
              }
                Process {
                    id: logoutProcess
                    command: ["loginctl", "terminate-user",Quickshell.env('USER')]
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
                    popupType: Popup.Window
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                    background: Rectangle {
                        color: Appearance.Colors.palette.background
                        radius: 8
                    }
                    MenuItem {
                        contentItem: Label {
                          color: parent.hovered ? Appearance.Colors.palette.on_primary : "white"
                          text: "Logout"
                        }
                        onTriggered: logoutProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Appearance.Colors.palette.primary : "transparent"
                            radius: 8
                        }
                    }
                    MenuItem {
                        contentItem: Label {
                          color: parent.hovered ? Appearance.Colors.palette.on_primary : "white"
                          text: "Restart"
                        }
                        onTriggered: rebootProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Appearance.Colors.palette.primary : "transparent"
                            radius: 8
                        }
                    }
                    MenuItem {
                        contentItem: Label {
                          color: parent.hovered ? Appearance.Colors.palette.on_primary : "white"
                          text: "Shutdown"
                        }
                        onTriggered: shutdownProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Appearance.Colors.palette.primary : "transparent"
                            radius: 8
                        }
                    }
                }
              Text {
                text: ""
                anchors.centerIn: parent
                color: Appearance.Colors.palette.background
              }
            }
          }
        }
    }
   /* PanelWindow {
      id: topBar
      screen: scope.modelData
      implicitHeight: borderWidth
      color: barsColor
      anchors {
        top: true
        right: true
        left: true
      }
    }
    
    // Then after that the bottom border
    PanelWindow {
      id: bottomBar
      screen: scope.modelData
      implicitHeight: borderWidth
      color: barsColor
      anchors {
        bottom: true
        right: true
        left: true
      }
    }
    PanelWindow {
      id: rightBar
      screen: scope.modelData
      implicitWidth: borderWidth
      color: barsColor
      anchors {
        bottom: true
        right: true
        top: true
      }
    }
    PanelWindow {
      id: topLeftCorner
      screen: scope.modelData
      implicitWidth: cornerRadius
      implicitHeight: cornerRadius
      color: "transparent"
      exclusiveZone: 0
      anchors {
        top: true
        left: true
      }
      
      Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        
        ShapePath {
          strokeWidth: 0
          fillColor: barsColor
          startX: 0
          startY: cornerRadius
          PathArc {
            x: cornerRadius
            y: 0
            radiusX: cornerRadius
            radiusY: cornerRadius
            direction: PathArc.Clockwise
          }
          PathLine { x: 0; y: 0 }
          PathLine { x: 0; y: cornerRadius }
        }
      }
    }
    
    // Top-right corner 
    PanelWindow {
      id: topRightCorner
      screen: scope.modelData
      implicitWidth: cornerRadius
      implicitHeight: cornerRadius
      color: "transparent"
      exclusiveZone: 0
      anchors {
        top: true
        right: true
      }
      
      Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        
        ShapePath {
          strokeWidth: 0
          fillColor: barsColor
          startX: 0
          startY: 0
          PathArc {
            x: cornerRadius
            y: cornerRadius
            radiusX: cornerRadius
            radiusY: cornerRadius
            direction: PathArc.Clockwise
          }
          PathLine { x: cornerRadius; y: 0 }
          PathLine { x: 0; y: 0 }
        }
      }
    }
    
    // Bottom-left corner 
    PanelWindow {
      id: bottomLeftCorner
      screen: scope.modelData
      implicitWidth: cornerRadius
      implicitHeight: cornerRadius
      color: "transparent"
      exclusiveZone: 0
      anchors {
        bottom: true
        left: true
      }
      
      Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        
        ShapePath {
          strokeWidth: 0
          fillColor: barsColor
          startX: cornerRadius
          startY: cornerRadius
          PathArc {
            x: 0
            y: 0
            radiusX: cornerRadius
            radiusY: cornerRadius
            direction: PathArc.Clockwise
          }
          PathLine { x: 0; y: cornerRadius }
          PathLine { x: cornerRadius; y: cornerRadius }
        }
      }
    }
    
    // Bottom-left corner -- quick note guys this controls the bottom right corner had to fix the margin issue)
    PanelWindow {
      id: bottomRightCorner
      screen: scope.modelData
      implicitWidth: cornerRadius
      implicitHeight: cornerRadius
      color: "transparent"
      exclusiveZone: 0
      anchors {
        bottom: true
        right: true
      }
      
      Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        
        ShapePath {
          strokeWidth: 0
          fillColor: barsColor
          startX: 0
          startY: cornerRadius
          PathLine { x: cornerRadius; y: cornerRadius }
          PathLine { x: cornerRadius; y: 0 }
          PathArc {
            x: 0
            y: cornerRadius  
            radiusX: cornerRadius
            radiusY: cornerRadius
            direction: PathArc.Clockwise
          }
        }
      }
    } */
  }
}
