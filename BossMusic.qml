import QtQuick
import QtMultimedia

Item {
  id: music
  property bool ending: false
  readonly property bool playing: player.playing

  function fadeAway() {
    fadeIn.stop()
    fadeOut.restart()
  }
  onEndingChanged: if (ending) fadeAway()
  Component.onCompleted: player.play()
  Component.onDestruction: {
    fadeIn.stop(); fadeOut.stop(); player.stop()
  }

  // Decode the compressed soundtrack as it plays; do not preload a long WAV.
  MediaPlayer {
    id: player
    source: Qt.resolvedUrl("sounds/giant-wings.mp3")
    loops: MediaPlayer.Infinite
    audioOutput: AudioOutput { id: output; volume: 0 }
    onPlaybackStateChanged: {
      if (playing) {
        if (music.ending) player.stop()
        else fadeIn.restart()
      }
    }
    onErrorOccurred: function(error, errorString) { console.warn("Motherfly soundtrack:", errorString) }
  }
  NumberAnimation {
    id: fadeIn
    target: output; property: "volume"
    to: 0.38; duration: 1600
    easing.type: Easing.InOutQuad
  }
  NumberAnimation {
    id: fadeOut
    target: output; property: "volume"
    to: 0; duration: 1200
    onFinished: player.stop()
  }
}
