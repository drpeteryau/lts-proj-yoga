import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import 'sounds_screen.dart';
import '../services/global_audio_service.dart';

class SoundPlayerScreen extends StatefulWidget {
  final MeditationSound sound;

  const SoundPlayerScreen({super.key, required this.sound});

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen> {
  late GlobalAudioService _audioService;
  bool _isFavorite = false;
  bool _isShuffling = false;

  @override
  void initState() {
    super.initState();
    _audioService = GlobalAudioService();

    // If this sound isn't already playing, play it
    if (_audioService.currentSoundTitle != widget.sound.title) {
      _audioService.playSound(
        url: widget.sound.audioUrl,
        title: widget.sound.title,
        category: widget.sound.category,
        imageUrl: widget.sound.imageUrl,
      );
    }
  }

  void _skipForward() async {
    final newPosition = _audioService.currentPosition + const Duration(seconds: 15);
    if (newPosition < _audioService.totalDuration) {
      await _audioService.seek(newPosition);
    }
  }

  void _skipBackward() async {
    final newPosition = _audioService.currentPosition - const Duration(seconds: 15);
    if (newPosition > Duration.zero) {
      await _audioService.seek(newPosition);
    } else {
      await _audioService.seek(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _audioService,
          builder: (context, child) {
            return Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                          Navigator.pop(context);
                        },
                        color: Colors.black87,
                      ),
                      const Text(
                        'Now Playing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 28),
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                        },
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Album Art
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          widget.sound.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF40E0D0).withOpacity(0.2),
                              child: const Icon(
                                Icons.music_note,
                                size: 100,
                                color: Color(0xFF40E0D0),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Song Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.sound.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.sound.category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 32,
                              color: _isFavorite
                                  ? const Color(0xFFFFB5C2)
                                  : Colors.grey[400],
                            ),
                            onPressed: () async {
                              await GlobalAudioService.playClickSound();
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Progress slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                          activeTrackColor: const Color(0xFF40E0D0),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: const Color(0xFF40E0D0),
                          overlayColor: const Color(0xFF40E0D0).withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _audioService.currentPosition.inSeconds.toDouble(),
                          min: 0,
                          max: _audioService.totalDuration.inSeconds.toDouble() > 0
                              ? _audioService.totalDuration.inSeconds.toDouble()
                              : 1.0,
                          onChanged: (value) {
                            _audioService.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _audioService.formatTime(_audioService.currentPosition),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _audioService.formatTime(_audioService.totalDuration),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          size: 28,
                          color: _isShuffling
                              ? const Color(0xFF40E0D0)
                              : Colors.grey[400],
                        ),
                        onPressed: () async{
                          await GlobalAudioService.playClickSound();
                          setState(() {
                            _isShuffling = !_isShuffling;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 44),
                        color: Colors.black87,
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                          _skipBackward();
                        },
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB5C2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB5C2).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 44,
                          ),
                          color: Colors.white,
                          onPressed: () async{
                            await GlobalAudioService.playClickSound();
                            _audioService.togglePlayPause();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 44),
                        color: Colors.black87,
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                          _skipForward();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.repeat,
                          size: 28,
                          color: _audioService.isRepeating
                              ? const Color(0xFF40E0D0)
                              : Colors.grey[400],
                        ),
                        onPressed: () async {
                          await GlobalAudioService.playClickSound();
                          _audioService.toggleRepeat();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // More Details Button
                TextButton(
                  onPressed: () async {
                    await GlobalAudioService.playClickSound();
                    _showDetailsSheet(context);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFF40E0D0),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'More details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF40E0D0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'About This Sound',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.category, 'Category', widget.sound.category),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.access_time, 'Duration', widget.sound.duration),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.info_outline, 'Type', 'Meditation & Relaxation'),
              const SizedBox(height: 24),
              const Text(
                'Benefits',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '• Reduces stress and anxiety\n'
                    '• Improves focus and concentration\n'
                    '• Promotes better sleep\n'
                    '• Enhances overall well-being',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF40E0D0), size: 24),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}