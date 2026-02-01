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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 800 : double.infinity,
            ),
            child: AnimatedBuilder(
              animation: _audioService,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 0),
                  child: Column(
                    children: [
                      // Top Bar
                      Padding(
                        padding: EdgeInsets.all(isWeb ? 24 : 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: isWeb ? 36 : 32,
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.black87,
                            ),
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                fontSize: isWeb ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                size: isWeb ? 32 : 28,
                              ),
                              onPressed: () {},
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isWeb ? 40 : 20),

                      // Album Art
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 80 : 40,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: isWeb ? 500 : double.infinity,
                              maxHeight: isWeb ? 500 : double.infinity,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(isWeb ? 40 : 30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: isWeb ? 30 : 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(isWeb ? 40 : 30),
                              child: Image.network(
                                widget.sound.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFF40E0D0).withOpacity(0.2),
                                    child: Icon(
                                      Icons.music_note,
                                      size: isWeb ? 120 : 100,
                                      color: const Color(0xFF40E0D0),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 60 : 40,
                        ),
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
                                        style: TextStyle(
                                          fontSize: isWeb ? 32 : 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: isWeb ? 10 : 6),
                                      Text(
                                        widget.sound.category,
                                        style: TextStyle(
                                          fontSize: isWeb ? 20 : 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: isWeb ? 40 : 32,
                                    color: _isFavorite
                                        ? const Color(0xFFFFB5C2)
                                        : Colors.grey[400],
                                  ),
                                  onPressed: () {
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

                      SizedBox(height: isWeb ? 48 : 32),

                      // Progress slider
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 48 : 32,
                        ),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: isWeb ? 4 : 3,
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: isWeb ? 10 : 8,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: isWeb ? 20 : 16,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: isWeb ? 12 : 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _audioService.formatTime(_audioService.currentPosition),
                                    style: TextStyle(
                                      fontSize: isWeb ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    _audioService.formatTime(_audioService.totalDuration),
                                    style: TextStyle(
                                      fontSize: isWeb ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isWeb ? 48 : 32),

                      // Playback Controls
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWeb ? 60 : 40,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                size: isWeb ? 32 : 28,
                                color: _isShuffling
                                    ? const Color(0xFF40E0D0)
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isShuffling = !_isShuffling;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                size: isWeb ? 52 : 44,
                              ),
                              color: Colors.black87,
                              onPressed: _skipBackward,
                            ),
                            Container(
                              width: isWeb ? 100 : 80,
                              height: isWeb ? 100 : 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5C2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFB5C2).withOpacity(0.4),
                                    blurRadius: isWeb ? 30 : 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _audioService.isPlaying ? Icons.pause : Icons.play_arrow,
                                  size: isWeb ? 52 : 44,
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  _audioService.togglePlayPause();
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.skip_next,
                                size: isWeb ? 52 : 44,
                              ),
                              color: Colors.black87,
                              onPressed: _skipForward,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.repeat,
                                size: isWeb ? 32 : 28,
                                color: _audioService.isRepeating
                                    ? const Color(0xFF40E0D0)
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                _audioService.toggleRepeat();
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isWeb ? 48 : 32),

                      // More Details Button
                      TextButton(
                        onPressed: () {
                          _showDetailsSheet(context, isWeb);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: const Color(0xFF40E0D0),
                              size: isWeb ? 24 : 20,
                            ),
                            SizedBox(width: isWeb ? 6 : 4),
                            Text(
                              'More details',
                              style: TextStyle(
                                fontSize: isWeb ? 18 : 16,
                                color: const Color(0xFF40E0D0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isWeb ? 48 : 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context, bool isWeb) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isWeb ? 40 : 30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(isWeb ? 32 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: isWeb ? 50 : 40,
                  height: isWeb ? 5 : 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: isWeb ? 32 : 24),
              Text(
                'About This Sound',
                style: TextStyle(
                  fontSize: isWeb ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWeb ? 24 : 16),
              _buildDetailRow(
                Icons.category,
                'Category',
                widget.sound.category,
                isWeb,
              ),
              SizedBox(height: isWeb ? 16 : 12),
              _buildDetailRow(
                Icons.access_time,
                'Duration',
                widget.sound.duration,
                isWeb,
              ),
              SizedBox(height: isWeb ? 16 : 12),
              _buildDetailRow(
                Icons.info_outline,
                'Type',
                'Meditation & Relaxation',
                isWeb,
              ),
              SizedBox(height: isWeb ? 32 : 24),
              Text(
                'Benefits',
                style: TextStyle(
                  fontSize: isWeb ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWeb ? 16 : 12),
              Text(
                '• Reduces stress and anxiety\n'
                    '• Improves focus and concentration\n'
                    '• Promotes better sleep\n'
                    '• Enhances overall well-being',
                style: TextStyle(
                  fontSize: isWeb ? 18 : 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWeb ? 32 : 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isWeb) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF40E0D0),
          size: isWeb ? 28 : 24,
        ),
        SizedBox(width: isWeb ? 16 : 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isWeb ? 18 : 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isWeb ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}