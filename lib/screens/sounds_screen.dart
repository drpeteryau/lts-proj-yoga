import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isFavorite;
  bool isSaved;

  MeditationSound({
    required this.title,
    required this.category,
    required this.duration,
    required this.imageUrl,
    this.isPopular = false,
    required this.audioUrl,
    this.isFavorite = false,
    this.isSaved = false,
  });
}

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({super.key});

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Using reliable, tested audio URLs
  final List<MeditationSound> sounds = [
    MeditationSound(
      title: 'Ocean Waves',
      category: 'Nature',
      duration: ' ',
      imageUrl: 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=500',
      isPopular: true,
      audioUrl: 'https://cdn.pixabay.com/audio/2022/05/27/audio_1808fbf07a.mp3',
    ),
    MeditationSound(
      title: 'Forest Rain',
      category: 'Nature',
      duration: '45 min',
      imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=500',
      isPopular: true,
      audioUrl: 'https://cdn.pixabay.com/audio/2021/08/09/audio_0625c1539c.mp3',
    ),
    MeditationSound(
      title: 'Tibetan Bowls',
      category: 'Meditation',
      duration: '20 min',
      imageUrl: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=500',
      isPopular: true,
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/15/audio_c8e7e1f2f7.mp3',
    ),
    MeditationSound(
      title: 'Peaceful Piano',
      category: 'Ambient',
      duration: '60 min',
      imageUrl: 'https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?w=500',
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/10/audio_c610232532.mp3',
    ),
    MeditationSound(
      title: 'Mountain Stream',
      category: 'Nature',
      duration: '40 min',
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500',
      audioUrl: 'https://cdn.pixabay.com/audio/2022/06/07/audio_1883c6fef8.mp3',
    ),
    MeditationSound(
      title: 'Wind Chimes',
      category: 'Ambient',
      duration: '25 min',
      imageUrl: 'https://images.unsplash.com/photo-1499244571948-7ccddb3583f1?w=500',
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/15/audio_134a5914f1.mp3',
    ),
    MeditationSound(
      title: 'Gentle Thunder',
      category: 'Nature',
      duration: '35 min',
      imageUrl: 'https://images.unsplash.com/photo-1502691876148-a84978e59af8?w=500',
      audioUrl: 'https://cdn.pixabay.com/audio/2022/11/09/audio_0c50c1f82e.mp3',
    ),
    MeditationSound(
      title: 'Singing Birds',
      category: 'Nature',
      duration: '30 min',
      imageUrl: 'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=500',
      audioUrl: 'https://cdn.pixabay.com/audio/2022/03/09/audio_c610232532.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MeditationSound> get _allSounds => sounds;
  List<MeditationSound> get _recentSounds => sounds.take(4).toList();
  List<MeditationSound> get _savedSounds => sounds.where((s) => s.isSaved).toList();
  List<MeditationSound> get _favoriteSounds => sounds.where((s) => s.isFavorite).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Tab bar
            _buildTabBar(),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllTab(),
                  _buildRecentTab(),
                  _buildSavedTab(),
                  _buildFavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Find Your Peace',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            color: Color(0xFF40E0D0),
            width: 3,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Recent'),
          Tab(text: 'Saved'),
          Tab(text: 'Favorites'),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    final popularSounds = sounds.where((s) => s.isPopular).toList();
    final otherSounds = sounds.where((s) => !s.isPopular).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Most Popular Section
          Text(
            'Most Popular',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
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
                return _buildSoundCard(popularSounds[index], width: 160);
              },
            ),
          ),

          const SizedBox(height: 32),

          // Latest Section
          Text(
            'Latest',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
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
            itemCount: otherSounds.length,
            itemBuilder: (context, index) {
              return _buildSoundCard(otherSounds[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return _buildSoundsList(_recentSounds, emptyMessage: 'No recent sounds');
  }

  Widget _buildSavedTab() {
    return _buildSoundsList(_savedSounds, emptyMessage: 'No saved sounds yet');
  }

  Widget _buildFavoritesTab() {
    return _buildSoundsList(_favoriteSounds, emptyMessage: 'No favorite sounds yet');
  }

  Widget _buildSoundsList(List<MeditationSound> soundsList, {required String emptyMessage}) {
    if (soundsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: soundsList.length,
      itemBuilder: (context, index) {
        return _buildSoundCard(soundsList[index]);
      },
    );
  }

  Widget _buildSoundCard(MeditationSound sound, {double? width}) {
    return GestureDetector(
      onTap: () => _playSound(sound),
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
                    // Play button and favorite icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sound.isFavorite = !sound.isFavorite;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              sound.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: sound.isFavorite ? Colors.red : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Title
                    Text(
                      sound.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Duration and save button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sound.isSaved = !sound.isSaved;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  sound.isSaved ? 'Saved!' : 'Removed from saved',
                                  style: GoogleFonts.poppins(),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFF40E0D0),
                              ),
                            );
                          },
                          child: Icon(
                            sound.isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: Colors.white,
                            size: 20,
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

  Future<void> _playSound(MeditationSound sound) async {
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
      if (mounted) Navigator.pop(context);

      print('🎵 Successfully loaded audio for ${sound.title}');

      // Navigate to sound player screen
      if (mounted) {
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
      if (mounted) Navigator.pop(context);

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load audio. Please try another one.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}