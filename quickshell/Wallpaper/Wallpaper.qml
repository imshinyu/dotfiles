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

Scope{
  id: root
  property bool active: false
    property string sourceImage: "/home/shinyu/Pictures/Wallpapers/wallhaven-57qw39.jpg"
  PanelWindow {
    anchors {
      top: true
      bottom: true
      right: true
    }
    implicitWidth: 10
    color: 'transparent'
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: root.active=true
    }
  }

  LazyLoader {
    loading: true
    
    PanelWindow{
    id:panel
    focusable: true
    aboveWindows: true
    color: 'transparent'
    implicitWidth: (root.active) ? 250 : 0
    anchors {
      top: true
      right: true
      bottom: true
    }
    Rectangle {
      width: parent.width
      height: parent.height
      color: Colors.palette.background
      topLeftRadius: 10
      bottomLeftRadius: 10
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
        Rectangle {
          id: exit
          Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
          Layout.topMargin: 11
          implicitHeight: 30
          implicitWidth: 30
          color: Colors.palette.primary
          radius: 20
          Text {
            text: ""
            anchors.centerIn: parent
            color: Colors.palette.background
          }
          MouseArea {
            id: selectExit
            anchors.fill: exit
            hoverEnabled: false
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton
            onClicked: root.active=false
          }
        }
        FolderListModel {
          id: folderModel
          nameFilters: ["*.jpeg","*.jpg","*.png"]
          folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
          
        }
        ClippingWrapperRectangle {
          radius: 10
          Layout.alignment: Qt.AlignHCenter
          color: "transparent"
          Tumbler {
            id: myTumbler
            implicitWidth: panel.width / 1.2
            implicitHeight: panel.height / 1.1
            model: folderModel
            padding: 0
            // NEED WORK TO DO
            // focus:true
            // WlrLayershell.keyboardFocus: (myTumbler.visibleItemCount > 0) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            WheelHandler {
              acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
              onWheel: event => {
                const step = event.angleDelta.y < 0 ? 1 : -1;
                myTumbler.currentIndex = (myTumbler.currentIndex + step + myTumbler.count) % myTumbler.count;
              }
            }
            delegate: Image {
              id: image
              required property string filePath
              source: filePath
              sourceSize {
                width: 220
                height: 220
              }
              fillMode: Image.PreserveAspectCrop
              MouseArea {
                id:selectImage
                anchors.fill: image
                hoverEnabled: false
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: Quickshell.execDetached(["sh", "-c", `awww img ${image.filePath} --transition-type any --transition-step 63 --transition-fps 60 --transition-duration 2 && matugen image ${image.filePath}`])
              }
            }
          }
        }
      }
    }
    IpcHandler {
      target: "panel"
      function openclosepanel(){
        if(root.active==true)
         return root.active=false;
        else if (root.active==false)
        return root.active=true;
      }
    }
  }
  }
}
