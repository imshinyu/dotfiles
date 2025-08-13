// Clock.qml
import QtQuick
import qs.Taskbar as Taskbar
import qs.Taskbar.time as Date

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Date.Time.time
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
  color: Date.Time.color
  font {
      pixelSize: Date.Time.fontSize
      family: Date.Time.family
      weight: Date.Time.fontWeight
  }
}
