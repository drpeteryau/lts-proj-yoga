import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meditation_session_screen.dart';
import '../services/global_audio_service.dart';

enum MeditationType { guided, breathing, silent, sound }

class MeditationSession {
  final String title;
  final String description;
  final int durationMinutes;
  final String imageUrl;
  final String audioFile;
  final MeditationType type;
  final bool isLooping; // For ambient sounds
  bool isFavorite;

  MeditationSession({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    required this.audioFile,
    required this.type,
    this.isLooping = false,
    this.isFavorite = false,
  });
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  // Guided meditations (with breathing instructions)
  final List<MeditationSession> sessions = [
    MeditationSession(
      title: "Morning Clarity",
      description: "Start your day with calm intention",
      durationMinutes: 10,
      imageUrl:
      "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
      audioFile: "morning.mp3",
      type: MeditationType.guided,
    ),
    MeditationSession(
      title: "Deep Breathing",
      description: "Reduce stress with focused breath",
      durationMinutes: 5,
      imageUrl:
      "https://images.unsplash.com/photo-1511497584788-876760111969?w=800",
      audioFile: "deepbreathing.mp3",
      type: MeditationType.breathing,
    ),
    MeditationSession(
      title: "Evening Wind Down",
      description: "Release the day and prepare for rest",
      durationMinutes: 15,
      imageUrl:
      "https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800",
      audioFile: "evening.mp3",
      type: MeditationType.guided,
    ),
  ];

  // Real ambient sounds (looping audio files from free sources)
  final List<MeditationSession> sounds = [
    MeditationSession(
      title: "Ocean Waves",
      description: "Gentle waves on the shore",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800",
      // Ocean waves - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c1c0c7a4d6.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Rain Sounds",
      description: "Soft rain and thunder",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=800",
      // Rain sounds - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2021/08/04/audio_12b0c7a7d3.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Forest Birds",
      description: "Birds chirping in nature",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1511497584788-876760111969?w=800",
      // Forest ambience - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Crackling Fire",
      description: "Warm fireplace sounds",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1518098268026-4e89f1a2cd8e?w=800",
      // Fireplace crackling - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/03/15/audio_4c0f6a4b82.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "White Noise",
      description: "Pure white noise for focus",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800",
      // White noise - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/10/13/audio_2f2e3b3d4e.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Flowing Water",
      description: "Gentle stream sounds",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800",
      // Stream water - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/06/07/audio_0c0e7c1f3d.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Wind Chimes",
      description: "Peaceful wind chimes",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      // Wind chimes - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2023/02/28/audio_5f3c9a2e1b.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      title: "Night Crickets",
      description: "Evening cricket sounds",
      durationMinutes: 60,
      imageUrl:
      "https://images.unsplash.com/photo-1475274047050-1d0c0975c63e?w=800",
      // Cricket sounds - Pixabay free audio
      audioFile: "https://cdn.pixabay.com/download/audio/2022/06/08/audio_7e5c9b8f2a.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0), // Light turquoise
              Color(0xFFFFFFFF), // White
              Color(0xFFE8F9F3), // Light mint
              Color(0xFFFFE9DB), // Light peach
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 14),
                    _buildQuickStartCard(),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Guided Meditations"),
                    const SizedBox(height: 16),
                    ...sessions.map((session) => _buildMeditationCard(session)).toList(),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Ambient Sounds"),
                    const SizedBox(height: 8),
                    Text(
                      "Real nature sounds to help you relax",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSoundsGrid(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meditation & Sounds",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildQuickStartCard() {
    final quickSession = sessions.first;

    return GestureDetector(
      onTap: () => _startSession(quickSession),
      child: Container(
        height: 180,
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
              Image.network(
                quickSession.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF40E0D0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Quick Start",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      quickSession.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${quickSession.durationMinutes} min • ${quickSession.description}",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
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

  Widget _buildMeditationCard(MeditationSession session) {
    return GestureDetector(
      onTap: () => _startSession(session),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                session.imageUrl,
                width: 120,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      session.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      session.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: const Color(0xFF40E0D0),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${session.durationMinutes} min",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF40E0D0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Play icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF40E0D0).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Color(0xFF40E0D0),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        return _buildSoundCard(sound);
      },
    );
  }

  Widget _buildSoundCard(MeditationSession sound) {
    return GestureDetector(
      onTap: () => _startSession(sound),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      sound.imageUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    // Volume icon overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          color: Color(0xFF40E0D0),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sound.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sound.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startSession(MeditationSession session) {
    if (MeditationSessionScreen.isActive) return;

    final audioService = GlobalAudioService();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MeditationSessionScreen(session: session),
      ),
    );

    if (audioService.sessionRemaining == Duration.zero) {
      if (session.type == MeditationType.sound) {
        // For ambient sounds, play looping audio
        audioService.startAmbientSound(
          audioUrl: session.audioFile,
          title: session.title,
          imageUrl: session.imageUrl,
          duration: Duration(minutes: session.durationMinutes),
          isLooping: session.isLooping,
        );
      } else {
        // For meditations, use guided session
        audioService.startMeditationWithWelcome(
          assetFile: session.audioFile,
          title: session.title,
          category: "Meditation",
          imageUrl: session.imageUrl,
          duration: Duration(minutes: session.durationMinutes),
        );
      }
    }
  }
}