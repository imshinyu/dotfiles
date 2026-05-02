import qs.Appearance as Appearance
import qs.Time
pragma ComponentBehavior: Bound
import QtQuick
import QtCore
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Greetd
ShellRoot{
    id: root
    readonly property string backgroundImage: "./wallhaven-exjvek_1920x1080.png"
    property var users: []
    property var sessions: []
    property var sessionsCommand: []
    property int selectedUser: 0
    property int selectedSession: 0
    property var userToSessionMap: {
        "shinyu": "Niri",
        "biscuit": "Niri",
        "family": "Plasma (Wayland)"
    }

    Process {
      id: getUsers
      command: ["bash", "-c", "getent passwd | grep -E ':[0-9]{4}:' | cut -d: -f1"]
      running: true
      stdout:StdioCollector {
        onStreamFinished: {
          var userList = text.trim().split('\n').filter(u => u.length > 0)
          root.users = userList
        }
      }
    }
    Process {
      id: getSessions
      command: ["bash", "-c", "find /run/current-system/sw/share/wayland-sessions/ -name '*.desktop' 2>/dev/null | while read f; do name=$(grep '^Name=' \"$f\" | cut -d= -f2); exec=$(grep '^Exec=' \"$f\" | cut -d= -f2); echo \"$name|||$exec\"; done"]
      running: true
      stdout: StdioCollector {
        onStreamFinished: {
          var lines = text.trim().split('\n').filter(l => l.length > 0)
          var names = []
          var commands = []
          if(lines.length === 0) {
            names = ["Default Session"]
            commands = ["bash"]
          } else {
              for (var i=0;i<lines.length;i++){
                var parts = lines[i].split('|||')
                if (parts.length === 2){
                  names.push(parts[0])
                  commands.push(parts[1])
                }
              }
          }
          root.sessions = names
          root.sessionsCommand = commands
        }
      }
    }
    function submitlogin(){
        if(selectedUser < users.length && passwordInput.text.length > 0) {
            loginButton.enabled = false
            statusText.text = "Wait"
            var username = users[selectedUser]
            Greetd.createSession(username)
        }
    }
    Connections {
        target: Greetd

        function onAuthMessage(message, error, responseRequired, echoResponse) {
            statusText.text = message

            if (responseRequired) {
                passwordInput.forceActiveFocus()
                if (passwordInput.text.length > 0) {
                    Greetd.respond(passwordInput.text)
                }
            }
        }

        function onAuthFailure(message) {
            statusText.text = "Failed: " + message
            passwordInput.text = ""
            loginButton.enabled = true
        }

        function onReadyToLaunch() {
            statusText.text = "Launching..."

            var command = ["bash"]
            if (root.selectedSession < root.sessionsCommand.length)
                command = [root.sessionsCommand[root.selectedSession]]

            console.log("Launching command:", command)
            Greetd.launch(command)
        }

        function onError(error) {
            statusText.text = "Error: " + error
            loginButton.enabled = true
        }
    }
    PanelWindow {
        id: bgWindow
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }
        color: 'transparent'
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            color: Appearance.Colors.palette.background
        }
        Image {
            anchors.fill: parent
            source: root.backgroundImage ?? Appearance.Colors.background
        }
    }

    PanelWindow {
        id: loginWindow
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }
        color: "transparent"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        Text {
            text: Time.time
            horizontalAlignment:  Text.AlignHCenter 
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: {
                top: 40
            }
            color: Appearance.Colors.palette.on_background
            renderType: Text.NativeRendering
            renderTypeQuality: Text.VeryHighRenderTypeQuality
            font {
              pixelSize: 60
              family: Appearance.Settings.fontFamily
              weight: Appearance.Settings.fontWeight
            }
        }

        Item {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 40
            width: 440
            height: loginBox.height

            Rectangle {
                id: loginBox
                anchors.centerIn: parent
                width: parent.width
                height: content.height + 60
                radius: 20
                color: Appearance.Colors.palette.surface
                border.width: 2
                border.color: Appearance.Colors.palette.surface_bright

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: 0.3
                    shadowColor: Appearance.Colors.palette.shadow
                    shadowBlur: 1
                    shadowScale: 1
                }

                ColumnLayout {
                    id: content
                    anchors.centerIn: parent
                    // anchors.margins: 20
                    spacing: -40

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Sessions"
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
                        font.bold: true
                        bottomPadding: 60
                        renderType: Text.NativeRendering
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                        color: (sessionList.activeFocus) ? Appearance.Colors.palette.primary : Appearance.Colors.palette.on_surface
                    }
                    Appearance.StyledDropDown {
                        id: sessionList
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 50
                        currentIndex: root.selectedSession
                        model: root.sessions
                        focus: false
                        onCurrentIndexChanged: {
                            root.selectedSession = currentIndex
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Users"
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
                        font.bold: true
                        bottomPadding: 5
                        renderType: Text.NativeRendering
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                        color: (iconListView.activeFocus) ? Appearance.Colors.palette.primary : Appearance.Colors.palette.on_surface
                    }
                    ListView {
                        id: iconListView
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 300
                        implicitHeight: 50
                        Layout.topMargin: 50
                        Layout.leftMargin: 160
                        activeFocusOnTab: true
                        model: root.users
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapToItem
                        spacing: 10
                        focus: true
                        clip: true
                        onCurrentIndexChanged: {
                            root.selectedUser = currentIndex
                        }
                        delegate : ClippingRectangle {
                            id: clipRec
                            required property string modelData
                            required property int index
                            width: 40
                            height: 40
                            color: 'transparent'
                            radius: Appearance.Settings.radius
                            // border.width: 1
                            // border.color: Appearance.Colors.palette.primary
                            Image {
                                id: icon
                                anchors.fill: parent
                                source: "file:///var/lib/AccountsService/icons/" + clipRec.modelData
                                sourceSize.width: 40
                                sourceSize.height: 40
                                opacity: root.selectedUser === clipRec.index ? 1.0 : 0.2
                                MouseArea {
                                    anchors.fill: icon
                                    cursorShape: Qt.PointingHandCursor
                                    acceptedButtons: Qt.LeftButton
                                    onClicked : {
                                        iconListView.currentIndex = clipRec.index
                                    }
                                }
                            }
                        }
                    }
                    ListView {
                        id: userListView
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 50
                        implicitHeight: 100
                        Layout.topMargin: 20
                        model: root.users
                        currentIndex: root.selectedUser
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapToItem
                        spacing: 10
                        clip: true
                        onCurrentIndexChanged: {
                            root.selectedUser = currentIndex
                            let username = root.users[currentIndex]
                            let targetSession = root.userToSessionMap[username]
                            if (targetSession !== undefined) {
                                for (let i = 0; i < root.sessions.length; i++) {
                                    if (root.sessions[i] === targetSession) {
                                        sessionList.currentIndex = i
                                        break
                                    }
                                }
                            }
                        }
                        delegate: WrapperItem {
                            required property string modelData
                            required property int index
                            id: contentItem
                            width: 50
                            height: 50
                            margin: 10
                            Text {
                                anchors.centerIn: parent
                                id: text
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                // color: (userSelection.currentIndex==) ? Appearance.Colors.palette.on_surface_variant : Appearance.Colors.palette.on_surface
                                color: Appearance.Colors.palette.on_surface
                                text: contentItem.modelData
                                font.pixelSize: 14
                                renderType: Text.NativeRendering
                                renderTypeQuality: Text.VeryHighRenderTypeQuality
                                font.family: Appearance.Settings.fontFamily
                            }
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        // Layout.topMargin: 45
                        Layout.bottomMargin: 45
                        text: "Password"
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
                        font.bold: true
                        bottomPadding: 5
                        renderType: Text.NativeRendering
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                        color: (passwordInput.activeFocus) ? Appearance.Colors.palette.primary : Appearance.Colors.palette.on_surface
                    }
                    TextField {
                        id: passwordInput
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 60
                        hoverEnabled: true
                        color: Appearance.Colors.palette.on_surface_variant
                        background: Rectangle {
                            implicitWidth: 150
                            color: (passwordInput.hovered) ? Qt.darker(Appearance.Colors.palette.background) : Qt.darker(Appearance.Colors.palette.surface_container)
                            radius: 5
                            border.width: passwordInput.activeFocus ? 0 : 0
                            border.color: Appearance.Colors.palette.primary
                        }
                        Layout.maximumWidth: parent.width * 2
                        echoMode: TextField.Password
                        Keys.onReturnPressed: submitlogin()
                    }
                    Text {
                        id: statusText
                        Layout.fillWidth: true
                        Layout.bottomMargin: 60
                        color: Appearance.Colors.palette.primary
                        wrapMode: Text.WordWrap
                        visible: text !== ""
                        horizontalAlignment: Text.AlignHCenter
                        renderType: Text.NativeRendering
                        renderTypeQuality: Text.VeryHighRenderTypeQuality
                    }
                    Button {
                        id: loginButton
                        Layout.alignment: Qt.AlignCenter
                        Layout.maximumWidth: parent.width * 2
                        hoverEnabled: true
                        Text {
                            text: "Log in"
                            anchors.centerIn: parent
                            color: Appearance.Colors.palette.on_surface
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            renderType: Text.NativeRendering
                            renderTypeQuality: Text.VeryHighRenderTypeQuality
                            font.pixelSize: 14
                            font.family: Appearance.Settings.fontFamily
                        }
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 25
                            border.width: loginButton.hovered ? 0 : 0
                            border.color: Appearance.Colors.palette.surface_container
                            radius: 5
                            color: (loginButton.hovered || loginButton.activeFocus) ? Qt.darker(Appearance.Colors.palette.background) : Qt.darker(Appearance.Colors.palette.surface_container) 
                        }
                        onClicked: submitlogin()
                        enabled: statusText.text === "" || statusText.text.includes("Failed")
                    }

                }
            }
        }
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            Button {
                id: exit
                hoverEnabled: true
                Text {
                    text: "Exit"
                    anchors.centerIn: parent
                    color: Appearance.Colors.palette.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    renderType: Text.NativeRendering
                    renderTypeQuality: Text.VeryHighRenderTypeQuality
                    verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                        font.family: Appearance.Settings.fontFamily
                }
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: exit.hovered ? 0 : 0
                    border.color: Appearance.Colors.palette.primary
                    radius: 5
                    color: (exit.hovered || exit.activeFocus) ? Qt.darker(Appearance.Colors.palette.background) : Appearance.Colors.palette.background
                }
                onClicked: Qt.quit()
                visible: !Greetd.available
            }
            Button {
                id: restart
                hoverEnabled: true
                Text {
                    text: "Restart"
                    anchors.centerIn: parent
                    color: Appearance.Colors.palette.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    renderTypeQuality: Text.VeryHighRenderTypeQuality
                    font.pixelSize: 14
                    font.family: Appearance.Settings.fontFamily
                }
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: restart.hovered ? 0 : 0
                    border.color: Appearance.Colors.palette.primary
                    radius: 5
                    color: (restart.hovered || restart.activeFocus)? Qt.darker(Appearance.Colors.palette.background) : Appearance.Colors.palette.background
                }
                onClicked: {
                    Quickshell.execDetached({ command: ["systemctl", "reboot" ]})
                }
            }
            Button {
                id: shutdown
                hoverEnabled: true
                Text {
                    text: "Shutdown"
                    anchors.centerIn: parent
                    color: Appearance.Colors.palette.on_surface
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    renderTypeQuality: Text.VeryHighRenderTypeQuality
                    font.pixelSize: 14
                    font.family: Appearance.Settings.fontFamily
                }
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: shutdown.hovered ? 0 : 0
                    border.color: Appearance.Colors.palette.primary
                    radius: 5
                    color: (shutdown.hovered || shutdown.activeFocus) ? Qt.darker(Appearance.Colors.palette.background) : Appearance.Colors.palette.background
                }
                onClicked: {
                    Quickshell.execDetached({ command: ["systemctl", "poweroff" ]})
                }
            }
        }
    }
}
