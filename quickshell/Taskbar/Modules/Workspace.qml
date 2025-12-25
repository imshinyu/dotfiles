import Quickshell
import Quickshell.Io
import qs.Appearance
import qs.Services
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property var workspaces: Mango.workspaces
    color: Colors.palette.primary_container
    implicitHeight: workCol.implicitHeight
    radius: Settings.radius
    width: workCol.implicitWidth
    ColumnLayout {
        id: workCol
        anchors.fill: parent
        spacing: 2
        Repeater {
            id:workspacePill
            model: 6
            delegate: Rectangle {
                id: pill
                required property int modelData
                color: modelData==(Mango.currentWorkspace-1 ?? Niri.Niri.focusedWorkspace) ? Colors.palette.primary : 'transparent';
                implicitWidth: 28
                implicitHeight: 25
                radius: Settings.radius
                MouseArea {
                    anchors.fill: pill
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onClicked: changeWorkspace.running = true
                }
                Process {
                    id: changeWorkspace
                    command: ["mmsg","-t",modelData+1]
                }
                Text {
                    id: workNum
                    anchors.centerIn: parent
                    color: modelData==Mango.currentWorkspace-1 ? Colors.palette.on_primary : Colors.palette.on_surface
                    font {
                        family: Settings.fontFamily
                        pixelSize: Settings.fontpixelSize
                        weight: Settings.fontWeight
                    }
                    text: modelData + 1
                    //text: Niri.NiriWindow.workspaceId
                    
                }
            }
        }
    }
}
