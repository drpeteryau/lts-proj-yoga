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
  bool _sessionStartCancelled = false;
  bool _isPreparing = false;
bool get isPreparing => _isPreparing;
bool _isManuallyStopped = false;

  // 🔥 Session Timer
  Timer? _sessionTimer;
  Duration _sessionTotal = Duration.zero;
  Duration _sessionRemaining = Duration.zero;

  // 🔥 NEW: Prevent overlapping breathing cues
  bool _isCuePlaying = false;
  double _originalVolume = 0.8;
  int _lastPhaseIndex = -1;

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

  _lastPhaseIndex = -1; // reset phase tracking

  _sessionTotal = duration;
  _sessionRemaining = duration;

  _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_isPlaying && _sessionRemaining.inSeconds > 0) {
      _sessionRemaining -= const Duration(seconds: 1);

      // 🔥 BREATHING PHASE LOGIC MOVED HERE
      final seconds = _sessionRemaining.inSeconds;
      final phase = seconds % 24;

      int currentPhaseIndex;

      if (phase < 6) {
        currentPhaseIndex = 0;
      } else if (phase < 12) {
        currentPhaseIndex = 1;
      } else if (phase < 18) {
        currentPhaseIndex = 2;
      } else {
        currentPhaseIndex = 3;
      }

      if (currentPhaseIndex != _lastPhaseIndex) {
        _lastPhaseIndex = currentPhaseIndex;

        if (currentPhaseIndex == 0) {
          playBreathingCue("inhale");
        } else if (currentPhaseIndex == 1) {
          playBreathingCue("hold");
        } else if (currentPhaseIndex == 2) {
          playBreathingCue("exhale");
        } else {
          playBreathingCue("hold");
        }
      }

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

      // 🔥 ADD BREATHING LOGIC HERE (same as startSessionTimer)
      final seconds = _sessionRemaining.inSeconds;
      final phase = seconds % 24;

      int currentPhaseIndex;

      if (phase < 6) {
        currentPhaseIndex = 0;
      } else if (phase < 12) {
        currentPhaseIndex = 1;
      } else if (phase < 18) {
        currentPhaseIndex = 2;
      } else {
        currentPhaseIndex = 3;
      }

      if (currentPhaseIndex != _lastPhaseIndex) {
        _lastPhaseIndex = currentPhaseIndex;

        if (currentPhaseIndex == 0) {
          playBreathingCue("inhale");
        } else if (currentPhaseIndex == 1) {
          playBreathingCue("hold");
        } else if (currentPhaseIndex == 2) {
          playBreathingCue("exhale");
        } else {
          playBreathingCue("hold");
        }
      }

      notifyListeners();

    } else if (_sessionRemaining.inSeconds <= 0) {
      timer.cancel();
      _handleSessionComplete();
    }
  });
}

Future<void> _handleSessionComplete() async {
  if (_isManuallyStopped) {
  _isManuallyStopped = false;
  return;
}
  const steps = 20;
  const fadeDuration = Duration(milliseconds: 2000);
  final stepDelay = fadeDuration.inMilliseconds ~/ steps;

  final originalVolume = _volume;
  double tempVolume = originalVolume;

  for (int i = 0; i < steps; i++) {
    tempVolume -= originalVolume / steps;
    if (tempVolume < 0) tempVolume = 0;

    await _audioPlayer.setVolume(tempVolume);
    await Future.delayed(Duration(milliseconds: stepDelay));
  }

  await stop();

  _isPlaying = false;
  notifyListeners();

  // 🔔 Play completion chime
  await _playCompletionChime();

  // 🔥 RESTORE REAL VOLUME FOR NEXT SESSION
  _volume = originalVolume;
  await _audioPlayer.setVolume(_volume);

  stopSessionTimer();
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
  if (_volume == 0) {
  _volume = 0.8; // default fallback
}
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

    // 🔥 CRITICAL FIX
    _lastPhaseIndex = -1;

    _resumeSessionTimer();
  }

  notifyListeners();
}

Future<void> stop() async {
  _isManuallyStopped = true;

  _sessionStartCancelled = true;

  await _audioPlayer.stop();
  await _effectPlayer.stop();

  _isPlaying = false;
  _currentPosition = Duration.zero;

  _sessionTotal = Duration.zero;
  _sessionRemaining = Duration.zero;

  _isPreparing = false;

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


  Future<void> _playCompletionChime() async {
  if (!isSoundEffectsEnabled) return;

  try {
    await _effectPlayer.stop();
    await _effectPlayer.setSource(
      AssetSource("audio/completion.mp3"),
    );
    await _effectPlayer.resume();
  } catch (e) {
    debugPrint("Completion chime error: $e");
  }
}

Future<void> playWelcomeMessage() async {
  if (!isSoundEffectsEnabled) return;

  try {
    await _effectPlayer.stop();

    // Use normal playback mode (not lowLatency)
    await _effectPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await _effectPlayer.setReleaseMode(ReleaseMode.release);

    final completer = Completer<void>();

    // Listen for completion once
    late StreamSubscription sub;
    sub = _effectPlayer.onPlayerComplete.listen((event) {
      completer.complete();
      sub.cancel();
    });

    await _effectPlayer.setSource(
      AssetSource("audio/welcome.mp3"),
    );

    await _effectPlayer.resume();

    // Wait until welcome actually finishes
    await completer.future;

  } catch (e) {
    debugPrint("Welcome message error: $e");
  }
}

Future<void> startMeditationWithWelcome({
  required String assetFile,
  required String title,
  required String category,
  required String imageUrl,
  required Duration duration,
}) async {
  try {
    _sessionStartCancelled = false;

    _isPreparing = true;
    _currentAudioUrl = assetFile;
    _currentSoundTitle = title;
    _currentSoundCategory = category;
    _currentSoundImageUrl = imageUrl;
    notifyListeners();

    await _audioPlayer.stop();
    await _effectPlayer.stop();

    await _effectPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await _effectPlayer.setReleaseMode(ReleaseMode.release);

    final completer = Completer<void>();

    late StreamSubscription sub;
    sub = _effectPlayer.onPlayerComplete.listen((event) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      sub.cancel();
    });

    await _effectPlayer.setSource(
      AssetSource("audio/welcome.mp3"),
    );

    await _effectPlayer.resume();

    await completer.future;

    if (_sessionStartCancelled) {
      _isPreparing = false;
      notifyListeners();
      return;
    }

    // 🔥 START MEDITATION FIRST
    await playSound(
      assetFile: assetFile,
      title: title,
      category: category,
      imageUrl: imageUrl,
    );

    startSessionTimer(duration);

    // 🔥 NOW turn off preparing
    _isPreparing = false;
    notifyListeners();

  } catch (e) {
    debugPrint("Start meditation with welcome error: $e");
  }
}

void cancelPendingSessionStart() {
  _sessionStartCancelled = true;
  _isPreparing = false;
  _effectPlayer.stop();
  notifyListeners();
}
}
