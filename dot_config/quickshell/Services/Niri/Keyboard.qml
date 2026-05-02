pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io

Singleton {
    id: keyboard
    property string keyboardLayout: "English"
    property int keyboardId: 0
    Process {
        command: ["bash", "-c", "niri msg event-stream | grep --line-buffered 'Keyboard layout switched:'"]
        running: true
        onRunningChanged: if (!running) running = true
        stdout: SplitParser {
            onRead: line => {
                const regEx = /Keyboard layout switched: (\d+)/;
                const data = regEx.exec(line);
                if(!data)
                    return;
                const keyboardNum = parseInt(data[1]);
                keyboard.keyboardId=keyboardNum;
                if(keyboardNum===0) {
                    keyboard.keyboardLayout = "English";
                }
                else if(keyboardNum===1) {
                    keyboard.keyboardLayout = "Arabic";
                }
                else {
                    keyboard.keyboardLayout = "Layout" + keyboardNum;
                }
                console.log("Keyboard layout changed to:", keyboard.keyboardLayout);
            }
        }
    }
}
