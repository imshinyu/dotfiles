import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Taskbar.Modules
import qs.Appearance

Rectangle {
    id: systemTray
    visible: SystemTray.items.values.length > 0
    property var trayMenu: CustomTrayMenu{}
    ColumnLayout {
        id: tray
        spacing: 5
        Repeater {
            id: trayItem
            model: SystemTray.items
            Rectangle {
                id: trayIcon
                required property SystemTrayItem modelData
                width: 20
                height: 20
                radius: 20
                color: Colors.palette.background
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
                                     const widgetRect = window.contentItem.mapFromItem(trayIcon,40,trayIcon.height-20,trayIcon.width,trayIcon.height)
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
