import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'instructor_profile_screen.dart';
import 'insights_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const turquoise = Color(0xFF40E0D0);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.aboutUsTitle,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // App Name
            Text(
              AppLocalizations.of(context)!.appName,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.appVersion,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 40),

            // Mission
            _sectionTitle(AppLocalizations.of(context)!.ourMission),

            const SizedBox(height: 16),

            Text(
              AppLocalizations.of(context)!.missionStatement,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black87,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 40),

            // Divider
            _sectionDivider(),

            const SizedBox(height: 40),

            // Features
            _sectionTitle(AppLocalizations.of(context)!.keyFeatures),

            const SizedBox(height: 20),

            _feature(AppLocalizations.of(context)!.featureChairYoga),
            _feature(AppLocalizations.of(context)!.featureMeditation),
            _feature(AppLocalizations.of(context)!.featureProgress),
            _feature(AppLocalizations.of(context)!.featureSounds),

            const SizedBox(height: 36),

            // Divider
            _sectionDivider(),

            const SizedBox(height: 36),

            // Hear From the Experts
            _sectionTitle(l.hearFromExperts),
            const SizedBox(height: 10),
            Text(
              l.hearFromExpertsDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            _buildInsightsCard(context, l),

            const SizedBox(height: 40),

            // Divider
            _sectionDivider(),

            const SizedBox(height: 30),

            // Package Licenses Card
            _card(
              title: AppLocalizations.of(context)!.licensesTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.licenseDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showLicensePage(
                              context: context,
                              applicationName: 'HealYoga',
                              applicationVersion: '1.0.0',
                              applicationIcon: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.self_improvement, size: 48, color: turquoise),
                              ),
                              applicationLegalese: AppLocalizations.of(context)!.copyright,
                            );
                          },
                          icon: const Icon(Icons.description_outlined, color: Colors.white),
                          label: Text(
                            AppLocalizations.of(context)!.viewLicensesButton,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: turquoise,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── Acknowledgment ──────────────────────────────────────
            _sectionTitle(l.acknowledgment),
            const SizedBox(height: 20),

            _acknowledgmentCard(
              icon: Icons.account_balance_rounded,
              label: l.ackPartALabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ackParagraph(l.ackInstitutionalP1),
                  const SizedBox(height: 10),
                  _ackParagraph(l.ackInstitutionalP2),
                  const SizedBox(height: 14),
                  _disclaimerBox('${l.ackDisclaimerTitle}\n\n${l.ackDisclaimerBody}'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _acknowledgmentCard(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFF00897B),
              label: l.ackPartBLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ackParagraph(l.ackTrainerIntro),
                  const SizedBox(height: 14),
                  _buildInstructorCard(context, l),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _acknowledgmentCard(
              icon: Icons.groups_rounded,
              iconColor: const Color(0xFF6B5EA8),
              label: l.ackPartCLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _creditSubheading(l.ackDevTeam),
                  const SizedBox(height: 10),
                  _creditMember(name: 'Jocasta Tan', role: 'Developer'),
                  _creditMember(name: 'Daniel Soong', role: 'Developer'),
                  _creditMember(name: 'Kaam Yan Hye', role: 'Developer'),
                  _creditMember(name: 'Natalie Narayanan', role: 'Developer'),
                  const SizedBox(height: 16),
                  _creditSubheading(l.ackSupervisor),
                  const SizedBox(height: 10),
                  _creditMember(name: 'Dr. Peter Yau', role: '${l.ackSupervisor} · SIT'),
                  const SizedBox(height: 16),
                  _creditSubheading(l.ackSupportingStaff),
                  const SizedBox(height: 10),
                  _ackParagraph(l.ackSupportingStaffDesc),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            Text(
              AppLocalizations.of(context)!.copyright,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.allRightsReserved,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard(BuildContext context, AppLocalizations l) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InsightsScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD4F1F0), Color(0xFFE8F9F3)],
          ),
          border: Border.all(color: turquoise.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: turquoise.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // Icon block
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: turquoise,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.expertInsights,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l.expertInsightsSubtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: turquoise,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l.watchNow,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00695C),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right_rounded,
                          size: 18, color: Color(0xFF00897B)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorCard(BuildContext context, AppLocalizations l) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InstructorProfileScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: turquoise.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: turquoise.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Teal accent stripe
              Container(width: 4, color: turquoise),
              // Photo
              SizedBox(
                width: 100,
                child: Image.asset(
                  'assets/images/instructor_lim_li_peng.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFD4F1F0),
                    child: const Icon(Icons.person,
                        size: 40, color: turquoise),
                  ),
                ),
              ),
              // Text content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lim Li Peng',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Certified Yoga Instructor',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Yoga8288 · Singapore',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00897B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: turquoise,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l.ackViewFullProfile,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF00695C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right_rounded,
                              size: 18, color: Color(0xFF00897B)),
                        ],
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

  Widget _teamMember({required String name, String? role}) {
    return Column(
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (role != null) ...[
          const SizedBox(height: 4),
          Text(
            role,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: turquoise,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {double fontSize = 24}) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _acknowledgmentCard({
    required IconData icon,
    required String label,
    required Widget child,
    Color iconColor = turquoise,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: iconColor),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _ackParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13.5,
        color: Colors.black87,
        height: 1.65,
      ),
    );
  }

  Widget _disclaimerBox(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8C840).withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 16, color: Color(0xFF9A7C00)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF5C4A00),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditSubheading(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: turquoise,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _creditMember({required String name, required String role}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 11),
          const CircleAvatar(radius: 3, backgroundColor: turquoise),
          const SizedBox(width: 10),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '· $role',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider() {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: turquoise,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}