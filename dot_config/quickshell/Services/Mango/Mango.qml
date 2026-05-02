pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  // property var currentWorkspace
  property var tags: []
  // property var layoutName
  // Process {
  //   command: ["mmsg","-w","-l"]
  //   running: true
  //   onRunningChanged: if (!running) running = true
  //   stdout: SplitParser {
  //     onRead: line=> {
  //       const regEx = /(.*) layout ([STGMKVC])/;
  //       const data = regEx.exec(line);
  //       if(!data)
  //         return;
  //       const Display = data[1];
  //       const Layout = data[2];
  //       root.layoutName = Layout;
  //     }
  //   }
  // }
  Process {
    command: ["mmsg", "-w", "-t"]
    running: Quickshell.env("XDG_CURRENT_DESKTOP") === "mango"
    stdout: SplitParser {
      onRead: line => {
          var newTags = root.tags.slice();
          var parts = line.trim().split(/\s+/)
          if (parts.length >= 6 && parts[1] === "tag") {
            var index = parseInt(parts[2])-1;
            var isFocused = parts[3] === "1";
            var windows = parseInt(parts[4]);
            var urgent = parts[5] === "1";
            newTags[index] = {
              workspaceId: index+1,
              isFocused: isFocused,
              containsWindow: windows > 0,
              urgent: urgent
            }
            root.tags = newTags
          }
      }
    }
  }
}


