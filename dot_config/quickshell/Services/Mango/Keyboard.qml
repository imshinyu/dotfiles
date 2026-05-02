pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQml

Singleton {
    id: keyboard
    property string keyboardLayout: ""
    // Process {
    //   id: keyboardProc
    //   command: ["sh", "-c", "mmsg -g -k"]
    //   stdout: SplitParser {
    //     onRead: data => {
    //       if (!data) return
    //       var parts = data.trim().split(/\s+/)
    //       var currentLayout = parts[2] || ""
    //       keyboard.keyboardLayout = currentLayout
    //       console.log("Current Keyboard Layout:", currentLayout)
    //     }
    //   }
    //   Component.onCompleted: running = true
    // }
    Timer {
        id: layoutTimer
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            layoutProcess.running = true
        }
    }
    Process {
        id: layoutProcess
        command: ["mmsg","-g" ,"-k"]
        stdout: SplitParser {
            onRead: line => {
                const regEx = /(\S+?) kb_layout (\S+)/;
                const data = regEx.exec(line);
                if(!data)
                    return;
                const keyboardName = data[2];
                if(keyboardName==="us") {
                    keyboard.keyboardLayout = "English";
                }
                else if(keyboardName==="ar") {
                    keyboard.keyboardLayout = "Arabic";
                }
                else {
                    keyboard.keyboardLayout = keyboardName;
                }
            }
        }
    }
}
