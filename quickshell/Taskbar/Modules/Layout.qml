import Quickshell
import QtQuick
import qs.Services
import qs.Appearance

Text {
  id: layout
  property var layoutName: Mango.layoutName
  clip: true
  color: Colors.palette.on_primary
    transform: [
        Rotation { origin.x: width/2; origin.y: height/2; angle: 90 },
        Scale { 
            origin.x: width/2; 
            origin.y: height/2
            xScale: 1; 
            yScale: 1 
        }
    ]
    font {
    pixelSize: Settings.fontpixelSize
    family: Settings.fontFamily
    bold: true
  }
  text: naming(layoutName)
  function naming(layoutName){
    if(layoutName == "S") return "Scroller";
    if(layoutName == "T") return "Tile";
    if(layoutName == "G") return "Grid";
    if(layoutName == "M") return "Monocle";
    if(layoutName == "K") return "Deck";
    if(layoutName == "VS") return "VScroller";
    if(layoutName == "VT") return "VTile";
    if(layoutName == "CT") return "CTile";
    else return " ";
  }
}
