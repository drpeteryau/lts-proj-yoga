import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  String? _currentSoundTitle;
  String? _currentSoundCategory;
  String? _currentSoundImageUrl;
  String? _currentAudioUrl;
  double _volume = 0.8;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isRepeating = false;

  // Getters
  bool get isPlaying => _isPlaying;
  String? get currentSoundTitle => _currentSoundTitle;
  String? get currentSoundCategory => _currentSoundCategory;
  String? get currentSoundImageUrl => _currentSoundImageUrl;
  String? get currentAudioUrl => _currentAudioUrl;
  double get volume => _volume;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isRepeating => _isRepeating;
  bool get hasSound => _currentSoundTitle != null;
  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> initialize() async {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    // Listen to completion
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentPosition = Duration.zero;

      if (_isRepeating && _currentAudioUrl != null) {
        // Replay the current sound
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> playSound({
    required String url,
    required String title,
    required String category,
    required String imageUrl,
  }) async {
    try {
      // Stop current playback if any
      await _audioPlayer.stop();

      // Set source and play
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.resume();

      // Update state
      _currentAudioUrl = url;
      _currentSoundTitle = title;
      _currentSoundCategory = category;
      _currentSoundImageUrl = imageUrl;
      _isPlaying = true;

      notifyListeners();
    } catch (e) {
      print('Error playing sound: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> clearSound() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentSoundTitle = null;
    _currentSoundCategory = null;
    _currentSoundImageUrl = null;
    _currentAudioUrl = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}