pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.Appearance as Appearance
Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, " hh:mm\n d | dddd")
    }
    property int fontSize:Appearance.Settings.fontSize
    property int fontWeight: Appearance.Settings.fontWeight
    property string family: Appearance.Settings.fontFamily
    property color color: Appearance.Colors.palette.on_primary

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
