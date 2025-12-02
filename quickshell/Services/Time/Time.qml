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
    property int fontSize:Colors.Colour.fontSize
    property int fontWeight: Colors.Colour.fontWeight
    property string family: Colors.Colour.family
    property color color: Colors.Colour.palette.on_primary

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
