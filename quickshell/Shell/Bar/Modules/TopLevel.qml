import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Appearance
import qs.Settings

WrapperRectangle {
 id: toplevel
 color: 'transparent'

 RowLayout {
  id: list
  spacing: 5

  Repeater {
   model: ScriptModel {
     values: {
       const groups = {};
       for (const obj of ToplevelManager.toplevels.values) {
         if (!groups[obj.appId]) {
           groups[obj.appId] = [];
         }
         groups[obj.appId].push(obj);
       }
       return Object.values(groups);
     }
   }
   Rectangle {
    id: contentItem
    required property list<Toplevel> modelData
    height: 25
    width: 25
    color: (ToplevelManager.activeToplevel == contentItem.modelData[0]) ? Colors.palette.surface_bright : 'transparent'
    radius: 5
    Image {
     id: icon
     property DesktopEntry desktopEntry: DesktopEntries.heuristicLookup(contentItem.modelData[0].appId)
     anchors.fill: parent
     source: Quickshell.iconPath(desktopEntry?.icon, "image-missing")
     sourceSize.width: 25
     sourceSize.height: 25
     MouseArea {
      id: selectIcon
      anchors.fill: parent
      
     }
    }
   }
  }
 }
}
