import 'package:audioplayers/audioplayers.dart';

class GlobalAudioService {
  static final AudioPlayer player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);  // White noise keeps looping
  static final GlobalAudioService _instance = GlobalAudioService._internal();
  factory GlobalAudioService() => _instance;
  GlobalAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentSoundTitle;
  double _volume = 0.8;

  bool get isPlaying => _isPlaying;
  String? get currentSoundTitle => _currentSoundTitle;
  double get volume => _volume;

  Future<void> initialize() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      // Auto-loop the sound
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    });
  }

  Future<void> playSoundUrl(String url, String title) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.resume();
      _currentSoundTitle = title;
      _isPlaying = true;
    } catch (e) {
      print('Error playing sound: $e');
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
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentSoundTitle = null;
  }

  Future<void> setVolume(double volume) async {
    _volume = volume;
    await _audioPlayer.setVolume(volume);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
