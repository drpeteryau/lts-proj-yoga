import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'insight_video_screen.dart';

const _kTeal = Color(0xFF40E0D0);
const _kTealDark = Color(0xFF00897B);
const _kTealDeep = Color(0xFF00695C);
const _kTealLight = Color(0xFFD4F1F0);
const _kPeach = Color(0xFFFFE9DB);
const _kPeachDark = Color(0xFFD4845A);
const _kBg1 = Color(0xFFD4F1F0);
const _kBg2 = Color(0xFFFFFFFF);
const _kBg3 = Color(0xFFE8F9F3);
const _kBg4 = Color(0xFFFFE9DB);

// ─────────────────────────────────────────────────────────────────────────────
// Raw data — youtubeVideoId null = coming soon
// TODO: Replace placeholder video IDs with real interview video IDs
// ─────────────────────────────────────────────────────────────────────────────

class _InterviewData {
  final String Function(AppLocalizations) question;
  final String Function(AppLocalizations) tag;
  final String duration;
  final String? youtubeVideoId; // null = coming soon

  const _InterviewData({
    required this.question,
    required this.tag,
    required this.duration,
    this.youtubeVideoId,
  });
}

final _msLimData = [
  _InterviewData(
    question: (l) => l.insightsMsLimQ1,
    tag: (l) => l.insightsTagBenefits,
    duration: '~4 min',
    youtubeVideoId: 'kRNb9CTXSRE', // TODO: replace with real interview video
  ),
  _InterviewData(
    question: (l) => l.insightsMsLimQ2,
    tag: (l) => l.insightsTagSafety,
    duration: '~5 min',
    youtubeVideoId: null,
  ),
  _InterviewData(
    question: (l) => l.insightsMsLimQ3,
    tag: (l) => l.insightsTagPractice,
    duration: '~4 min',
    youtubeVideoId: null,
  ),
];

final _profCKData = [
  _InterviewData(
    question: (l) => l.insightsProfCKQ1,
    tag: (l) => l.insightsTagAcademia,
    duration: '~6 min',
    youtubeVideoId: null,
  ),
  _InterviewData(
    question: (l) => l.insightsProfCKQ2,
    tag: (l) => l.insightsTagImpact,
    duration: '~5 min',
    youtubeVideoId: null,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// InsightsScreen
// ─────────────────────────────────────────────────────────────────────────────

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  /// Builds the full list of InsightVideoItem for a speaker, so each item
  /// carries the full speaker context needed by InsightVideoScreen.
  List<InsightVideoItem> _buildItems({
    required AppLocalizations l,
    required List<_InterviewData> data,
    required String speakerName,
    required String speakerRole,
    required String speakerAvatarAsset,
    required Color accentColor,
    required Color accentLight,
  }) {
    // First pass: build placeholder list so we can assign allSpeakerItems
    final items = <InsightVideoItem>[];
    for (int i = 0; i < data.length; i++) {
      items.add(InsightVideoItem(
        speakerName: speakerName,
        speakerRole: speakerRole,
        speakerAvatarAsset: speakerAvatarAsset,
        accentColor: accentColor,
        accentLight: accentLight,
        question: data[i].question(l),
        tag: data[i].tag(l),
        duration: data[i].duration,
        youtubeVideoId: data[i].youtubeVideoId, // keep null as null
        allSpeakerItems: const [],
        currentIndex: i,
      ));
    }
    // Second pass: attach full list reference to each item
    return items.map((item) => InsightVideoItem(
      speakerName: item.speakerName,
      speakerRole: item.speakerRole,
      speakerAvatarAsset: item.speakerAvatarAsset,
      accentColor: item.accentColor,
      accentLight: item.accentLight,
      question: item.question,
      tag: item.tag,
      duration: item.duration,
      youtubeVideoId: item.youtubeVideoId,
      allSpeakerItems: items,
      currentIndex: item.currentIndex,
    )).toList();
  }

  void _onTap(BuildContext context, InsightVideoItem item, bool comingSoon) {
    if (comingSoon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.insightsComingSoon,
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          backgroundColor: _kTealDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InsightVideoScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final msLimItems = _buildItems(
      l: l,
      data: _msLimData,
      speakerName: 'Lim Li Peng',
      speakerRole: l.insightsMsLimRole,
      speakerAvatarAsset: 'assets/images/instructor_lim_li_peng.jpg',
      accentColor: _kTealDark,
      accentLight: _kTealLight,
    );

    final profCKItems = _buildItems(
      l: l,
      data: _profCKData,
      speakerName: 'Prof CK',
      speakerRole: l.insightsProfCKRole,
      speakerAvatarAsset: 'assets/images/prof_ck.jpg',
      accentColor: _kPeachDark,
      accentLight: _kPeach,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_kBg1, _kBg2, _kBg3, _kBg4],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: _kTealDeep, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        l.insightsTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSpeakerSection(
                        context: context,
                        speakerName: 'Lim Li Peng',
                        role: l.insightsMsLimRole,
                        avatarAsset: 'assets/images/instructor_lim_li_peng.jpg',
                        accentColor: _kTealDark,
                        accentLight: _kTealLight,
                        fallbackIcon: Icons.person,
                        items: msLimItems,
                      ),
                      const SizedBox(height: 32),
                      _buildSpeakerSection(
                        context: context,
                        speakerName: 'Prof CK',
                        role: l.insightsProfCKRole,
                        avatarAsset: 'assets/images/prof_ck.jpg',
                        accentColor: _kPeachDark,
                        accentLight: _kPeach,
                        fallbackIcon: Icons.school_rounded,
                        items: profCKItems,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeakerSection({
    required BuildContext context,
    required String speakerName,
    required String role,
    required String avatarAsset,
    required Color accentColor,
    required Color accentLight,
    required IconData fallbackIcon,
    required List<InsightVideoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Speaker header
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accentColor.withOpacity(0.5), width: 2.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarAsset,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: accentLight,
                    child: Icon(fallbackIcon, color: accentColor, size: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(speakerName,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                  Text(role,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: accentColor,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),
        Container(
          height: 1,
          color: accentColor.withOpacity(0.15),
          margin: const EdgeInsets.only(bottom: 14),
        ),

        // Interview cards
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final comingSoon = item.youtubeVideoId == null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _onTap(context, item, comingSoon),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Number circle
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: accentLight, shape: BoxShape.circle),
                      child: Center(
                        child: Text('${i + 1}',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: accentColor)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Question
                    Expanded(
                      child: Text(
                        item.question,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            height: 1.45),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Watch / Soon button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: comingSoon
                            ? const Color(0xFFF0F0F0)
                            : accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            comingSoon
                                ? Icons.schedule_rounded
                                : Icons.play_arrow_rounded,
                            size: 16,
                            color: comingSoon ? Colors.black38 : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            comingSoon
                                ? AppLocalizations.of(context)!.insightsSoon
                                : AppLocalizations.of(context)!.insightsWatch,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: comingSoon
                                    ? Colors.black38
                                    : Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}