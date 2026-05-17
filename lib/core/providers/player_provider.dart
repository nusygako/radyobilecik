import 'package:flutter/foundation.dart';
import 'package:radyo_app/core/models/station.dart';
import 'package:radyo_app/core/services/audio_handler.dart';
import 'package:radyo_app/config/constants.dart';

class PlayerProvider with ChangeNotifier {
  final RadioAudioHandler _audioHandler;

  Station? _currentStation;
  bool _isPlaying = false;
  double _volume = 0.7;
  String _songTitle = '';
  String _artistName = '';
  bool _isLoading = false;
  bool _isConnected = false;
  bool _hasError = false;
  String _errorMessage = '';

  PlayerProvider(this._audioHandler) {
    _initializeDefaultStation();
  }

  // Getters
  Station? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  /// True when the current station has a valid (non-placeholder) stream URL.
  bool get isStreamUrlValid {
    if (_currentStation == null) return false;
    final url = _currentStation!.streamUrl.trim();
    return url.isNotEmpty && !url.toUpperCase().contains('PLACEHOLDER');
  }

  /// Returns 'Canlı Yayın' after connecting (if no song metadata),
  /// 'Yükleniyor...' before connection, or the actual song title when available.
  String get songTitle {
    if (_isConnected) {
      return _songTitle.isEmpty ? 'Canlı Yayın' : _songTitle;
    }
    return _songTitle.isEmpty ? 'Yükleniyor...' : _songTitle;
  }

  String get artistName => _artistName;

  void _initializeDefaultStation() {
    _currentStation = Station(
      id: 'radyo11',
      name: AppConstants.radyo11Name,
      streamUrl: AppConstants.radyo11StreamUrl,
      fallbackStreamUrl: AppConstants.radyo11StreamUrlFallback,
      websiteUrl: AppConstants.radyo11Website,
      newsUrl: AppConstants.radyo11NewsUrl,
      facebookUrl: AppConstants.radyo11Facebook,
      instagramUrl: AppConstants.radyo11Instagram,
      whatsappNumber: AppConstants.radyo11WhatsApp,
      logoAssetPath: AppConstants.radyo11LogoAsset,
    );
  }

  Future<void> play() async {
    if (_currentStation == null) return;
    final streamUrl = _currentStation!.streamUrl.trim();
    if (streamUrl.isEmpty || streamUrl.toUpperCase().contains('PLACEHOLDER')) {
      // UI shows SnackBar via isStreamUrlValid check before calling togglePlayPause
      return;
    }

    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();

    try {
      await _audioHandler.prepareStation(streamUrl);
      await _audioHandler.play();
      _isPlaying = true;
      _isConnected = true;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Bağlantı hatası oluştu. Lütfen tekrar deneyin.';
      _isPlaying = false;
      _isConnected = false;
      if (kDebugMode) {
        print('Play error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioHandler.pause();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Pause error: $e');
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// Clears error state and attempts to reconnect.
  Future<void> reconnect() async {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
    await play();
  }

  Future<void> changeStation(Station station) async {
    _currentStation = station;
    _songTitle = '';
    _artistName = '';
    _isConnected = false;
    _hasError = false;
    _errorMessage = '';

    if (_isPlaying) {
      await pause();
      await play();
    }

    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    _audioHandler.setVolume(_volume);
    notifyListeners();
  }

  void updateMetadata({String? title, String? artist}) {
    if (title != null) _songTitle = title;
    if (artist != null) _artistName = artist;
    if (title != null) {
      _audioHandler.updateMetadata(
        title: _songTitle,
        artist: _artistName.isEmpty ? null : _artistName,
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audioHandler.dispose();
    super.dispose();
  }
}
