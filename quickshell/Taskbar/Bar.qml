import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import qs.Appearance
import qs.Taskbar.Modules as Modules

Variants {
  model: Quickshell.screens
  Scope {
    id: scope
    required property ShellScreen modelData
    property real borderWidth: 10///18//20
    property real cornerRadius: Settings.radius
    property real widgetRadius: Settings.radius
    property color barsColor: Colors.palette.background
    property color bordercolor: Colors.palette.primary

    PanelWindow {
        id: leftBar
        screen: scope.modelData
        color: 'transparent'
        anchors {
            top: true
            left: true
            bottom: true
        }
        implicitWidth: 40
        Rectangle {
          id: background
          width: 20
          height: parent.height
          anchors.horizontalCenter: parent.horizontalCenter
          color: scope.barsColor
        }
        Rectangle {
          id:idk
          width: parent.width
          height: parent.height
          anchors.left: parent.left
          // color: scope.barsColor
          color: 'transparent'
          topRightRadius: scope.cornerRadius
          bottomRightRadius: scope.cornerRadius
          ColumnLayout {
            id: barCol
            anchors.fill: parent
            anchors.centerIn: parent
            Rectangle {
              id: workspaceArea
              Layout.alignment: Qt.AlignTop
              Layout.topMargin: 10
              Layout.leftMargin: 6
              color: "transparent"
              Modules.Workspace {}
            }
            Item{
              Layout.fillHeight: true
            }
            Rectangle {
              id: layoutArea
              Layout.alignment: Qt.AlignVCenter
              Layout.topMargin: 200
              Layout.rightMargin: 0
              Layout.leftMargin: 5
              // MarginWrapperManager {margin: 7}
              implicitHeight: 70
              implicitWidth: 30
              radius: scope.widgetRadius
              color: Colors.palette.primary
              Modules.Layout {
                anchors.centerIn: layoutArea
              }
              MouseArea {
                id: layoutMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: Quickshell.execDetached(["mmsg", "-d", "switch_layout"])
              }
            }
            Item{
              Layout.fillHeight: true
            }
            Modules.Tray{
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              MarginWrapperManager {margin: 5}
              radius: widgetRadius
              color: Colors.palette.primary
            }
            Rectangle{
              id: date
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              implicitHeight: 90
              implicitWidth: 30
              radius: widgetRadius
              color: Colors.palette.primary
              Modules.ClockWidget{
                anchors.fill: parent
              }
            }
            Rectangle {
              id: power
              Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
              Layout.bottomMargin: 11
              implicitHeight: 28
              implicitWidth: 28
              color: Colors.palette.primary
              radius: widgetRadius
              MouseArea {
                anchors.fill: power
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
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
                color: Colors.palette.background
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
