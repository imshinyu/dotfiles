import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.Appearance
import qs.Settings

Scope {
	id: root

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
	    target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
	
	    function onMutedChanged() { root.shouldShowOsd = true; hideTimer.restart(); }
	    function onVolumeChanged() { root.shouldShowOsd = true; hideTimer.restart(); }
	}
	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	// The OSD window will be created and destroyed based on shouldShowOsd.
	// PanelWindow.visible could be set instead of using a loader, but using
	// a loader will reduce the memory overhead when the window isn't open.
	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			// Since the panel's screen is unset, it will be picked by the compositor
			// when the window is created. Most compositors pick the current active monitor.

			anchors.top: true
			margins.top: 10
			exclusiveZone: 0

			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}
        	RectangularShadow {
        	    anchors.fill: item
        	    spread: 2.5
        	    radius: item.radius
        	    blur: 3
        	    color: Qt.rgba(0.1, 0.1, 0.1, 0.61)
        	}

			Rectangle {
				id: item
				anchors.centerIn: parent
				height: parent.height - 10
				width: parent.width - 10
				radius: Settings.cornerRadius
				color: Colors.palette.background

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}
					Text {
						Layout.preferredHeight: 30
						Layout.preferredWidth: 30
						font {
							pixelSize: 30
							family: "Symbols Nerd Font"
						}
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						color: "#fff"
						text:
							if (Pipewire.defaultAudioSink?.audio.volume===0.0) return "\udb81\udf5f";
							else if (Pipewire.defaultAudioSink?.audio.muted==true) return "\udb81\udf5f";
							else if(Pipewire.defaultAudioSink?.audio.volume<0.4 && Pipewire.defaultAudioSink?.audio.volume>0.0) return "\udb81\udd7f";
							else if (Pipewire.defaultAudioSink?.audio.volume>0.4 && Pipewire.defaultAudioSink?.audio.volume<0.7) return "\udb81\udd80";
							else if (Pipewire.defaultAudioSink?.audio.volume>0.5) return "\udb81\udd7e";
					}

					// IconImage {
					// 	implicitSize: 30
					// 	source:
					// 		if(Pipewire.defaultAudioSink?.audio.volume<0.5) return Quickshell.iconPath("volume_down");
					// 		else if (Pipewire.defaultAudioSink?.audio.volume==0) return Quickshell.iconPath("volume_mute");
					// 		else if (Pipewire.defaultAudioSink?.audio.volume>0.5) return Quickshell.iconPath("audio-volume-high");
					// 		else return Quickshell.iconPath("audio-volume-high-symbolic")
					// }

					Rectangle {
						// Stretches to fill all left-over space
						Layout.fillWidth: true

						implicitHeight: 10
						radius: Settings.widgetRadius
						color: Colors.palette.surface_bright
						Rectangle {
							color: Colors.palette.primary
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0) /1.5
							radius: parent.radius
						}
					}
				}
			}
		}
	}
}
