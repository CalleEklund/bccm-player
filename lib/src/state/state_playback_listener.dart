import 'package:bccm_player/src/state/plugin_state_notifier.dart';
import '../pigeon/playback_platform_pigeon.g.dart';
import '../utils/extensions.dart';

class StatePlaybackListener implements PlaybackListenerPigeon {
  StatePlaybackListener(this.pluginStateNotifier);

  PlayerPluginStateNotifier pluginStateNotifier;

  @override
  void onPlaybackStateChanged(event) {
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId)
      ..setIsBuffering(event.isBuffering)
      ..setPlaybackState(event.playbackState)
      ..resyncPlaybackPositionTimer();
  }

  @override
  void onPlaybackEnded(event) {}

  @override
  void onMediaItemTransition(event) {
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId).setMediaItem(event.mediaItem);
  }

  @override
  void onPictureInPictureModeChanged(event) {
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId).setIsInPipMode(event.isInPipMode);
  }

  @override
  void onPositionDiscontinuity(event) {
    final positionMs = event.playbackPositionMs?.finiteOrNull()?.round();
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId)
      ..setPlaybackPosition(positionMs)
      ..resyncPlaybackPositionTimer();
  }

  @override
  void onPlayerStateUpdate(event) {
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId).setStateFromSnapshot(event.snapshot);
  }

  @override
  void onPrimaryPlayerChanged(event) {
    pluginStateNotifier.setPrimaryPlayer(event.playerId);
  }

  @override
  void onCues(SubtitleEvent event) {
    pluginStateNotifier.getOrAddPlayerNotifier(event.playerId).setCues(event.cues);
  }
}
