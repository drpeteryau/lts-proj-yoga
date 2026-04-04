import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

const _teal = Color(0xFF40E0D0);
const _tealDark = Color(0xFF00897B);
const _tealDeep = Color(0xFF00695C);
const _textDark = Color(0xFF1F3D3A);
const _textMuted = Color(0xFF6B8F8A);
const _sand = Color(0xFFF8F5F0);

class InstructorProfileScreen extends StatelessWidget {
  const InstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD4F1F0),
              Color(0xFFFFFFFF),
              Color(0xFFE8F9F3),
              Color(0xFFFFE9DB),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFFEAF8F7),
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _tealDeep),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  l.instructorYourInstructor,
                  style: GoogleFonts.poppins(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(l),
                      const SizedBox(height: 20),
                      _buildSectionCard(child: _buildAboutSection(l)),
                      const SizedBox(height: 16),
                      _buildSectionCard(child: _buildYogaStyles(l)),
                      const SizedBox(height: 16),
                      _buildSectionCard(child: _buildCredentials(l)),
                      const SizedBox(height: 16),
                      _buildSectionCard(child: _buildMediaFeature(l)),
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

  Widget _buildHeroCard(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: _teal),
            SizedBox(
              width: 140,
              child: Image.asset(
                'assets/images/instructor_lim_li_peng.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFD0F5F0),
                  child: const Icon(Icons.person, size: 64, color: _teal),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lim Li Peng',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l.instructorRole}\n${l.instructorTagline}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        _Badge(l.instructorHathaTitle),
                        _Badge(l.instructorYinTitle),
                        _Badge(l.instructorChairTitle),
                        _Badge(l.instructorChildrenTitle),
                        const _Badge('NREP'),
                      ],
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

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.3,
            color: _tealDark,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: const Color(0x3F40E0D0)),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(l.instructorAboutTitle),
        Text(
          l.instructorBioP1,
          style: GoogleFonts.poppins(
              fontSize: 13.5, color: const Color(0xFF2E2E2E), height: 1.75),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE8FAF8),
            border: Border(left: BorderSide(color: _teal, width: 3)),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Text(
            l.instructorQuote,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: _tealDeep,
                height: 1.6),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l.instructorBioP2,
          style: GoogleFonts.poppins(
              fontSize: 13.5, color: const Color(0xFF2E2E2E), height: 1.75),
        ),
      ],
    );
  }

  Widget _buildYogaStyles(AppLocalizations l) {
    final styles = [
      (l.instructorHathaTitle, l.instructorHathaDesc),
      (l.instructorYinTitle, l.instructorYinDesc),
      (l.instructorChairTitle, l.instructorChairDesc),
      (l.instructorChildrenTitle, l.instructorChildrenDesc),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(l.instructorYogaStyles),
        // Two columns, each card sizes to its content — no fixed aspect ratio
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _styleCard(styles[0].$1, styles[0].$2),
                  const SizedBox(height: 10),
                  _styleCard(styles[2].$1, styles[2].$2),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  _styleCard(styles[1].$1, styles[1].$2),
                  const SizedBox(height: 10),
                  _styleCard(styles[3].$1, styles[3].$2),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _styleCard(String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _sand,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _tealDeep)),
          const SizedBox(height: 3),
          Text(desc,
              style: GoogleFonts.poppins(
                  fontSize: 10.5, color: _textMuted, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildCredentials(AppLocalizations l) {
    const creds = [
      'Vivekananda Yoga Anusandhana Samsthana — Yoga Instructors\' Course (2013)',
      'Yin Yoga Teacher Training — International Yoga Teachers Association (2018)',
      'Advanced Hatha Yoga Teacher Training — Vyasa Yoga (2019)',
      'Applied Anatomy & Physiology for Yoga Instructors — Vyasa Yoga',
      "Children's Yoga Teacher Training Level 1 — Pure Yoga",
      'MOE-registered Instructor — Yoga & Mindfulness',
      'Member, National Registry of Exercise Professionals (NREP), Sport Singapore',
      'Member, NTUC Union for Freelancers & Self-Employed (UFSE/NICA)',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(l.instructorCredentials),
        ...creds.map(
              (c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: CircleAvatar(radius: 3, backgroundColor: _teal),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(c,
                      style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: const Color(0xFF3A3A3A),
                          height: 1.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaFeature(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(l.instructorMediaTitle),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x3F40E0D0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: _teal, borderRadius: BorderRadius.circular(8)),
                child:
                const Icon(Icons.tv_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.instructorMediaDesc,
                  style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      color: const Color(0xFF2E2E2E),
                      height: 1.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0x1F40E0D0),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0x4D40E0D0)),
    ),
    child: Text(label,
        style: GoogleFonts.poppins(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF00695C))),
  );
}