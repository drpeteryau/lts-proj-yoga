import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import 'meditation_screen.dart';

class SoundPlayerScreen extends StatefulWidget {
  final List<MeditationSession> sounds;
  final int initialIndex;

  const SoundPlayerScreen({
    super.key,
    required this.sounds,
    required this.initialIndex,
  });

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen> {
  late GlobalAudioService _audioService;

MeditationSession? get currentSound {
  if (_audioService.playlist.isEmpty) return null;
  return _audioService.playlist[_audioService.currentIndex]
      as MeditationSession;
}

  @override
  void initState() {
    super.initState();

    _audioService = GlobalAudioService();

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _audioService,
          builder: (context, _) {

final position = _audioService.currentPosition.inSeconds.toDouble();
final duration = _audioService.totalDuration.inSeconds.toDouble();

final sliderMax = duration > 0 ? duration : 1.0;
final sliderValue = position.clamp(0.0, sliderMax);

            // ⭐ BONUS improvement: safe remaining time
Duration remaining =
    _audioService.totalDuration - _audioService.currentPosition;

if (remaining.isNegative) {
  remaining = Duration.zero;
}

            return Column(
              children: [

                /// Top Bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        "Now Playing",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Album Art
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
  _audioService.currentSoundImageUrl ?? '',
  fit: BoxFit.cover,
  errorBuilder: (_, __, ___) {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.music_note, size: 50),
    );
  },
),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Title
                Text(_audioService.currentSoundTitle ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Ambient Sound",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                /// Progress
Slider(
  value: sliderValue,
  min: 0,
  max: sliderMax,
  onChanged: (value) {
    if (duration > 0) {
      _audioService.seek(Duration(seconds: value.toInt()));
    }
  },
),

                /// Time
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_audioService.formatTime(_audioService.currentPosition)),
                      Text(
                        _audioService.totalDuration.inSeconds > 0
                            ? "-${_audioService.formatTime(remaining)}"
                            : "--:--",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                /// Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// Shuffle
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: _audioService.shuffle
                            ? const Color(0xFF40E0D0)
                            : Colors.grey,
                      ),
                      onPressed: () {

                        _audioService.toggleShuffle();
                      },
                    ),

                    const SizedBox(width: 10),

                    /// Previous
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 36),
                      onPressed: () {
  

                        _audioService.previousSound();
                      },
                    ),

                    const SizedBox(width: 10),

                    /// Play / Pause
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFF40E0D0),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _audioService.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 36,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          _audioService.togglePlayPause();
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Next
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 36),
                      onPressed: () {


                        _audioService.nextSound();
                      },
                    ),

                    const SizedBox(width: 10),

                    /// Repeat
                    IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: _audioService.isRepeating
                            ? const Color(0xFF40E0D0)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        _audioService.toggleRepeat();
                      },
                    ),
                  ],
                ),

                const Spacer(),

                /// Stop Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _audioService.clearSound();
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text("Stop Sound"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}