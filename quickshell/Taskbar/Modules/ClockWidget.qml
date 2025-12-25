import QtQuick
import qs.Services
import qs.Appearance
Text {
    text: Time.time
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: Colors.palette.on_primary
    font {
      pixelSize: Settings.fontSize
      family: Settings.fontFamily
      weight: Settings.fontWeight
    }
}
