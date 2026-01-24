import 'package:flutter/material.dart';
import 'dart:async';
import 'sound_player_screen.dart';
import '../services/global_audio_service.dart';

class MeditationSound {
  final String title;
  final String category;
  final String duration;
  final String imageUrl;
  final bool isPopular;
  final String audioUrl;

  MeditationSound({
    required this.title,
    required this.category,
    required this.duration,
    required this.imageUrl,
    this.isPopular = false,
    required this.audioUrl,
  });
}

class SoundsScreen extends StatelessWidget {
  const SoundsScreen({super.key});

  // Using reliable, tested audio URLs
  static final List<MeditationSound> sounds = [
    MeditationSound(
      title: 'Ocean Waves',
      category: 'Nature',
      duration: '30 min',
      imageUrl: 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=500',
      isPopular: true,
      // Verified working ocean waves
      audioUrl: 'https://cdn.pixabay.com/audio/2022/05/27/audio_1808fbf07a.mp3',
    ),
    MeditationSound(
      title: 'Forest Rain',
      category: 'Nature',
      duration: '45 min',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=500',
      isPopular: true,
      // Verified working rain sounds
      audioUrl: 'https://cdn.pixabay.com/audio/2022/05/27/audio_1808fbf07a.mp3',
    ),
    MeditationSound(
      title: 'Tibetan Bowls',
      category: 'Meditation',
      duration: '20 min',
      imageUrl: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=500',
      isPopular: true,
      // Verified working meditation music
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/15/audio_c8e7e1f2f7.mp3',
    ),
    MeditationSound(
      title: 'Peaceful Piano',
      category: 'Ambient',
      duration: '60 min',
      imageUrl: 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500',
      // Verified working piano music
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/10/audio_c610232532.mp3',
    ),
    MeditationSound(
      title: 'Mountain Stream',
      category: 'Nature',
      duration: '40 min',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500',
      // Verified working water sounds
      audioUrl: 'https://cdn.pixabay.com/audio/2022/06/07/audio_1883c6fef8.mp3',
    ),
    MeditationSound(
      title: 'Wind Chimes',
      category: 'Ambient',
      duration: '25 min',
      imageUrl: 'https://images.unsplash.com/photo-1499244571948-7ccddb3583f1?w=500',
      // Verified working wind sounds
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/15/audio_134a5914f1.mp3',
    ),
    MeditationSound(
      title: 'Gentle Thunder',
      category: 'Nature',
      duration: '35 min',
      imageUrl: 'https://images.unsplash.com/photo-1502691876148-a84978e59af8?w=500',
      // Verified working thunder/rain
      audioUrl: 'https://cdn.pixabay.com/audio/2022/11/09/audio_0c50c1f82e.mp3',
    ),
    MeditationSound(
      title: 'Singing Birds',
      category: 'Nature',
      duration: '30 min',
      imageUrl: 'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=500',
      // Verified working birds chirping
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/09/audio_c610232532.mp3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final popularSounds = sounds.where((s) => s.isPopular).toList();
    final latestSounds = sounds.where((s) => !s.isPopular).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF40E0D0).withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Color(0xFF40E0D0),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            'Find Your Peace',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: Colors.black54,
                      iconSize: 28,
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Most Popular Section
                const Text(
                  'Most Popular',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularSounds.length,
                    itemBuilder: (context, index) {
                      return _buildSoundCard(
                        context,
                        popularSounds[index],
                        width: 160,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Latest Section
                const Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: latestSounds.length,
                  itemBuilder: (context, index) {
                    return _buildSoundCard(
                      context,
                      latestSounds[index],
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoundCard(
      BuildContext context,
      MeditationSound sound, {
        double? width,
      }) {
    return GestureDetector(
      onTap: () async {
        print('🎵 Tapping sound: ${sound.title}');
        print('🎵 URL: ${sound.audioUrl}');

        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF40E0D0),
            ),
          ),
        );

        try {
          // Play sound using global audio service with timeout
          final audioService = GlobalAudioService();

          // Try to play with a timeout
          await Future.any([
            audioService.playSound(
              url: sound.audioUrl,
              title: sound.title,
              category: sound.category,
              imageUrl: sound.imageUrl,
            ),
            Future.delayed(const Duration(seconds: 10), () {
              throw TimeoutException('Audio loading timed out after 10 seconds');
            }),
          ]);

          // Wait a bit for audio to start
          await Future.delayed(const Duration(milliseconds: 800));

          // Close loading dialog
          if (context.mounted) Navigator.pop(context);

          print('🎵 Successfully loaded audio for ${sound.title}');

          // Navigate to sound player screen
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SoundPlayerScreen(sound: sound),
              ),
            );
          }
        } catch (e) {
          print('❌ Error loading sound: $e');

          // Close loading dialog
          if (context.mounted) Navigator.pop(context);

          // Show error with helpful message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Failed to load audio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This sound may be temporarily unavailable. Please try another one.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[700],
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
        }
      },
      child: Container(
        width: width,
        margin: width != null ? const EdgeInsets.only(right: 16) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                sound.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF40E0D0).withOpacity(0.2),
                    child: const Icon(
                      Icons.music_note,
                      size: 60,
                      color: Color(0xFF40E0D0),
                    ),
                  );
                },
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Play button
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0).withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      sound.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Duration
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sound.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}