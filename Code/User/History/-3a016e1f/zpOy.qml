// Clock.qml
import QtQuick
import "Time.qml" as Time

Text {
  // we no longer need time as an input

  // directly access the time property from the Time singleton
  text: Time.root.time
}
