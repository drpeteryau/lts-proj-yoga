import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // for sound effects like button clicks 
  static final AudioPlayer _effectPlayer = AudioPlayer();
  static bool isSoundEffectsEnabled = true;
  static Future<void> playClickSound() async {
  try {
      if (isSoundEffectsEnabled) {
        _effectPlayer.resume();    
      }
  } catch (e) {
    debugPrint("Error playing click sound: $e");
  }
}

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
    print('🎵 Initializing GlobalAudioService...');

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      print('🎵 Player state changed: $state');
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      print('🎵 Duration changed: $duration');
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
      print('🎵 Playback completed');
      _isPlaying = false;
      _currentPosition = Duration.zero;

      if (_isRepeating && _currentAudioUrl != null) {
        // Replay the current sound
        print('🎵 Repeating...');
        playSound(
          url: _currentAudioUrl!,
          title: _currentSoundTitle!,
          category: _currentSoundCategory!,
          imageUrl: _currentSoundImageUrl!,
        );
      } else {
        notifyListeners();
      }
    });

    // Setting the player to low latency mode is key for UI sounds
    await _effectPlayer.setReleaseMode(ReleaseMode.stop); 
    // Pre-load the click source into memory
    await _effectPlayer.setSource(AssetSource('audio/click.mp3'));

    print('🎵 GlobalAudioService initialized successfully');
  }

  Future<void> playSound({
    required String url,
    required String title,
    required String category,
    required String imageUrl,
  }) async {
    try {
      print('🎵 Playing sound: $title');
      print('🎵 URL: $url');

      // Stop current playback if any
      await _audioPlayer.stop();

      // Update state BEFORE playing
      _currentAudioUrl = url;
      _currentSoundTitle = title;
      _currentSoundCategory = category;
      _currentSoundImageUrl = imageUrl;

      // Set volume
      await _audioPlayer.setVolume(_volume);

      // Set release mode for looping if needed
      await _audioPlayer.setReleaseMode(_isRepeating ? ReleaseMode.loop : ReleaseMode.release);

      // Play using the correct API with timeout
      await _audioPlayer.play(UrlSource(url)).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('❌ Audio loading timed out after 15 seconds');
          throw TimeoutException('Audio loading timed out');
        },
      );

      _isPlaying = true;
      notifyListeners();

      print('🎵 Sound playing successfully');
    } catch (e) {
      print('❌ Error playing sound: $e');
      _isPlaying = false;
      // Clear the failed sound
      _currentSoundTitle = null;
      _currentSoundCategory = null;
      _currentSoundImageUrl = null;
      _currentAudioUrl = null;
      notifyListeners();
      rethrow; // Rethrow so the UI can show the error
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        print('🎵 Pausing audio');
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        print('🎵 Resuming audio');
        await _audioPlayer.resume();
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error toggling play/pause: $e');
    }
  }

  Future<void> stop() async {
    try {
      print('🎵 Stopping audio');
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    } catch (e) {
      print('❌ Error stopping audio: $e');
    }
  }

  Future<void> clearSound() async {
    try {
      print('🎵 Clearing sound');
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentSoundTitle = null;
      _currentSoundCategory = null;
      _currentSoundImageUrl = null;
      _currentAudioUrl = null;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      notifyListeners();
    } catch (e) {
      print('❌ Error clearing sound: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      print('❌ Error setting volume: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      print('🎵 Seeking to: $position');
      await _audioPlayer.seek(position);
      notifyListeners();
    } catch (e) {
      print('❌ Error seeking: $e');
    }
  }

  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    _audioPlayer.setReleaseMode(_isRepeating ? ReleaseMode.loop : ReleaseMode.release);
    print('🎵 Repeat mode: $_isRepeating');
    notifyListeners();
  }

  @override
  void dispose() {
    print('🎵 Disposing GlobalAudioService');
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