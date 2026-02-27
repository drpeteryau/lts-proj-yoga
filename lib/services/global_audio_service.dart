import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GlobalAudioService extends ChangeNotifier {
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // 🔥 Voice / Effect player
  static final AudioPlayer _effectPlayer = AudioPlayer();
  static bool isSoundEffectsEnabled = true;

  static Future<void> playClickSound() async {
    try {
      if (isSoundEffectsEnabled) {
        await _effectPlayer.resume();
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

  // 🔥 Session Timer
  Timer? _sessionTimer;
  Duration _sessionTotal = Duration.zero;
  Duration _sessionRemaining = Duration.zero;

  // 🔥 NEW: Prevent overlapping breathing cues
  bool _isCuePlaying = false;
  double _originalVolume = 0.8;

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
  Duration get sessionTotal => _sessionTotal;
  Duration get sessionRemaining => _sessionRemaining;

  Future<void> initialize() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    });

    // 🔥 MAIN FIX STARTS HERE
    await _effectPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _effectPlayer.setReleaseMode(ReleaseMode.stop);

    await _effectPlayer.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.none,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ),
    );
  }

  // 🔥 NEW: Breathing Voice Cue
  Future<void> playBreathingCue(String phase) async {
    if (!isSoundEffectsEnabled) return;
    if (_isCuePlaying) return;

    try {
      _isCuePlaying = true;

      String file;

      switch (phase) {
        case "inhale":
          file = "audio/inhale.mp3";
          break;
        case "exhale":
          file = "audio/exhale.mp3";
          break;
        case "hold":
          file = "audio/hold.mp3";
          break;
        default:
          _isCuePlaying = false;
          return;
      }

      // 🔥 Duck background music
      _originalVolume = _volume;
      await _audioPlayer.setVolume(_originalVolume * 0.4);

      await _effectPlayer.stop();
      await _effectPlayer.setSource(AssetSource(file));
      await _effectPlayer.resume();

      // Wait for cue to finish
      await Future.delayed(const Duration(seconds: 2));

      // 🔥 Restore volume
      await _audioPlayer.setVolume(_originalVolume);
    } catch (e) {
      debugPrint("Breathing cue error: $e");
    } finally {
      _isCuePlaying = false;
    }
  }

  // 🔥 Session Timer Logic (unchanged except kept intact)
  void startSessionTimer(Duration duration) {
    _sessionTimer?.cancel();

    _sessionTotal = duration;
    _sessionRemaining = duration;

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && _sessionRemaining.inSeconds > 0) {
        _sessionRemaining -= const Duration(seconds: 1);
        notifyListeners();
      } else if (_sessionRemaining.inSeconds <= 0) {
        timer.cancel();
        _handleSessionComplete();
      }
    });

    notifyListeners();
  }

  void _resumeSessionTimer() {
    if (_sessionRemaining.inSeconds <= 0) return;

    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && _sessionRemaining.inSeconds > 0) {
        _sessionRemaining -= const Duration(seconds: 1);
        notifyListeners();
      } else if (_sessionRemaining.inSeconds <= 0) {
        timer.cancel();
        _handleSessionComplete();
      }
    });
  }

  Future<void> _handleSessionComplete() async {
    const steps = 20;
    const fadeDuration = Duration(milliseconds: 2000);
    final stepDelay = fadeDuration.inMilliseconds ~/ steps;
    final volumeStep = _volume / steps;

    for (int i = 0; i < steps; i++) {
      _volume -= volumeStep;
      if (_volume < 0) _volume = 0;
      await _audioPlayer.setVolume(_volume);
      await Future.delayed(Duration(milliseconds: stepDelay));
    }

    await stop();
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTotal = Duration.zero;
    _sessionRemaining = Duration.zero;
    notifyListeners();
  }

  Future<void> playSound({
    required String assetFile,
    required String title,
    required String category,
    required String imageUrl,
  }) async {
    await _audioPlayer.stop();

    _currentAudioUrl = assetFile;
    _currentSoundTitle = title;
    _currentSoundCategory = category;
    _currentSoundImageUrl = imageUrl;

      await _audioPlayer.setSource(
    AssetSource("audio/$assetFile"),
  );
    await _audioPlayer.setVolume(_volume);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);

    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
      _sessionTimer?.cancel();
    } else {
      await _audioPlayer.resume();
      _isPlaying = true;
      _resumeSessionTimer();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentPosition = Duration.zero;
    stopSessionTimer();
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
    stopSessionTimer();
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
    _audioPlayer.setReleaseMode(
      _isRepeating ? ReleaseMode.loop : ReleaseMode.release,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
