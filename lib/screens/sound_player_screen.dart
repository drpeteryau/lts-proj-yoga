import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sounds_screen.dart';

class SoundPlayerScreen extends StatefulWidget {
  final MeditationSound sound;

  const SoundPlayerScreen({super.key, required this.sound});

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isFavorite = false;
  bool _isShuffling = false;
  bool _isRepeating = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  void _initAudio() {
    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    // Listen to completion
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
        if (_isRepeating) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.resume();
        }
      }
    });

    // Load a sample audio file (you can replace with actual meditation sound URLs)
    _loadAudio();
  }

  void _loadAudio() async {
    try {
      // Using a free meditation sound from the internet
      // You can replace these with your own hosted meditation sounds
      String audioUrl = _getAudioUrlForSound(widget.sound.title);
      await _audioPlayer.setSourceUrl(audioUrl);
    } catch (e) {
      print('Error loading audio: $e');
      // Fallback: show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to load audio. Please check your internet connection.'),
          ),
        );
      }
    }
  }

  String _getAudioUrlForSound(String title) {
    // Map sound titles to actual audio URLs
    // These are sample URLs - replace with your actual meditation sound files
    Map<String, String> audioUrls = {
      'Ocean Waves': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'Forest Rain': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'Tibetan Bowls': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'Peaceful Piano': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'Mountain Stream': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      'Wind Chimes': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      'Gentle Thunder': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      'Singing Birds': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    };

    return audioUrls[title] ?? audioUrls['Ocean Waves']!;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _skipForward() async {
    final newPosition = _currentPosition + const Duration(seconds: 15);
    if (newPosition < _totalDuration) {
      await _audioPlayer.seek(newPosition);
    }
  }

  void _skipBackward() async {
    final newPosition = _currentPosition - const Duration(seconds: 15);
    if (newPosition > Duration.zero) {
      await _audioPlayer.seek(newPosition);
    } else {
      await _audioPlayer.seek(Duration.zero);
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () {},
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
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
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
                        ),
                        color: _isFavorite
                            ? const Color(0xFFFFB5C2)
                            : Colors.grey[400],
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

            const SizedBox(height: 32),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: const Color(0xFF40E0D0),
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      thumbColor: const Color(0xFF40E0D0),
                      overlayColor: const Color(0xFF40E0D0).withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      min: 0,
                      max: _totalDuration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(_currentPosition),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatTime(_totalDuration),
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
                    onPressed: () {
                      setState(() {
                        _isShuffling = !_isShuffling;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 44),
                    color: Colors.black87,
                    onPressed: _skipBackward,
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
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 44,
                      ),
                      color: Colors.white,
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 44),
                    color: Colors.black87,
                    onPressed: _skipForward,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.repeat,
                      size: 28,
                      color: _isRepeating
                          ? const Color(0xFF40E0D0)
                          : Colors.grey[400],
                    ),
                    onPressed: () {
                      setState(() {
                        _isRepeating = !_isRepeating;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // More Details Button
            TextButton(
              onPressed: () {
                _showDetailsSheet(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_up,
                    color: Color(0xFF40E0D0),
                  ),
                  const SizedBox(width: 4),
                  const Text(
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
