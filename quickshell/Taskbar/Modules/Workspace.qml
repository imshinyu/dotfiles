import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.Colors as Colors
import qs.Services.Niri as Niri
import qs.Taskbar

Item {
    id: root
    required property ShellScreen screen
    property bool isDestroying: false
    property bool hovered: false

    signal workspaceChanged(int workspaceId, color accentColor)

    property ListModel localWorkspaces: ListModel {}
    property real masterProgress: 0.0
    property bool effectsActive: false
    property color effectColor: Colors.Colour.palette.primary

    property int horizontalPadding: 15
    property int spacingBetweenPills: 8

    height: {
        let total = localWorkspaces.count * 24; // Fixed height for all pills
        total += Math.max(localWorkspaces.count - 1, 0) * spacingBetweenPills;
        total += horizontalPadding * 2;
        return total;
    }
    width: 40

    Component.onCompleted: {
        localWorkspaces.clear();
        for (let i = 0; i < Niri.WorkspaceManager.workspaces.count; i++) {
            const ws = Niri.WorkspaceManager.workspaces.get(i);
            if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                localWorkspaces.append(ws);
            }
        }
        workspaceRepeater.model = localWorkspaces;
        updateWorkspaceFocus();
    }

    Connections {
        target: Niri.WorkspaceManager
        function onWorkspacesChanged() {
            localWorkspaces.clear();
            for (let i = 0; i < Niri.WorkspaceManager.workspaces.count; i++) {
                const ws = Niri.WorkspaceManager.workspaces.get(i);
                if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                    localWorkspaces.append(ws);
                }
            }

            workspaceRepeater.model = localWorkspaces;
            updateWorkspaceFocus();
        }
    }

    SequentialAnimation {
        id: masterAnimation
        PropertyAction {
            target: root
            property: "effectsActive"
            value: true
        }
        NumberAnimation {
            target: root
            property: "masterProgress"
            from: 0.0
            to: 1.0
            duration: 1000
            easing.type: Easing.OutQuint
        }
        PropertyAction {
            target: root
            property: "effectsActive"
            value: false
        }
        PropertyAction {
            target: root
            property: "masterProgress"
            value: 0.0
        }
    }

    function updateWorkspaceFocus() {
        for (let i = 0; i < localWorkspaces.count; i++) {
            const ws = localWorkspaces.get(i);
            if (ws.isFocused === true) {
                root.workspaceChanged(ws.id, Colors.Colour.palette.primary);
                break;
            }
        }
    }

    Rectangle {
        id: workspaceBackground
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 10
        color: Colors.Colour.palette.surface_variant
        border.color: Colors.Colour.palette.primary
        border.width: 1
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowColor: "black"
            // radius: 12

            shadowVerticalOffset: 0
            shadowHorizontalOffset: 0
            shadowOpacity: 0.10
        }
    }

    Column {
        id: pillColumn
        spacing: spacingBetweenPills
        anchors.horizontalCenter: workspaceBackground.horizontalCenter
        height: root.height - horizontalPadding * 2
        width: root.width - horizontalPadding
        y: horizontalPadding
        Repeater {
            id: workspaceRepeater
            model: localWorkspaces
            Item {
                id: workspacePillContainer
                width: 26
                height: 28
                opacity: 0

                Component.onCompleted: {
                    fadeInAnimation.start();
                }

                PropertyAnimation {
                    id: fadeInAnimation
                    target: workspacePillContainer
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutCubic
                }

                PropertyAnimation {
                    id: fadeOutAnimation
                    target: workspacePillContainer
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                    easing.type: Easing.InCubic
                    onFinished: {
                        workspacePillContainer.destroy();
                    }
                }

                function fadeOut() {
                    fadeOutAnimation.start();
                }

                Rectangle {
                    id: workspacePill
                    anchors.fill: parent
                    radius: 8
                    color: {
                        if (model.isFocused)
                            return Colors.Colour.palette.primary;
                        else if (model.isUrgent)
                            return Colors.Colour.palette.error;
                        else
                            return "transparent";
                    }
                    z: 0

                    Text {
                        id: workspaceNumber
                        text: index + 1
                        anchors.centerIn: parent
                        color: model.isFocused ? Colors.Colour.palette.on_primary : "white"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    MouseArea {
                        id: pillMouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Niri.WorkspaceManager.switchToWorkspace(model.idx);
                        }
                        z: 20
                        hoverEnabled: true
                    }
                    // Material 3-inspired smooth animation for width, height, scale, color, opacity, and radius
                    Behavior on height {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutBack
                        }
                    }
                    Behavior on width {
                        NumberAnimation {
                            duration: 350
                            easing.type: Easing.OutBack
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                // Burst effect overlay for focused pill (smaller outline)
                Rectangle {
                    id: pillBurst
                    anchors.centerIn: workspacePillContainer
                    height: workspacePillContainer.height + 18 * root.masterProgress
                    width: workspacePillContainer.width + 18 * root.masterProgress
                    radius: height / 2
                    color: "transparent"
                    border.color: root.effectColor
                    border.width: (2 + 6 * (1.0 - root.masterProgress))
                    opacity: root.effectsActive && model.isFocused ? (1.0 - root.masterProgress) * 0.7 : 0
                    visible: root.effectsActive && model.isFocused
                    z: 1
                }
            }
        }
    }

    Component.onDestruction: {
        root.isDestroying = true;
    }
}
