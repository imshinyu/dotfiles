// Time.qml
pragma Singleton

import Quickshell
import QtQuick
import qs.Taskbar.colors
Singleton {
  id: root

  property int fontSize: 11
  property int fontWeight: Font.Bold
  property string family: "monospace"
  property color color: Colour.palette.on_background

  // an expression can be broken across multiple lines using {}
  readonly property string time: {
    // The passed format string matches the default output of
    // the `date` command.
    Qt.formatDateTime(clock.date, "hh\nmm")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
