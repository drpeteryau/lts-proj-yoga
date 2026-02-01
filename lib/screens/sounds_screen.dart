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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 1200 : double.infinity,
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(isWeb),

                // Tab bar
                _buildTabBar(isWeb),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllTab(isWeb),
                      _buildRecentTab(isWeb),
                      _buildSavedTab(isWeb),
                      _buildFavoritesTab(isWeb),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWeb) {
    return Padding(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isWeb ? 12 : 8),
            decoration: BoxDecoration(
              color: const Color(0xFF40E0D0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
            ),
            child: Icon(
              Icons.music_note,
              color: const Color(0xFF40E0D0),
              size: isWeb ? 36 : 28,
            ),
          ),
          SizedBox(width: isWeb ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                    fontSize: isWeb ? 16 : 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Find Your Peace',
                  style: GoogleFonts.poppins(
                    fontSize: isWeb ? 28 : 22,
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
            iconSize: isWeb ? 32 : 28,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isWeb) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 20),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.black87,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.poppins(
          fontSize: isWeb ? 17 : 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: isWeb ? 17 : 15,
          fontWeight: FontWeight.w400,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            color: Color(0xFF40E0D0),
            width: 3,
          ),
          insets: EdgeInsets.symmetric(horizontal: isWeb ? 20 : 16),
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

  Widget _buildAllTab(bool isWeb) {
    final popularSounds = sounds.where((s) => s.isPopular).toList();
    final otherSounds = sounds.where((s) => !s.isPopular).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Most Popular Section
          Text(
            'Most Popular',
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWeb ? 20 : 16),
          _buildSoundsGrid(popularSounds, isWeb),

          SizedBox(height: isWeb ? 40 : 30),

          // Latest Section
          Text(
            'Latest',
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWeb ? 20 : 16),
          _buildLatestSoundsList(otherSounds, isWeb),
        ],
      ),
    );
  }

  Widget _buildRecentTab(bool isWeb) {
    return Padding(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      child: _recentSounds.isEmpty
          ? _buildEmptyState('No recent sounds', isWeb)
          : _buildSoundsGrid(_recentSounds, isWeb),
    );
  }

  Widget _buildSavedTab(bool isWeb) {
    return Padding(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      child: _savedSounds.isEmpty
          ? _buildEmptyState('No saved sounds yet', isWeb)
          : _buildSoundsGrid(_savedSounds, isWeb),
    );
  }

  Widget _buildFavoritesTab(bool isWeb) {
    return Padding(
      padding: EdgeInsets.all(isWeb ? 32 : 20),
      child: _favoriteSounds.isEmpty
          ? _buildEmptyState('No favorite sounds yet', isWeb)
          : _buildSoundsGrid(_favoriteSounds, isWeb),
    );
  }

  Widget _buildEmptyState(String message, bool isWeb) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: isWeb ? 80 : 60,
            color: Colors.grey[300],
          ),
          SizedBox(height: isWeb ? 20 : 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 18 : 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestSoundsList(List<MeditationSound> soundsList, bool isWeb) {
    // For web, show larger cards in a 2-column grid
    if (isWeb) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.5,
        ),
        itemCount: soundsList.length,
        itemBuilder: (context, index) {
          return _buildLargeHorizontalCard(soundsList[index], isWeb);
        },
      );
    }

    // Mobile view - horizontal scroll
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: soundsList.length,
        itemBuilder: (context, index) {
          return _buildLargeHorizontalCard(soundsList[index], isWeb);
        },
      ),
    );
  }

  Widget _buildLargeHorizontalCard(MeditationSound sound, bool isWeb) {
    return GestureDetector(
      onTap: () => _playSound(sound),
      child: Container(
        width: isWeb ? null : 350,
        margin: isWeb ? null : const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                sound.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF40E0D0).withOpacity(0.2),
                    child: Icon(
                      Icons.music_note,
                      size: isWeb ? 80 : 60,
                      color: const Color(0xFF40E0D0),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isWeb ? 24 : 20),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isWeb ? 16 : 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0).withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: isWeb ? 32 : 28,
                      ),
                    ),
                    SizedBox(width: isWeb ? 20 : 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sound.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: isWeb ? 20 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sound.category,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: isWeb ? 15 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sound.isFavorite = !sound.isFavorite;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(isWeb ? 10 : 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          sound.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: sound.isFavorite ? Colors.red : Colors.white,
                          size: isWeb ? 24 : 20,
                        ),
                      ),
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

  Widget _buildSoundsGrid(List<MeditationSound> soundsList, bool isWeb) {
    // Determine cross axis count based on screen width
    final crossAxisCount = isWeb ? 4 : 2;
    final childAspectRatio = isWeb ? 0.75 : 0.85;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isWeb ? 20 : 12,
        mainAxisSpacing: isWeb ? 20 : 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: soundsList.length,
      itemBuilder: (context, index) {
        return _buildSoundCard(soundsList[index], isWeb);
      },
    );
  }

  Widget _buildSoundCard(MeditationSound sound, bool isWeb) {
    return GestureDetector(
      onTap: () => _playSound(sound),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
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
                    child: Icon(
                      Icons.music_note,
                      size: isWeb ? 80 : 60,
                      color: const Color(0xFF40E0D0),
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
                padding: EdgeInsets.all(isWeb ? 20 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Play button and favorite icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isWeb ? 12 : 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF40E0D0).withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: isWeb ? 28 : 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await GlobalAudioService.playClickSound();
                            setState(() {
                              sound.isFavorite = !sound.isFavorite;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(isWeb ? 8 : 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              sound.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: sound.isFavorite ? Colors.red : Colors.white,
                              size: isWeb ? 22 : 20,
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
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isWeb ? 8 : 4),

                    // Duration and save button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: isWeb ? 18 : 16,
                            ),
                            SizedBox(width: isWeb ? 6 : 4),
                            Text(
                              sound.duration,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: isWeb ? 15 : 14,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            await GlobalAudioService.playClickSound();
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
                            size: isWeb ? 22 : 20,
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