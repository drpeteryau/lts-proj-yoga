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
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 600 : double.infinity,
          ),
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _audioService,
              builder: (context, _) {
                final position =
                _audioService.currentPosition.inSeconds.toDouble();
                final duration =
                _audioService.totalDuration.inSeconds.toDouble();
                final sliderMax = duration > 0 ? duration : 1.0;
                final sliderValue = position.clamp(0.0, sliderMax);

                Duration remaining =
                    _audioService.totalDuration - _audioService.currentPosition;
                if (remaining.isNegative) remaining = Duration.zero;

                return isWeb
                    ? _buildWebLayout(sliderValue, sliderMax, duration, remaining)
                    : _buildMobileLayout(
                    context, size, sliderValue, sliderMax, duration, remaining);
              },
            ),
          ),
        ),
      ),
    );
  }

  // ─── Mobile layout ────────────────────────────────────────────────────────

  Widget _buildMobileLayout(
      BuildContext context,
      Size size,
      double sliderValue,
      double sliderMax,
      double duration,
      Duration remaining,
      ) {
    // Album art fills roughly 40% of screen height
    final artSize = size.height * 0.40;

    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "Now Playing",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 48), // balance the back button
            ],
          ),
        ),

        // Album art — takes 40% of screen height
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              _audioService.currentSoundImageUrl ?? '',
              height: artSize,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: artSize,
                color: Colors.grey[200],
                child: const Icon(Icons.music_note, size: 60),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Title + subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _audioService.currentSoundTitle ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Ambient Sound",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),

        const SizedBox(height: 16),

        // Slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              trackHeight: 3,
              activeTrackColor: const Color(0xFF40E0D0),
              inactiveTrackColor: Colors.grey[300],
              thumbColor: const Color(0xFF40E0D0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: sliderValue,
              min: 0,
              max: sliderMax,
              onChanged: (value) {
                if (duration > 0) {
                  _audioService.seek(Duration(seconds: value.toInt()));
                }
              },
            ),
          ),
        ),

        // Time labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _audioService.formatTime(_audioService.currentPosition),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                _audioService.totalDuration.inSeconds > 0
                    ? "-${_audioService.formatTime(remaining)}"
                    : "--:--",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Playback controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: _audioService.shuffle
                    ? const Color(0xFF40E0D0)
                    : Colors.grey,
                size: 26,
              ),
              onPressed: _audioService.toggleShuffle,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.skip_previous, size: 38),
              onPressed: _audioService.previousSound,
            ),
            const SizedBox(width: 8),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF40E0D0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 38,
                ),
                color: Colors.white,
                onPressed: _audioService.togglePlayPause,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.skip_next, size: 38),
              onPressed: _audioService.nextSound,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.repeat,
                color: _audioService.isRepeating
                    ? const Color(0xFF40E0D0)
                    : Colors.grey,
                size: 26,
              ),
              onPressed: _audioService.toggleRepeat,
            ),
          ],
        ),

        const Spacer(),

        // Stop button
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ElevatedButton(
            onPressed: () async {
              await _audioService.clearSound();
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF40E0D0),
              side: const BorderSide(color: Color(0xFF40E0D0)),
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Stop Sound",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Web layout (unchanged from original) ────────────────────────────────

  Widget _buildWebLayout(
      double sliderValue,
      double sliderMax,
      double duration,
      Duration remaining,
      ) {
    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Text(
                "Now Playing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const SizedBox(width: 40),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Album art
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: SizedBox(
            height: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                _audioService.currentSoundImageUrl ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.music_note, size: 50),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _audioService.currentSoundTitle ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 4),
        const Text(
          "Ambient Sound",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),

        const SizedBox(height: 16),

        // Slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: sliderMax,
            onChanged: (value) {
              if (duration > 0) {
                _audioService.seek(Duration(seconds: value.toInt()));
              }
            },
          ),
        ),

        // Time labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _audioService.formatTime(_audioService.currentPosition),
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                _audioService.totalDuration.inSeconds > 0
                    ? "-${_audioService.formatTime(remaining)}"
                    : "--:--",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: _audioService.shuffle
                    ? const Color(0xFF40E0D0)
                    : Colors.grey,
                size: 28,
              ),
              onPressed: _audioService.toggleShuffle,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.skip_previous, size: 36),
              onPressed: _audioService.previousSound,
            ),
            const SizedBox(width: 10),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF40E0D0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 36,
                ),
                color: Colors.white,
                onPressed: _audioService.togglePlayPause,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.skip_next, size: 36),
              onPressed: _audioService.nextSound,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.repeat,
                color: _audioService.isRepeating
                    ? const Color(0xFF40E0D0)
                    : Colors.grey,
                size: 28,
              ),
              onPressed: _audioService.toggleRepeat,
            ),
          ],
        ),

        const Spacer(),

        // Stop button
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () async {
              await _audioService.clearSound();
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text("Stop Sound", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}