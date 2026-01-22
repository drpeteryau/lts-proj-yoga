import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import '../screens/sound_player_screen.dart';
import '../screens/sounds_screen.dart';

class MiniPlaybackBar extends StatelessWidget {
  const MiniPlaybackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GlobalAudioService(),
      builder: (context, child) {
        final audioService = GlobalAudioService();

        // Don't show the bar if there's no sound playing
        if (!audioService.hasSound) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            // Open the full sound player screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SoundPlayerScreen(
                  sound: MeditationSound(
                    title: audioService.currentSoundTitle ?? '',
                    category: audioService.currentSoundCategory ?? '',
                    duration: audioService.formatTime(audioService.totalDuration),
                    imageUrl: audioService.currentSoundImageUrl ?? '',
                    audioUrl: audioService.currentAudioUrl ?? '',
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: audioService.totalDuration.inSeconds > 0
                      ? audioService.currentPosition.inSeconds /
                      audioService.totalDuration.inSeconds
                      : 0.0,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF40E0D0),
                  ),
                  minHeight: 2,
                ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Album art thumbnail
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              audioService.currentSoundImageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF40E0D0).withOpacity(0.2),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Color(0xFF40E0D0),
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Song info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                audioService.currentSoundTitle ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                audioService.currentSoundCategory ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Play/Pause button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF40E0D0),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              audioService.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 24,
                            ),
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              audioService.togglePlayPause();
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Close button
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: Colors.grey[600],
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
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