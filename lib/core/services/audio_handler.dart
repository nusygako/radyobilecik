import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class RadioAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  String? _streamUrl;

  Future<void> prepareStation(String streamUrl) async {
    _streamUrl = streamUrl;
    try {
      await _player.setUrl(streamUrl);
    } catch (e) {
      debugPrint('Audio handler prepare error: $e');
      rethrow;
    }
  }

  Future<void> play() async {
    if (_streamUrl == null) return;
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  void dispose() {
    _player.dispose();
  }

  void updateMetadata({required String title, String? artist}) {
    // Metadata handled by provider state
  }
}
