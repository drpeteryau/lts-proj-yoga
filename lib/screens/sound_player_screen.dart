import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import 'sounds_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/sound_localization_helper.dart';

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
  bool _hasStartedPlayback = false;

  @override
  void initState() {
    super.initState();
    _audioService = GlobalAudioService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only run once
    if (!_hasStartedPlayback) {
      _hasStartedPlayback = true;

      final translatedTitle = SoundLocalizationHelper.getSoundTitle(context, widget.sound.titleKey);
      final translatedCategory =
          SoundLocalizationHelper.getSoundCategory(context, widget.sound.categoryKey);

      // If this sound isn't already playing, play it
      if (_audioService.currentSoundTitle != translatedTitle) {
        _audioService.playSound(
          url: widget.sound.audioUrl,
          title: translatedTitle,
          category: translatedCategory,
          imageUrl: widget.sound.imageUrl,
        );
      }
    }
  }

  

  void _skipForward() async {
    final newPosition =
        _audioService.currentPosition + const Duration(seconds: 15);
    if (newPosition < _audioService.totalDuration) {
      await _audioService.seek(newPosition);
    }
  }

  void _skipBackward() async {
    final newPosition =
        _audioService.currentPosition - const Duration(seconds: 15);
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
                // Web: scrollable column so nothing overflows.
                // Mobile: original full-height column with Spacer.
                if (isWeb) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  // Reserve space for fixed elements: topbar ~72, song info ~80,
                  // slider ~56, controls ~100, details btn ~48, padding ~80
                  final fixedHeight = 436.0;
                  // Album art gets what's left, clamped between 180 and 320
                  final artSize =
                      (screenHeight - fixedHeight).clamp(180.0, 320.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        // Top Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 32),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.black87,
                            ),
                            Text(
                              AppLocalizations.of(context)!.nowPlaying,
                              style: TextStyle(
                                fontSize: 22,
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

                        const Spacer(),

                        // Album Art — dynamic size
                        Container(
                          width: artSize,
                          height: artSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.network(
                              widget.sound.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color:
                                      const Color(0xFF40E0D0).withOpacity(0.2),
                                  child: Icon(
                                    Icons.music_note,
                                    size: artSize * 0.4,
                                    color: const Color(0xFF40E0D0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Song Info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SoundLocalizationHelper.getSoundTitle(context, widget.sound.titleKey),
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    SoundLocalizationHelper.getSoundCategory(context, widget.sound.categoryKey),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 32,
                                  color: _isFavorite
                                      ? const Color(0xFFFFB5C2)
                                      : Colors.grey[400],
                                ),
                                onPressed: () =>
                                    setState(() => _isFavorite = !_isFavorite),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Progress slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 16),
                                  activeTrackColor: const Color(0xFF40E0D0),
                                  inactiveTrackColor: Colors.grey[300],
                                  thumbColor: const Color(0xFF40E0D0),
                                  overlayColor:
                                      const Color(0xFF40E0D0).withOpacity(0.2),
                                ),
                                child: Slider(
                                  value: _audioService.currentPosition.inSeconds
                                      .toDouble(),
                                  min: 0,
                                  max: _audioService.totalDuration.inSeconds
                                              .toDouble() >
                                          0
                                      ? _audioService.totalDuration.inSeconds
                                          .toDouble()
                                      : 1.0,
                                  onChanged: (value) {
                                    _audioService
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _audioService.formatTime(
                                        _audioService.currentPosition),
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _audioService.formatTime(
                                        _audioService.totalDuration),
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Playback Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                size: 24,
                                color: _isShuffling
                                    ? const Color(0xFF40E0D0)
                                    : Colors.grey[400],
                              ),
                              onPressed: () =>
                                  setState(() => _isShuffling = !_isShuffling),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.skip_previous, size: 36),
                              color: Colors.black87,
                              onPressed: _skipBackward,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB5C2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFB5C2)
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _audioService.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 36,
                                ),
                                color: Colors.white,
                                onPressed: () =>
                                    _audioService.togglePlayPause(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.skip_next, size: 36),
                              color: Colors.black87,
                              onPressed: _skipForward,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                Icons.repeat,
                                size: 24,
                                color: _audioService.isRepeating
                                    ? const Color(0xFF40E0D0)
                                    : Colors.grey[400],
                              ),
                              onPressed: () => _audioService.toggleRepeat(),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // More Details Button
                        TextButton(
                          onPressed: () => _showDetailsSheet(context, true),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.keyboard_arrow_up,
                                  color: Color(0xFF40E0D0), size: 20),
                              SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.moreDetails,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF40E0D0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }

                // ── Mobile layout (unchanged) ──
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 32),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.black87,
                            ),
                            Text(
                              AppLocalizations.of(context)!.nowPlaying,
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
                                    color: const Color(0xFF40E0D0)
                                        .withOpacity(0.2),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SoundLocalizationHelper.getSoundTitle(context, widget.sound.titleKey),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    SoundLocalizationHelper.getSoundCategory(context, widget.sound.categoryKey),
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
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 32,
                                color: _isFavorite
                                    ? const Color(0xFFFFB5C2)
                                    : Colors.grey[400],
                              ),
                              onPressed: () =>
                                  setState(() => _isFavorite = !_isFavorite),
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
                                    enabledThumbRadius: 8),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 16),
                                activeTrackColor: const Color(0xFF40E0D0),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: const Color(0xFF40E0D0),
                                overlayColor:
                                    const Color(0xFF40E0D0).withOpacity(0.2),
                              ),
                              child: Slider(
                                value: _audioService.currentPosition.inSeconds
                                    .toDouble(),
                                min: 0,
                                max: _audioService.totalDuration.inSeconds
                                            .toDouble() >
                                        0
                                    ? _audioService.totalDuration.inSeconds
                                        .toDouble()
                                    : 1.0,
                                onChanged: (value) {
                                  _audioService
                                      .seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _audioService.formatTime(
                                        _audioService.currentPosition),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _audioService.formatTime(
                                        _audioService.totalDuration),
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[600]),
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
                              onPressed: () =>
                                  setState(() => _isShuffling = !_isShuffling),
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
                                    color: const Color(0xFFFFB5C2)
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _audioService.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 44,
                                ),
                                color: Colors.white,
                                onPressed: () =>
                                    _audioService.togglePlayPause(),
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
                                color: _audioService.isRepeating
                                    ? const Color(0xFF40E0D0)
                                    : Colors.grey[400],
                              ),
                              onPressed: () => _audioService.toggleRepeat(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // More Details Button
                      TextButton(
                        onPressed: () => _showDetailsSheet(context, false),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.keyboard_arrow_up,
                                color: Color(0xFF40E0D0), size: 20),
                            SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.moreDetails,
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
                AppLocalizations.of(context)!.aboutThisSound,
                style: TextStyle(
                  fontSize: isWeb ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWeb ? 24 : 16),
              _buildDetailRow(
                Icons.category,
                AppLocalizations.of(context)!.category,
                SoundLocalizationHelper.getSoundCategory(context, widget.sound.categoryKey),
                isWeb,
              ),
              SizedBox(height: isWeb ? 16 : 12),
              _buildDetailRow(
                Icons.access_time,
                AppLocalizations.of(context)!.duration,
                AppLocalizations.of(context)!.durationFormat(widget.sound.durationMinutes),
                isWeb,
              ),
              SizedBox(height: isWeb ? 16 : 12),
              _buildDetailRow(
                Icons.info_outline,
                AppLocalizations.of(context)!.type,
                AppLocalizations.of(context)!.meditationType,
                isWeb,
              ),
              SizedBox(height: isWeb ? 32 : 24),
              Text(
                AppLocalizations.of(context)!.benefits,
                style: TextStyle(
                  fontSize: isWeb ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: isWeb ? 16 : 12),
              Text(
                '${AppLocalizations.of(context)!.soundBenefit1}\n${AppLocalizations.of(context)!.soundBenefit2}\n${AppLocalizations.of(context)!.soundBenefit3}\n${AppLocalizations.of(context)!.soundBenefit4}',
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

  Widget _buildDetailRow(
      IconData icon, String label, String value, bool isWeb) {
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
