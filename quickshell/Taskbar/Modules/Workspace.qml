import Quickshell
import qs.Appearance as Appearance
import qs.Services as Services
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property var workspaces: Services.Mango.workspaces
    color: Appearance.Colors.palette.primary_container
    implicitHeight: workCol.implicitHeight
    radius: Appearance.Settings.radius
    width: workCol.implicitWidth
    ColumnLayout {
        id: workCol
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: 2
        Repeater {
            id:workspacePill
            model: 6
            delegate: Rectangle {
                id: pill
                required property int modelData
                color: modelData==Services.Mango.currentWorkspace-1 ? Appearance.Colors.palette.primary : 'transparent';
                implicitWidth: 28
                implicitHeight: 25
                radius: Appearance.Settings.radius
                Text {
                    id: workNum
                    anchors.centerIn: parent
                    color: Appearance.Colors.palette.on_primary
                    font {
                        family: Appearance.Settings.fontFamily
                        pixelSize: Appearance.Settings.fontpixelSize
                        weight: Appearance.Settings.fontWeight
                    }
                    text: modelData + 1
                    
                }
            }
        }
        MouseArea {
            anchors.fill:pill
            onClicked: {
                command: ["mmsg","-t",workspacePill.model]
            }
        }
    }
}
