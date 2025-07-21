import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time
  Variants {
    model: Quickshell.screens
    delegate: Component {
      PanelWindow {
        property var modelData
        screen: modelData
        anchors {
          top: false
          left: true
          right: true
          bottom: true
        }
        implicitHeight: 33
        Text {
          anchors.right: parent
          text: root.time
        }
      }
    }
  }
  Process {
    id: dateProc
    command: ["date"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
