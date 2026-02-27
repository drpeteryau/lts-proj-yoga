import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import '../screens/meditation_session_screen.dart';
import '../screens/meditation_screen.dart';

class MiniPlaybackBar extends StatelessWidget {
  const MiniPlaybackBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = GlobalAudioService();

    return AnimatedBuilder(
      animation: audioService,
      builder: (context, _) {
        // Hide if nothing loaded
        if (!audioService.hasSound ||
            audioService.currentAudioUrl == null) {
          return const SizedBox.shrink();
        }

        // 🔥 USE SESSION TIMER INSTEAD OF AUDIO DURATION
        final total = audioService.sessionTotal;
        final remaining = audioService.sessionRemaining;

        final progress = total.inSeconds > 0
            ? (total.inSeconds - remaining.inSeconds) /
                total.inSeconds
            : 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MeditationSessionScreen(
                  session: MeditationSession(
                    title: audioService.currentSoundTitle ?? '',
                    description: '',
                    durationMinutes:
                        total.inMinutes > 0 ? total.inMinutes : 5,
                    imageUrl:
                        audioService.currentSoundImageUrl ?? '',
                    audioFile:
                        audioService.currentAudioUrl ?? '',
                    type: MeditationType.guided,
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 🔥 Progress bar synced to SESSION timer
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF40E0D0),
                  ),
                  minHeight: 3,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            audioService.currentSoundImageUrl ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                width: 48,
                                height: 48,
                                color: const Color(0xFF40E0D0)
                                    .withOpacity(0.2),
                                child: const Icon(
                                  Icons.self_improvement,
                                  color: Color(0xFF40E0D0),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Title + Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                audioService
                                        .currentSoundTitle ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                audioService
                                        .currentSoundCategory ??
                                    '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Play / Pause
                        IconButton(
                          icon: Icon(
                            audioService.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          color: const Color(0xFF40E0D0),
                          onPressed: () {
                            audioService.togglePlayPause();
                          },
                        ),

                        // Close
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.grey[600],
                          onPressed: () {
                            audioService.clearSound();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}