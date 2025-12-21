pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.Appearance as Appearance
Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh\nmm\n|\nd")
    }
    property int fontSize:Appearance.Colors.fontSize
    property int fontWeight: Appearance.Colors.fontWeight
    property string family: Appearance.Colors.family
    property color color: Appearance.Colors.palette.on_primary

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
