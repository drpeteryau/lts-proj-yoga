import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';
import '../services/global_audio_service.dart';


enum MeditationType { guided, breathing, silent }

class MeditationSession {
  final String title;
  final String description;
  final int durationMinutes;
  final String imageUrl;
  final String audioFile;
  final MeditationType type;
  bool isFavorite;

  MeditationSession({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    required this.audioFile,
    required this.type,
    this.isFavorite = false,
  });
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final List<MeditationSession> sessions = [
    MeditationSession(
      title: "Morning Clarity",
      description: "Start your day with calm intention",
      durationMinutes: 10,
      imageUrl:
          "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
      audioFile:
          "morning.mp3",
      type: MeditationType.guided,
    ),
    MeditationSession(
      title: "Deep Breathing",
      description: "Reduce stress with focused breath",
      durationMinutes: 5,
      imageUrl:
          "https://images.unsplash.com/photo-1511497584788-876760111969?w=800",
      audioFile:
          "deepbreathing.mp3",
      type: MeditationType.breathing,
    ),
    MeditationSession(
      title: "Evening Wind Down",
      description: "Release the day and prepare for rest",
      durationMinutes: 15,
      imageUrl:
          "https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800",
      audioFile:
          "evening.mp3",
      type: MeditationType.guided,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildQuickStartCard(),
                    const SizedBox(height: 30),
                    const Text(
                      "All Meditations",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...sessions
                        .map((session) => _buildSessionCard(session))
                        .toList(),
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
    return Row(
      children: const [
        Icon(Icons.self_improvement, size: 32, color: Colors.teal),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pause & Breathe",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Choose Your Meditation",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
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
          image: DecorationImage(
            image: NetworkImage(quickSession.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Quick Start • 5-10 min",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(MeditationSession session) {
    return GestureDetector(
      onTap: () => _startSession(session),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(session.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                session.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                session.description,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                "${session.durationMinutes} min",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _startSession(MeditationSession session) async {
  final audioService = GlobalAudioService();

  await audioService.playSound(
    assetFile: session.audioFile,
    title: session.title,
    category: "Meditation",
    imageUrl: session.imageUrl,
  );

  audioService.startSessionTimer(
    Duration(minutes: session.durationMinutes),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MeditationSessionScreen(session: session),
    ),
  );
}
}