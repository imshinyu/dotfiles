pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.Colors as Colors
Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh\nmm\n|\nddd\nd")
    }
    property int fontSize: 11
    property int fontWeight: Font.Bold
    property string family: "monospace"
    property color color: Colors.Colour.palette.on_primary

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
