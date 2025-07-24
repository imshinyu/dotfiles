// Clock.qml
import QtQuick
import Time 1.0

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Time.time
}
