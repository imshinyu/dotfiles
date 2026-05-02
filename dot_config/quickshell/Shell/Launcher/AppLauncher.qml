// pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import qs.Appearance
import qs.Settings
import "./Fuzzy/fuzzysort.js" as FuzzySort
Variants {
    model: Quickshell.screens
    Scope {
        id: root
        required property ShellScreen modelData
        property bool active: false
        property color backgroundColor: Colors.palette.surface
        property color elementColor: Colors.palette.surface_container
        // property color elementColor: 'transparent'
        // property color backgroundColor: 'transparent'
        LazyLoader {
            id: loader
            active: root.active
            PanelWindow {
                id: launcher
                screen: root.modelData
                visible: root.active
                WlrLayershell.keyboardFocus: (root.active) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                WlrLayershell.layer: WlrLayer.Overlay
                exclusionMode: ExclusionMode.Normal
                focusable: true
                aboveWindows: true
                anchors: {
                    top: true
                    bottom: true
                    right: true
                    left: true
                }
                implicitWidth: 550
                implicitHeight: 400
                color: 'transparent'
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        root.active = false
                    }
                }
                RectangularShadow {
                    anchors.fill: background
                    spread: 2.5
                    radius: Settings.cornerRadius
                    blur: 3
                    color: Qt.rgba(0.0, 0.0, 0.0, 0.61)
                }
                Rectangle {
                    id: background
                    width: launcher.width - 5
                    height: launcher.height - 5
                    color: backgroundColor
                    anchors.centerIn: parent
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            root.active = false
                      }
                    }
                    radius: Settings.cornerRadius
                    // focus: true
                    ColumnLayout {
                        id: col
                        // anchors.top: background.top
                        anchors.fill: background
                        Rectangle {
                            id: search
                            width: background.width - 25
                            height: 35
                            radius: Settings.widgetRadius
                            Layout.topMargin: 10
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            color: elementColor
                            TextInput {
                                id: entry
                                focus: true
                                anchors.verticalCenter: parent.verticalCenter
                                x: 8
                                property bool searching: text.length > 0
                                property bool notSearching: text.length === 0
                                property string content: entry.text
                                property var current: appView.currentIndex
                                property bool keyboardControl: true
                                onTextChanged: {
                                    appView.model = text.length > 0
                                        ? FuzzySort.go(text, DesktopEntries.applications.values, {
                                            all: true,
                                            keys: ["name", "genericName", "icon"]
                                        }).map(a => a.obj)
                                        : DesktopEntries.applications;
                                }
                                Keys.onReturnPressed: {
                                    if (appView.count === 0) return;

                                    // Get the actual visible/filtered item at the current visual index
                                    const item = appView.currentIndex >= 0 ? appView.model[appView.currentIndex] : null;
                                    if (item && item.execute) {
                                        item.execute();  // Ensure the item has an execute method
                                        root.active = false;
                                        clear();
                                    }
                                }
                                Keys.onDownPressed: {
                                    appView.currentIndex = (appView.currentIndex + 1) % appView.count;
                                    appView.positionViewAtIndex(appView.currentIndex, ListView.Visible); // Slightly slower scrolling
                                }
                                Keys.onUpPressed: {
                                    appView.currentIndex = (appView.currentIndex - 1 + appView.count) % appView.count;
                                    appView.positionViewAtIndex(appView.currentIndex, ListView.Visible); // Slightly slower scrolling
                                }
                                Keys.onEscapePressed: {
                                    root.active = false
                                    clear()
                                }
                                Text {
                                    color: Colors.palette.primary
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: 'Search for something..'
                                    visible: entry.notSearching
                                }
                                color: Colors.palette.on_surface
                                font: {
                                    family: Settings.fontFamily
                                    pixelSize: Settings.fontpixelSize
                                    weight: Settings.fontWeight
                                }
                            }
                        }
                        Rectangle {
                            id: appListBackground
                            width: background.width - 25
                            implicitHeight: parent.height - 70
                            radius: Settings.widgetRadius
                            color: elementColor
                            Layout.topMargin: 10
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                            ListView {
                                focus: true
                                id: appView
                                width: parent.width - 16
                                height: parent.height - 15
                                model: entry.searching ? FuzzySort.go(entry.text, DesktopEntries.applications.values, {
                                    all: true,
                                    keys: ["name", "genericName", "icon"]
                                }).map(a => a.obj) : DesktopEntries.applications
                                y: 8
                                spacing: 8
                                anchors.horizontalCenter: parent.horizontalCenter
                                clip: true
                                flickDeceleration: 10000 // Even higher value for faster deceleration
                                maximumFlickVelocity: 10000 // Even higher value for faster initial flick speed
                                function launchModelData(): void {
                                    if (currentItem == currentItem.modelData) {
                                        currentItem.modelData.execute()
                                        root.active = false;
                                    }
                                }
                                delegate: Rectangle {
                                    id: delegated
                                    property bool isSelected: ListView.isCurrentItem
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: parent.width
                                    height: 32
                                    color: elementColor
                                    radius: Settings.widgetRadius
                                    states: [
                                        State {
                                            name: "selected"
                                            when: delegated.isSelected || handler.containsMouse

                                            PropertyChanges {
                                                target: delegated
                                                color: Colors.palette.primary
                                            }
                                            PropertyChanges {
                                                target: text
                                                color: elementColor
                                                weight: 900
                                                textWidth: 120
                                            }
                                        }
                                    ]
                                    transitions: [
                                        Transition {
                                            from: ""; to: "hovered"
                                            reversible: true
                                            ColorAnimation {
                                                properties: "color"; duration: 300; easing.type: Easing.OutQuad;
                                            }
                                            NumberAnimation {
                                                properties: "x, weight, textWidth"; duration: 300; easing.type: Easing.OutQuad;
                                            }
                                        }
                                    ]
                                    Image {
                                        id: appIcon
                                        anchors.verticalCenter: parent.verticalCenter
                                        x: 4
                                        width: 25
                                        height: 25
                                        source: {
                                            const ic = modelData?.icon ?? "";
                                            if (!ic) return "";
                                            if (ic.startsWith("/")) return ic;
                                            return Quickshell.iconPath(ic);
                                        }
                                    }
                                    Text {
                                        id: text
                                        anchors.verticalCenter: parent.verticalCenter
                                        x: 35
                                        font.variableAxes: {
                                            "wght": weight
                                        }
                                        font.family: Settings.fontFamily
                                        property int weight: 500
                                        font.pointSize: Settings.fontpixelSize
                                        text: modelData.name
                                        color: Colors.palette.primary
                                    }
                                    MouseArea {
                                        id: handler
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            modelData.execute();
                                            root.active = false;
                                        }
                                        onEntered: {
                                            root.keyboardControl = false; // Switch to mouse control
                                            appView.currentIndex = index;
                                        }
                                    }


                                    }
                                }
                            }
                        }
                    }
                }
            }
        IpcHandler {
            target: "launcher"
            function togglelauncher() {
                root.active = !root.active; // Toggle the active state
                if (root.active) {
                    entry.focus = true; // Ensure the search input gains focus
                } else {
                    entry.clear(); // Clear the search input when closing
                }
            }
        }
    }
}
