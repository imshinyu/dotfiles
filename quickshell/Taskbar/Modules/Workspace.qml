import Quickshell
import Quickshell.Hyprland
import qs.Appearance as Appearance
import qs.Services as Services
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property var workspaces: Services.Mango.workspaces ?? Services.Niri.workspaces
    color: Appearance.Colors.palette.primary_container
    implicitHeight: workCol.implicitHeight + 20
    radius: 10
    width: workCol.implicitWidth
    ColumnLayout {
        id: workCol
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 5
        Rectangle {
            color: Appearance.Colors.palette.primary
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            Text {
                id: workNum
                anchors.centerIn: parent
                color: Appearance.Colors.palette.on_primary
                font {
                    family: Appearance.Colors.family
                    pixelSize: Appearance.Colors.fontpixelSize
                    bold: true
                }
                text: Services.Mango.currentWorkspace
            }
        }
    }
}
