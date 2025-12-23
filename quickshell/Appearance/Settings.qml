pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  property int fontSize: 12
  property int fontpixelSize: 13
  property int fontWeight: Font.Bold
  property string fontFamily: "Cantarell"
  property int radius: Quickshell.env('RADIUS')
}
