pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import qs.Appearance
import qs.Settings
import qs.Shell.Bar.Modules as Modules
import qs.Shell.Bar

ColumnLayout {
  spacing: 1
  property alias myTumbler: myTumbler
  Layout.alignment: Qt.AlignHCenter
  Layout.leftMargin: 10
  Layout.fillWidth: true
  FolderListModel {
    id: folderModel
    nameFilters: ["*.jpeg", "*.jpg", "*.png","*.gif", ".webp"]
    folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
    showFiles: true
    showDirs: false
    sortField: FolderListModel.Time
  }
  ClippingWrapperRectangle {
    radius: Settings.widgetRadius ?? 0
    Layout.alignment: Qt.AlignHCenter
    color: "transparent"
    Tumbler {
      id: myTumbler
      implicitWidth: panelBackground.width - 15
      implicitHeight: panelBackground.height
      model: folderModel
      padding: 0
      wrap: true
      visibleItemCount: 6
      focus:(root.active) ? true : false
      // Monitor when the Tumbler is visible/active
      Behavior on currentIndex {
        id: indexBehavior
        enabled: true
        NumberAnimation {
          duration: 10  // Adjust for desired smoothness (ms)
          easing.type: Easing.OutCubic
        }
      }
      Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Up) {
          myTumbler.currentIndex = (myTumbler.currentIndex - 1 + myTumbler.count) % myTumbler.count
          event.accepted = true
        } else if (event.key === Qt.Key_Down) {
          myTumbler.currentIndex = (myTumbler.currentIndex + 1 + myTumbler.count) % myTumbler.count
          event.accepted = true
        } else if (event.key === Qt.Key_Return) {
          Quickshell.execDetached(["sh", "-c", `awww img ${myTumbler.currentItem.filePath} --transition-type any --transition-step 63 --transition-fps 60 --transition-duration 2 && matugen --show-colors --source-color-index 1 -t scheme-fidelity image ${myTumbler.currentItem.filePath}  $wallpaper -m dark`])
          event.accepted = true
        }
      }
      WheelHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: event => {
          const step = event.angleDelta.y < 0 ? 1 : -1;
          myTumbler.currentIndex = (myTumbler.currentIndex + step + myTumbler.count) % myTumbler.count;
        }
      }
      delegate: WrapperItem {
        id: wrapperItem
        margin: 5
        required property string filePath
        ClippingWrapperRectangle {
          radius: Settings.widgetRadius ?? 0
          Layout.alignment: Qt.AlignHCenter
          border.width: 3
          border.color: (selectImage.containsMouse || (myTumbler.currentItem && wrapperItem.filePath===myTumbler.currentItem.filePath)) ? Colors.palette.primary : 'transparent'
          color: Colors.palette.background
          // margin: 5
          Image {
            id: image
            source: wrapperItem.filePath
            sourceSize {
              width: 200
              height: 150
            }
            asynchronous: true
            retainWhileLoading: true
            fillMode: Image.PreserveAspectCrop
            MouseArea {
              id: selectImage
              anchors.fill: image
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              acceptedButtons: Qt.LeftButton
              onClicked: Quickshell.execDetached(["sh", "-c", `awww img ${wrapperItem.filePath} --transition-type any --transition-step 63 --transition-fps 60 --transition-duration 2 && matugen --show-colors --source-color-index 1 -t scheme-fidelity image ${wrapperItem.filePath}  $wallpaper -m dark`])
            }
          }
        }
      }
    }
  }
}
