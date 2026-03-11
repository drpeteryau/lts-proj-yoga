import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/yoga_data_complete.dart';
import 'session_detail_screen.dart';
import 'meditation_screen.dart';
import 'meditation_session_screen.dart';
import 'sound_player_screen.dart';
import '../services/global_audio_service.dart';
import '../utils/yoga_localization_helper.dart';
import '../utils/meditation_sounds_localization_helper.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/user_progress.dart';
import '../services/progress_service.dart';

// ─── Constants ───────────────────────────────────────────────────────────────
const _kTeal = Color(0xFF40E0D0);
const _kTealLight = Color(0xFFD4F1F0);
const _kPeach = Color(0xFFFFE9DB);
const _kBg1 = Color(0xFFD4F1F0);
const _kBg2 = Color(0xFFFFFFFF);
const _kBg3 = Color(0xFFE8F9F3);
const _kBg4 = Color(0xFFFFE9DB);

// Yoga sessions
final yogaSessions = [
  ...YogaDataComplete.beginnerSessions,
  ...YogaDataComplete.intermediateSessions,
  ...YogaDataComplete.advancedSessions,
];

// ─── Widget ───────────────────────────────────────────────────────────────────
class HomeTabScreen extends StatefulWidget {
  final void Function(int index)? onNavigateToTab;
  const HomeTabScreen({super.key, this.onNavigateToTab});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String _userName = '';
  String? _profileImageUrl;

  int _currentStreak = 0;
  int _totalSessions = 0;
  int _weeklyMinutes = 0;
  int _totalMinutes = 0;

  final List<DateTime> _weekDays = [];

  UserProgress? _userProgress;
  final ProgressService _progressService = ProgressService();

  // Inline meditation/sound data (mirrors MeditationScreen)
  final List<MeditationSession> _meditationSessions = [
    MeditationSession(
      titleKey: "morningClarity",
      descriptionKey: "morningClarityDesc",
      durationMinutes: 10,
      imageUrl: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800",
      audioFile: "morning.mp3",
      type: MeditationType.guided,
    ),
    MeditationSession(
      titleKey: "deepBreathing",
      descriptionKey: "deepBreathingDesc",
      durationMinutes: 5,
      imageUrl: "https://images.unsplash.com/photo-1511497584788-876760111969?w=800",
      audioFile: "deepbreathing.mp3",
      type: MeditationType.breathing,
    ),
    MeditationSession(
      titleKey: "eveningWindDown",
      descriptionKey: "eveningWindDownDesc",
      durationMinutes: 15,
      imageUrl: "https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800",
      audioFile: "evening.mp3",
      type: MeditationType.guided,
    ),
  ];

  final List<MeditationSession> _sounds = [
    MeditationSession(
      titleKey: "Ocean Waves",
      descriptionKey: "oceanWavesDesc",
      durationMinutes: 60,
      imageUrl: "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800",
      audioFile: "oceanwaves.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      titleKey: "Rain Sounds",
      descriptionKey: "rainSoundsDesc",
      durationMinutes: 60,
      imageUrl: "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=800",
      audioFile: "raining.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
    MeditationSession(
      titleKey: "Forest Birds",
      descriptionKey: "forestBirdsDesc",
      durationMinutes: 60,
      imageUrl: "https://images.unsplash.com/photo-1511497584788-876760111969?w=800",
      audioFile: "forestbirds.mp3",
      type: MeditationType.sound,
      isLooping: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWellnessData();
    _generateWeekDays();
    _loadUserProgress();
  }

  Future<void> _loadUserData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name, profile_image_url')
          .eq('id', userId)
          .maybeSingle();
      if (response != null && mounted) {
        setState(() {
          _userName = (response['full_name'] as String?)?.split(' ').first ?? 'Friend';
          _profileImageUrl = response['profile_image_url'] as String?;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _loadWellnessData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final sessionsResponse = await Supabase.instance.client
          .from('session_completions')
          .select('id, total_duration_seconds, completion_date')
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      final poseActivitiesResponse = await Supabase.instance.client
          .from('pose_activity')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      int weekSeconds = 0;
      int totalSeconds = 0;
      final Map<String, bool> activityDays = {};
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));

      for (var row in poseActivitiesResponse) {
        final raw = DateTime.parse(row['completed_at']).toLocal();
        final date = DateTime(raw.year, raw.month, raw.day);
        final key = DateFormat('yyyy-MM-dd').format(date);
        activityDays[key] = true;
        final durationSeconds = (row['duration_seconds'] ?? 0) as int;
        totalSeconds += durationSeconds;
        if (!date.isBefore(weekStart)) weekSeconds += durationSeconds;
      }

      int streak = 0;
      DateTime checkDate = today;
      while (true) {
        final key = DateFormat('yyyy-MM-dd').format(checkDate);
        if (activityDays[key] == true) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      if (mounted) {
        setState(() {
          _currentStreak = streak;
          _totalSessions = sessionsResponse.length;
          _weeklyMinutes = (weekSeconds / 60).ceil();
          _totalMinutes = (totalSeconds / 60).ceil();
        });
      }
    } catch (e) {
      debugPrint('Error loading wellness data: $e');
    }
  }

  Future<void> _loadUserProgress() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final progress = await _progressService.getUserProgress(userId);
      if (mounted) setState(() => _userProgress = progress);
    } catch (e) {
      debugPrint('Error loading user progress: $e');
    }
  }

