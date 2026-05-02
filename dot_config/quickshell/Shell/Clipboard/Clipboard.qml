pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Appearance
import qs.Settings

Variants {
    model: Quickshell.screens
    Scope {
        id: root
        required property ShellScreen modelData
        property color backgroundColor: Colors.palette.surface
        property bool active: false
        property list<var> items: []
        property list<var> foundItems: items
        property int maxListHeight: 500
        property int maxListWidth: 500
        LazyLoader {
            id: loader
            active: root.active
            PanelWindow {
                id: clipboard
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
                Keys.onEscapePressed: root.active = false
                RectangularShadow {
                    anchors.fill: background
                    spread: 2.5
                    radius: Settings.cornerRadius
                    blur: 3
                    color: Qt.rgba(0.0, 0.0, 0.0, 0.61)
                }
                Rectangle {
                    id: background
                    width: clipboard.width - 5
                    height: clipboard.height - 5
                    color: backgroundColor
                    anchors.centerIn: parent
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Escape) {
                            root.active = false
                        }
                    }
                    radius: Settings.cornerRadius
                    // focus: true
                    Process {
                        id: notificationsFetchProc
                        command: ["cliphist", "list"]
                        stdout: StdioCollector {
                            onStreamFinished: {
                                items = text.split('\n').filter(line => line.trim() !== "").map(line => {
                                    const parts = line.split('\t');
                                    return {
                                        id: parseInt(parts[0], 10),
                                        content: parts.length > 1 ? parts.slice(1).join('\t') : ""
                                    };
                                });
                                updateFoundItems();
                            }
                        }
                        running: true
                    }
                           
                    Process {
                        id: notificationsDecodeProc
                    }
                            
                    function updateItems() {
                        notificationsFetchProc.running = true;
                    }
                            
                    function updateFoundItems() {
                        root.foundItems = root.items.filter(i => i.content.toLowerCase().includes(clipboardTextField.text.toLowerCase()));
                        itemsList.currentIndex = root.foundItems.length > 0 ? 0 : -1;
                        itemsList.positionViewAtIndex(0, ListView.Beginning);
                    }
                            
                    function copyEntry(id) {
                        notificationsDecodeProc.command = ["sh", "-c", "cliphist decode " + id + " | wl-copy"];
                        notificationsDecodeProc.running = true;
                    }
                    ColumnLayout {
                        id: clipboardLayout
                        Keys.onDownPressed: {
                            if (itemsList.count > 0) {
                                itemsList.incrementCurrentIndex();
                                itemsList.positionViewAtIndex(itemsList.currentIndex, ListView.Contain);
                            }
                        }
                        Keys.onUpPressed: {
                            if (itemsList.count > 0) {
                                itemsList.decrementCurrentIndex();
                                itemsList.positionViewAtIndex(itemsList.currentIndex, ListView.Contain);
                            }
                        }
                        Keys.onEnterPressed: {
                            if (itemsList.currentIndex >= 0 && itemsList.currentIndex < itemsList.count) {
                                clipboardLayout.copyEntry(itemsList.model[itemsList.currentIndex].id);
                                root.active = false;
                            }
                        }
                    
                        Rectangle {
                            Layout.topMargin: 30
                            Layout.fillWidth: true
                            TextField {
                                id: clipboardTextField
                                focus: root.active
                                anchors.fill: parent
                                placeholderText: "Search in clipboard history"
                                onTextChanged: clipboardLayout.updateFoundItems()
                                onAccepted: {
                                    if (itemsList.currentIndex >= 0 && itemsList.currentIndex < itemsList.count)
                                        clipboardLayout.copyEntry(itemsList.model[itemsList.currentIndex].id);
                                    root.active = false;
                                }
                            }
                        }
                    
                        Rectangle {
                            id: itemsArea
                            visible: root.foundItems.length > 0
                            Layout.fillWidth: true
                            Layout.preferredWidth: maxListWidth
                            Layout.preferredHeight: Math.min(maxListHeight, itemsList.contentHeight * 2)
                    
                            ScrollView {
                                anchors.fill: parent
                                clip: true
                                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    
                                ListView {
                                    id: itemsList
                                    width: parent.availableWidth
                                    model: root.foundItems
                                    currentIndex: -1
                                    clip: true
                    
                                    delegate: Rectangle {
                                        id: delegateItem
                                        required property int index
                                        required property var modelData
                                        width: ListView.view.width
                                        border.color: {
                                            if (index === itemsList.currentIndex)
                                                return Colors.palette.primary;
                                            if (delegateMouseArea.containsMouse)
                                                return Colors.palette.primary;
                                            return Colors.palette.surface;
                                        }
                    
                                        Text {
                                            anchors {
                                                fill: parent
                                            }
                                            text: modelData.content
                                            wrapMode: Text.Wrap
                                        }
                    
                                        MouseArea {
                                            id: delegateMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: {
                                                itemsList.currentIndex = index;
                                                root.active = false;
                                                clipboardLayout.copyEntry(modelData.id);
                                            }
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
            target: "clipboard"
            function toggleclipboard() {
                root.active = !root.active;
            }
        }
    }
}
