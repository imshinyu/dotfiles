import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.Services
import qs.Services.Niri as Niri
import qs.Services.Mango as Mango
import qs.Appearance
import qs.Settings

Rectangle {
    id: wrapperItem
    radius: Settings.widgetRadius
    color: Colors.palette.surface_bright
    transform: [
        Rotation { origin.x: width/2; origin.y: height/2; angle: 90 },
        Scale { 
            origin.x: width/2; 
            origin.y: height/2
            xScale: 1; 
            yScale: 1 
        }
    ]
    implicitHeight: layout.height + 13
    implicitWidth: layout.width + 13
    Text {
        id: layout
        anchors.centerIn: parent
        property string layoutName: detectCompositor()
        clip: true
        color: Colors.palette.primary
        MouseArea {
            id: layoutMouse
            anchors.fill: layout
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton
            onClicked:
            if (detectCompositor()==Mango.Keyboard.keyboardLayout)
                Quickshell.execDetached(["bash", "-c", "mmsg -d switch_keyboard_layout"])
            else
                Quickshell.execDetached(["bash", "-c", "niri msg action switch-layout prev"])
        }
        font {
          pixelSize: Settings.fontpixelSize
          family: Settings.fontFamily
          bold: true
        }
        text: layoutName
    }
    function detectCompositor(){
        if (Quickshell.env("XDG_CURRENT_DESKTOP")=="niri") return Niri.Keyboard.keyboardLayout
        if (Quickshell.env("XDG_CURRENT_DESKTOP")=="mango") return Mango.Keyboard.keyboardLayout
    }
    
}
