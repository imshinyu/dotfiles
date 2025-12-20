import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import qs.Colors as Colors
import qs.Services.Time as Clock
import qs.Taskbar.Modules as Module

Variants {
  model: Quickshell.screens
  Scope {
    id: scope
    required property ShellScreen modelData
    property real borderWidth: 5///18//20
    property real cornerRadius: 10
    property real widgetRadius: 10
    property color barsColor: Colors.Colour.palette.background
    property color bordercolor: Colors.Colour.palette.primary

    PanelWindow {
        id: leftBar
        color: "transparent"
        screen: scope.modelData
        anchors {
            top: true
            left: true
            bottom: true
        }
        implicitWidth: 40
        Rectangle {
          width: 40
          height: parent.height
          anchors.left: parent.left
          anchors.rightMargin: 4
          color: barsColor
          border.width: 0
          border.color: Colors.Colour.palette.primary
          ColumnLayout {
            anchors.fill: parent
            Rectangle {
              id: workspaceArea
              Layout.alignment: Qt.AlignTop | Qt.AlignVCenter
              color: "transparent"
              Module.Workspace {
                  id: workspace
                  screen: modelData
                  anchors.horizontalCenter: leftBar.horizontalCenter
                  anchors.verticalCenter: leftBar.verticalCenter
              }
            }
            Item {
              Layout.fillHeight: true
            }
            Rectangle{
              id: tray
              Layout.alignment: Qt.AlignHCenter
              MarginWrapperManager {margin: 3}
              radius: widgetRadius
              color: Colors.Colour.palette.primary
              Module.Tray {
                id: sysTray
                anchors.centerIn: parent
              }
            }
            Rectangle{
              id: date
              Layout.alignment: Qt.AlignHCenter

              MarginWrapperManager {margin: 8}
              radius: widgetRadius
              color: Colors.Colour.palette.primary
              Module.ClockWidget{
                anchors.fill: parent
              }
            }
            Rectangle {
              id: power
              Layout.alignment: Qt.AlignHCenter
              Layout.bottomMargin: 10
              height: 30
              width: 30
              color: Colors.Colour.palette.primary
              radius: widgetRadius
              MouseArea {
                anchors.fill: power
                onClicked:
                contextMenu.popup()
              }
                Process {
                    id: logoutProcess
                    command: ["niri", "msg", "action", "quit"]
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
                    id: contextMenu
                    width: 150
                    popupType: Popup.Window
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
                        }
                    }
                    MenuItem {
                        text: "Reboot"
                        onTriggered: rebootProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Colors.Colour.palette.primary : "transparent"
                            radius: 8
                        }
                    }
                    MenuItem {
                        text: "Shutdown"
                        onTriggered: shutdownProcess.running = true
                        background: Rectangle {
                            color: parent.hovered ? Colors.Colour.palette.primary : "transparent"
                            radius: 8
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
    PanelWindow {
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
    }
  }
}
