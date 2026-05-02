pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import QtCore
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt.labs.qmlmodels
import qs.Appearance
import qs.Settings
import qs.Shell.Bar.Modules as Modules

Scope {
  id: root
  property bool active: false

  LazyLoader {
    loading: true

    PanelWindow {
      id: panel
      WlrLayershell.keyboardFocus: (wallpaper.myTumbler.focus) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
      WlrLayershell.layer: WlrLayer.Top
      exclusionMode: ExclusionMode.Normal
      focusable: true
      aboveWindows: true
      mask: Region {item: panelBackground}
      color: 'transparent'
      implicitWidth: (root.active) ? 260 : 0
      anchors {
        top: true
        right: true
        bottom: true
      }
      RectangularShadow {
          anchors.fill: panelBackground
          spread: 2.5
          radius: panelBackground.leftRadius || 0
          blur: 3
          color: Qt.rgba(0.1, 0.1, 0.1, 0.61)
      }
      Rectangle {
        id: panelBackground
        width: (root.active) ? 255 : 0
        height: parent.height
        color: (root.active) ? Colors.palette.background : 'transparent'
        // color: 'transparent'
        Behavior on width {
          NumberAnimation {
              duration: 255
              easing.type: Easing.InOutQuad;
              // easing.type: Easing.OutInElastic;
              easing.amplitude: 2.5;
              easing.period: 1;
          }
        }
        anchors.right: parent.right
        // color: 'transparent'
        topLeftRadius: Settings.cornerRadius
        bottomLeftRadius: Settings.cornerRadius
        MouseArea {
          id: select
          anchors.fill: panelBackground
          hoverEnabled: true
          acceptedButtons: Qt.LeftButton
        }
        ColumnLayout {
          id: col
          // TabBar {
          //   id: bar
          //   Layout.topMargin: 10
          //   Layout.leftMargin: 10
          //   Layout.bottomMargin: 10
          //   TabButton {
          //     text: qsTr("Wallpapers")
          //     onClicked: {
          //       wallpaper.visible=true
          //     } 
          //   }
          //   TabButton {
          //     text: qsTr("Wallhaven")
          //     onClicked: {
          //       wallpaper.visible=false
          //     } 
          //   }
          // }
          Modules.Wallpaper{
            id: wallpaper
          }
        }
      }
      IpcHandler {
        target: "panel"
        function togglewalls() {
          if (root.active == true)
            return root.active = false;
          else if (root.active == false)
            return root.active = true;
        }
      }
    }
  }
}
