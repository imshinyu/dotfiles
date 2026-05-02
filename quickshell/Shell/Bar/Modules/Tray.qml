import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Shell.Bar.Modules
import qs.Appearance
import qs.Settings

Rectangle {
    id: systemTray
    visible: SystemTray.items.values.length > 0
    color: Colors.palette.surface_bright
    radius: Settings.widgetRadius
    implicitHeight: childrenRect.height + 10
    implicitWidth: childrenRect.width + 10
    ColumnLayout {
        id: tray
        spacing: 3
        anchors.centerIn: parent
        Repeater {
            id: trayItem
            model: SystemTray.items
            Rectangle {
                id: trayIcon
                required property SystemTrayItem modelData
                width: 20
                height: 20
                radius: 20
                color: 'transparent'
                // color: 'transparent'
                 MouseArea {
                     anchors.fill: parent
                     hoverEnabled: true
                     cursorShape: Qt.PointingHandCursor
                     acceptedButtons: Qt.LeftButton | Qt.RightButton
                     onClicked: event=> {
                         switch (event.button) {
                             case Qt.LeftButton:
                                 trayIcon.modelData.activate();
                                 break;
                             case Qt.RightButton:
                                 if(trayIcon.modelData.hasMenu){
                                     // const x=20
                                     // const y=400
                                     // trayMenu.showAt(trayIcon.height + 10,trayIcon.width);
                                     const window = QsWindow.window;
                                     const widgetRect = window.contentItem.mapFromItem(trayIcon,30,trayIcon.height-15,trayIcon.width,trayIcon.height)
                                     menuAnchor.anchor.rect = widgetRect;
                                     menuAnchor.open();
                                 }
                                 break;
                         }
                     }
                }
                 QsMenuAnchor {
                     id: menuAnchor
                     menu: trayIcon.modelData.menu
                     anchor.window: trayIcon.QsWindow.window ?? null
                     anchor.adjustment: PopupAdjustment.Flip
                 }
                Image {
                    id: icon
                    anchors.fill: parent
                    source: trayIcon.modelData.icon
                    sourceSize.width: 20
                    sourceSize.height: 20
                }
            }
        }
    }
}
