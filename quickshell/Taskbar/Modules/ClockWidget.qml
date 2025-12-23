import QtQuick
import qs.Services as Services
import qs.Appearance as Appearance
Text {
    text: Services.Time.time
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: Appearance.Colors.palette.on_primary
    font {
      pixelSize: Appearance.Settings.fontSize
      family: Appearance.Settings.fontFamily
      weight: Appearance.Settings.fontWeight
    }
}
