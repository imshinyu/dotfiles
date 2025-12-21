pragma Singleton
import Quickshell
import Quickshell.Io
import QtQml.Models

Singleton {
  id: root
  property string currentWorkspace: "0"
  Process {
    command: ["mmsg", "-w", "-t"]
    running: true
    stdout: SplitParser {
      onRead: line => {
          let c=0;
          const regEx = /(.*) tag (\d) (\d) (\d) (\d)/;
          const data = regEx.exec(line);
          if(!data)
            return;
          const Ntag = data[2];
          const StateTag = data[3];
          const Nclients = data[4];
          if ( StateTag == "1") {
            root.currentWorkspace = Ntag;
          }
      }
    }
  }
}


