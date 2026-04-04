import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const _kTeal = Color(0xFF40E0D0);
const _kTealDark = Color(0xFF00897B);
const _kTealDeep = Color(0xFF00695C);
const _kTealLight = Color(0xFFD4F1F0);
const _kBg = Colors.white;
const _kSurface = Color(0xFFF8F8F8);
const _kBorder = Color(0xFFE8E8E8);

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class InsightVideoItem {
  final String speakerName;
  final String speakerRole;
  final String speakerAvatarAsset;
  final Color accentColor;
  final Color accentLight;
  final String question;
  final String tag;
  final String duration;
  final String? youtubeVideoId;
  final List<InsightVideoItem> allSpeakerItems;
  final int currentIndex;

  const InsightVideoItem({
    required this.speakerName,
    required this.speakerRole,
    required this.speakerAvatarAsset,
    required this.accentColor,
    required this.accentLight,
    required this.question,
    required this.tag,
    required this.duration,
    required this.youtubeVideoId,
    required this.allSpeakerItems,
    required this.currentIndex,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// InsightVideoScreen
// ─────────────────────────────────────────────────────────────────────────────

class InsightVideoScreen extends StatefulWidget {
  final InsightVideoItem item;

  const InsightVideoScreen({super.key, required this.item});

  @override
  State<InsightVideoScreen> createState() => _InsightVideoScreenState();
}

class _InsightVideoScreenState extends State<InsightVideoScreen> {
  YoutubePlayerController? _ytController;
  late int _currentIndex;
  bool _isFullscreen = false;

  InsightVideoItem get _current => widget.item.allSpeakerItems[_currentIndex];

  bool get _supportsEmbeddedYoutube {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.item.currentIndex;

    if (_supportsEmbeddedYoutube && _current.youtubeVideoId != null) {
      _initPlayer(_current.youtubeVideoId!);
    }
  }

  void _initPlayer(String videoId) {
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        forceHD: false,
      ),
    );
  }

  Future<void> _openYoutubeExternally(String videoId) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _goTo(int index) {
    if (index == _currentIndex) return;

    _ytController?.dispose();

    setState(() {
      _currentIndex = index;
    });

    if (_supportsEmbeddedYoutube && _current.youtubeVideoId != null) {
      _initPlayer(_current.youtubeVideoId!);
    }
  }

  @override
  void dispose() {
    _ytController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Widget _buildPlayerArea() {
    final videoId = _current.youtubeVideoId;

    if (videoId == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Text(
            'Video coming soon',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (_supportsEmbeddedYoutube && _ytController != null) {
      return YoutubePlayerBuilder(
        onEnterFullScreen: () {
          setState(() => _isFullscreen = true);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        onExitFullScreen: () {
          setState(() => _isFullscreen = false);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        },
        player: YoutubePlayer(
          controller: _ytController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: _kTeal,
          progressColors: const ProgressBarColors(
            playedColor: _kTeal,
            handleColor: _kTealDark,
            bufferedColor: _kTealLight,
            backgroundColor: Colors.white24,
          ),
          bottomActions: const [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            RemainingDuration(),
            PlaybackSpeedButton(),
            FullScreenButton(),
          ],
        ),
        builder: (context, player) => AspectRatio(
          aspectRatio: 16 / 9,
          child: player,
        ),
      );
    }

    // Desktop fallback (prevents crash)
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 72,
                  color: Colors.white,
                ),
                const SizedBox(height: 14),
                Text(
                  _current.question,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_current.speakerName} • ${_current.duration}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => _openYoutubeExternally(videoId),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open Interview'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _current.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWebLayout = MediaQuery.of(context).size.width > 900;
    final player = _buildPlayerArea();

    return Scaffold(
      backgroundColor: isWebLayout ? _kSurface : _kBg,
      body: isWebLayout ? _webLayout(player) : _mobileLayout(player),
    );
  }

  Widget _mobileLayout(Widget player) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(color: Colors.black, child: player),
            ),
            SliverToBoxAdapter(
              child: _InfoPanel(
                item: _current,
                currentIndex: _currentIndex,
                onGoTo: _goTo,
                isWeb: false,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 16,
              ),
            ),
          ],
        ),
        if (!_isFullscreen)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            child: _CircleBtn(
              icon: Icons.close,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        if (!_isFullscreen)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 12,
            child: _CounterBadge(
              current: _currentIndex + 1,
              total: _current.allSpeakerItems.length,
              color: _current.accentColor,
            ),
          ),
      ],
    );
  }

  Widget _webLayout(Widget player) {
    return Column(
      children: [
        Container(
          height: 72,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: _kTealDeep,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Text(
                'Expert Insights',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: _kBorder),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 24, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: player,
                      ),
                      const SizedBox(height: 24),
                      _InfoPanel(
                        item: _current,
                        currentIndex: _currentIndex,
                        onGoTo: _goTo,
                        isWeb: true,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 360,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(left: BorderSide(color: _kBorder)),
                ),
                child: _Sidebar(
                  items: _current.allSpeakerItems,
                  currentIndex: _currentIndex,
                  onTap: _goTo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Panel
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPanel extends StatelessWidget {
  final InsightVideoItem item;
  final int currentIndex;
  final void Function(int) onGoTo;
  final bool isWeb;

  const _InfoPanel({
    required this.item,
    required this.currentIndex,
    required this.onGoTo,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrev = currentIndex > 0;
    final hasNext = currentIndex < item.allSpeakerItems.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isWeb
            ? BorderRadius.circular(16)
            : const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: isWeb
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ]
            : null,
      ),
      padding: EdgeInsets.all(isWeb ? 24 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.tag,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.question,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    item.speakerAvatarAsset,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 42,
                      height: 42,
                      color: item.accentLight,
                      child: Icon(Icons.person,
                          color: item.accentColor, size: 22),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.speakerName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      item.speakerRole,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: item.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time,
                        size: 13, color: item.accentColor),
                    const SizedBox(width: 4),
                    Text(
                      item.duration,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: hasPrev
                    ? OutlinedButton.icon(
                  onPressed: () => onGoTo(currentIndex - 1),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14),
                  label: Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: item.accentColor,
                    side: BorderSide(color: item.accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              if (hasPrev && hasNext) const SizedBox(width: 12),
              Expanded(
                child: hasNext
                    ? ElevatedButton.icon(
                  onPressed: () => onGoTo(currentIndex + 1),
                  icon: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  label: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final List<InsightVideoItem> items;
  final int currentIndex;
  final void Function(int) onTap;

  const _Sidebar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            'Up Next',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final item = items[i];
              final isCurrent = i == currentIndex;

              return InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? item.accentColor.withOpacity(0.10)
                        : const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCurrent
                          ? item.accentColor.withOpacity(0.35)
                          : const Color(0xFFEAEAEA),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? item.accentColor
                              : item.accentLight,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isCurrent
                                  ? Colors.white
                                  : item.accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.question,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                height: 1.4,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isCurrent
                                    ? item.accentColor
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${item.speakerName} • ${item.duration}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withOpacity(0.92),
    shape: const CircleBorder(),
    elevation: 3,
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Icon(icon, color: _kTeal, size: 20),
      ),
    ),
  );
}

class _CounterBadge extends StatelessWidget {
  final int current;
  final int total;
  final Color color;

  const _CounterBadge({
    required this.current,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: Text(
      '$current / $total',
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}