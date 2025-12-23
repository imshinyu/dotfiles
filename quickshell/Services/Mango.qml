pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property var currentWorkspace
  Process {
    command: ["mmsg", "-w", "-t"]
    running: true
    onRunningChanged: if (!running) running = true
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


