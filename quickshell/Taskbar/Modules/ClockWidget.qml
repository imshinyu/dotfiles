import QtQuick
import qs.Services.Time
Text {
    text: Time.time
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: Time.color
    font {
      pixelSize: Time.fontSize
      family: Time.family
      weight: Time.fontWeight
    }
}
