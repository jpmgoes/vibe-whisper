import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _fxPlayer = AudioPlayer();
  final AudioPlayer _loopPlayer = AudioPlayer();

  AudioPlayerService() {
    _loopPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> prefetchAll() async {
    // Optional prefetch if needed to reduce latency
    await _fxPlayer.setSource(AssetSource('sounds/start.wav'));
    await _fxPlayer.setSource(AssetSource('sounds/done.wav'));
    await _fxPlayer.setSource(AssetSource('sounds/cancel.wav'));
    await _loopPlayer.setSource(AssetSource('sounds/loading.wav'));
  }

  Future<void> playStart() async {
    await _fxPlayer.play(AssetSource('sounds/start.wav'));
  }

  Future<void> playDone() async {
    await _fxPlayer.play(AssetSource('sounds/done.wav'));
  }

  Future<void> playCancel() async {
    await _fxPlayer.play(AssetSource('sounds/cancel.wav'));
  }

  Future<void> startLoadingLoop() async {
    await _loopPlayer.play(AssetSource('sounds/loading.wav'));
  }

  Future<void> stopLoadingLoop() async {
    await _loopPlayer.stop();
  }
}