  void _generateWeekDays() {
    _weekDays.clear();
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      _weekDays.add(day);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final l = AppLocalizations.of(context)!;
    if (hour < 12) return l.goodMorning;
    if (hour < 17) return l.goodAfternoon;
    return l.goodEvening;
  }

  void _startMeditationSession(MeditationSession session) async {
    if (MeditationSessionScreen.isActive) return;
    final audioService = GlobalAudioService();
    if (audioService.hasSound) {
      await audioService.clearSound();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (session.type == MeditationType.sound) {
      final index = _sounds.indexOf(session);
      await audioService.startAmbientPlaylist(sounds: _sounds, index: index);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SoundPlayerScreen(sounds: _sounds, initialIndex: index),
        ),
      );
    } else {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MeditationSessionScreen(session: session)),
      );
      audioService.startMeditationWithWelcome(
        assetFile: session.audioFile,
        title: session.titleKey,
        category: "Meditation",
        imageUrl: session.imageUrl,
        duration: Duration(minutes: session.durationMinutes),
      );
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Flower background
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: CustomPaint(painter: FlowerBackgroundPainter()),
            ),
          ),
          // Gradient + content
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_kBg1, _kBg2, _kBg3, _kBg4],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWeb ? 1280 : double.infinity),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 0),
                    child: isWeb ? _buildWebLayout() : _buildMobileLayout(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mobile layout ─────────────────────────────────────────────────────────

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildWeekCalendar(),
        const SizedBox(height: 28),
        // "Today's Practice" label
        _buildSectionHeader(
          AppLocalizations.of(context)!.todaysPractice,
          onSeeAll: () => widget.onNavigateToTab?.call(1),
        ),
        const SizedBox(height: 14),
        // Vertical stack of featured cards (like the reference)
        _buildFeaturedPracticeList(),
        const SizedBox(height: 28),
        // "Recommended for you" — meditation + sound cards
        _buildSectionHeader(
          AppLocalizations.of(context)!.recommendedForYou,
          onSeeAll: () => widget.onNavigateToTab?.call(3),
        ),
        const SizedBox(height: 14),
        _buildRecommendedRow(),
        const SizedBox(height: 28),
        // Wellness Overview
        _buildWellnessOverview(),
        const SizedBox(height: 30),
      ],
    );
  }

  // ─── Web layout ────────────────────────────────────────────────────────────

  Widget _buildWebLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 32),
        _buildWeekCalendar(),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: featured cards
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    AppLocalizations.of(context)!.todaysPractice,
                    onSeeAll: () => widget.onNavigateToTab?.call(1),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturedPracticeList(),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Right: recommended
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    AppLocalizations.of(context)!.recommendedForYou,
                    onSeeAll: () => widget.onNavigateToTab?.call(3),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendedColumn(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _buildWellnessOverview(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWeb ? 0 : 20, isWeb ? 32 : 22, isWeb ? 0 : 20, 0,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _kTeal.withOpacity(0.4), width: 2),
            ),
            child: ClipOval(
              child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                  ? Image.network(_profileImageUrl!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildDefaultAvatar())
                  : _buildDefaultAvatar(),
            ),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.poppins(
                    fontSize: isWeb ? 16 : 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _userName.isEmpty ? AppLocalizations.of(context)!.friend : _userName,
                  style: GoogleFonts.poppins(
                    fontSize: isWeb ? 30 : 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [_kTeal, Color(0xFF20B2AA)]),
      ),
      child: Center(
        child: Text(
          _userName.isEmpty ? 'F' : _userName[0].toUpperCase(),
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // ─── Week calendar ─────────────────────────────────────────────────────────

  Widget _buildWeekCalendar() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final now = DateTime.now();
    final monthName = DateFormat(
      'MMMM yyyy',
      Localizations.localeOf(context).toString(),
    ).format(now);

    // On web, pills should not stretch to the full 1280px width — cap at 480px
    final pillRow = _weekDays.isNotEmpty
        ? Wrap(
      spacing: 8,
      children: _weekDays.map((d) {
        final isToday = d.year == now.year &&
            d.month == now.month &&
            d.day == now.day;
        return _buildDayPill(
          d.day.toString(),
          DateFormat('E').format(d),
          isToday,
        );
      }).toList(),
    )
        : const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month + chevron
          Row(
            children: [
              Text(
                monthName,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 20 : 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.selectDate,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 12),
          // On web constrain width; on mobile stretch full row
          isWeb
              ? SizedBox(width: 440, child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _weekDays.isNotEmpty ? _weekDays.map((d) {
              final isToday = d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.day;
              return _buildDayPill(d.day.toString(), DateFormat('E').format(d), isToday);
            }).toList() : [],
          ))
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _weekDays.isNotEmpty ? _weekDays.map((d) {
              final isToday = d.year == now.year &&
                  d.month == now.month &&
                  d.day == now.day;
              return _buildDayPill(d.day.toString(), DateFormat('E').format(d), isToday);
            }).toList() : [],
          ),
        ],
      ),
    );
  }

  Widget _buildDayPill(String date, String dayName, bool isToday) {
    return Column(
      children: [
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isToday ? _kTeal : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isToday
                ? [BoxShadow(color: _kTeal.withOpacity(0.35), blurRadius: 10, spreadRadius: 2)]
                : null,
          ),
          child: Column(
            children: [
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isToday ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dayName.substring(0, 3),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: isToday ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Section header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: () async {
                await GlobalAudioService.playClickSound();
                onSeeAll();
              },
              child: Text(
                AppLocalizations.of(context)!.seeAll,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: _kTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Featured practice cards (vertical stack) ──────────────────────────────

  Widget _buildFeaturedPracticeList() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final beginner = yogaSessions.where((s) => s.levelKey.toLowerCase() == 'beginner').toList();
    final intermediate = yogaSessions.where((s) => s.levelKey.toLowerCase() == 'intermediate').toList();
    final advanced = yogaSessions.where((s) => s.levelKey.toLowerCase() == 'advanced').toList();

    final bool intermediateUnlocked = _userProgress?.intermediateUnlocked ?? false;
    final bool advancedUnlocked = _userProgress?.advancedUnlocked ?? false;

    final items = <Map<String, dynamic>>[
      if (beginner.isNotEmpty) {'session': beginner.first, 'label': 'Beginner'},
      if (intermediate.isNotEmpty && intermediateUnlocked)
        {'session': intermediate.first, 'label': 'Intermediate'},
      if (advanced.isNotEmpty && advancedUnlocked)
        {'session': advanced.first, 'label': 'Advanced'},
    ];

    // Fallback: if only beginner unlocked, show 2 beginner sessions
    if (items.length == 1 && beginner.length > 1) {
      items.add({'session': beginner[1], 'label': 'Beginner'});
    }

    return Column(
      children: items.map((item) {
        final session = item['session'] as dynamic;
        final label = item['label'] as String;
        return Padding(
          padding: EdgeInsets.only(
            left: isWeb ? 0 : 20,
            right: isWeb ? 0 : 20,
            bottom: 14,
          ),
          child: _buildPracticeCard(session, label),
        );
      }).toList(),
    );
  }

  Widget _buildPracticeCard(dynamic session, String levelLabel) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final totalMins = (session.totalDurationMinutes as int?) ?? 0;

    return GestureDetector(
      onTap: () async {
        await GlobalAudioService.playClickSound();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SessionDetailScreen(session: session)),
        );
      },
      child: Container(
        height: isWeb ? 160 : 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF26A69A), _kTeal],
                    ),
                  ),
                ),
              ),
              // Dark gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.black.withOpacity(0.15),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Level badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _kTeal.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _kTeal.withOpacity(0.5)),
                            ),
                            child: Text(
                              levelLabel,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            YogaLocalizationHelper.getSessionTitle(context, session.titleKey),
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 20 : 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Duration badge
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  color: Colors.white70, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '$totalMins ${AppLocalizations.of(context)!.min}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Arrow icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30),
                      ),
                      child: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
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

  // ─── Recommended row (mobile) ──────────────────────────────────────────────

  Widget _buildRecommendedRow() {
    // Show 2 meditation cards + 1 sound card in a horizontal scroll
    final items = [
      ..._meditationSessions.take(2),
      _sounds.first,
    ];
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _buildRecommendedCard(items[i]),
      ),
    );
  }

  // ─── Recommended column (web) ──────────────────────────────────────────────

  Widget _buildRecommendedColumn() {
    final items = [..._meditationSessions, _sounds.first];
    return Column(
      children: items
          .map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _buildRecommendedCardWide(s),
      ))
          .toList(),
    );
  }

  Widget _buildRecommendedCard(MeditationSession session) {
    final lookup = MeditationLookup(context);
    final isMed = session.type != MeditationType.sound;
    return GestureDetector(
      onTap: () async {
        await GlobalAudioService.playClickSound();
        _startMeditationSession(session);
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(session.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: _kTealLight)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lookup.getTitle(session.titleKey),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isMed ? Icons.self_improvement : Icons.volume_up,
                          color: _kTeal,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isMed
                              ? '${session.durationMinutes} ${AppLocalizations.of(context)!.min}'
                              : AppLocalizations.of(context)!.ambient,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Play overlay
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCardWide(MeditationSession session) {
    final lookup = MeditationLookup(context);
    final isMed = session.type != MeditationType.sound;
    return GestureDetector(
      onTap: () async {
        await GlobalAudioService.playClickSound();
        _startMeditationSession(session);
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                session.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 80, height: 80, color: _kTealLight),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lookup.getTitle(session.titleKey),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isMed ? Icons.self_improvement : Icons.volume_up,
                        color: _kTeal,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isMed
                            ? '${session.durationMinutes} min'
                            : 'Ambient sound',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _kTeal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Wellness overview ─────────────────────────────────────────────────────

  Widget _buildWellnessOverview() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.wellnessOverview,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          isWeb
              ? GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: _wellnessCards(),
          )
              : Column(
            children: [
              Row(children: [
                Expanded(child: _wellnessCards()[0]),
                const SizedBox(width: 12),
                Expanded(child: _wellnessCards()[1]),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _wellnessCards()[2]),
                const SizedBox(width: 12),
                Expanded(child: _wellnessCards()[3]),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _wellnessCards() {
    final l = AppLocalizations.of(context)!;
    return [
      _buildWellnessCard(
        icon: Icons.local_fire_department,
        iconColor: const Color(0xFFFF6B6B),
        title: l.streak,
        value: l.daysCount(_currentStreak),
      ),
      _buildWellnessCard(
        icon: Icons.self_improvement,
        iconColor: _kTeal,
        title: l.sessions,
        value: '$_totalSessions',
      ),
      _buildWellnessCard(
        icon: Icons.timer_outlined,
        iconColor: const Color(0xFF9B59B6),
        title: l.weekly,
        value: l.minutesCount(_weeklyMinutes),
      ),
      _buildWellnessCard(
        icon: Icons.schedule,
        iconColor: const Color(0xFF3498DB),
        title: l.totalTime,
        value: l.minutesCount(_totalMinutes),
      ),
    ];
  }

  Widget _buildWellnessCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Container(
      padding: EdgeInsets.all(isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: isWeb ? 26 : 22),
          ),
          SizedBox(height: isWeb ? 12 : 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isWeb ? 14 : 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 24 : 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Flower background ─────────────────────────────────────────────────────────
class FlowerBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    _drawFlower(canvas, size.width * 0.15, size.height * 0.12, 80, 0.08);
    _drawFlower(canvas, size.width * 0.88, size.height * 0.25, 65, 0.06);
    _drawFlower(canvas, size.width * 0.08, size.height * 0.45, 90, 0.07);
    _drawFlower(canvas, size.width * 0.82, size.height * 0.58, 70, 0.05);
    _drawFlower(canvas, size.width * 0.25, size.height * 0.75, 75, 0.06);
    _drawFlower(canvas, size.width * 0.92, size.height * 0.82, 60, 0.08);
    _drawFlower(canvas, size.width * 0.45, size.height * 0.2, 40, 0.04);
    _drawFlower(canvas, size.width * 0.6, size.height * 0.5, 45, 0.05);
    _drawFlower(canvas, size.width * 0.35, size.height * 0.9, 50, 0.06);
  }

  void _drawFlower(Canvas canvas, double cx, double cy, double size, double opacity) {
    final validOpacity = opacity.clamp(0.0, 1.0);
    final paint = Paint()
      ..color = const Color(0xFF40E0D0).withOpacity(validOpacity)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 2 * 3.14159) / 6;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(size * 0.3, -size * 0.5, size * 0.15, -size)
        ..quadraticBezierTo(0, -size * 1.1, -size * 0.15, -size)
        ..quadraticBezierTo(-size * 0.3, -size * 0.5, 0, 0)
        ..close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    canvas.drawCircle(
      Offset(cx, cy),
      size * 0.25,
      Paint()
        ..color = const Color(0xFF40E0D0).withOpacity((validOpacity * 1.2).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 