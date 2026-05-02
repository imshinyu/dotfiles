import Quickshell.Widgets
import QtQuick
import qs.Services
import qs.Appearance
import qs.Settings
Rectangle {
    id: wrapperItem
    color: Colors.palette.surface_bright
    radius: Settings.widgetRadius
    // margin: 1
    implicitHeight: text.height + 5
    implicitWidth: text.width + 5
    Text {
        id: text
        text: Time.time
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Colors.palette.primary
        font {
          pixelSize: Settings.fontpixelSize
          family: Settings.fontFamily
          weight: Settings.fontWeight
        }
    }
}
