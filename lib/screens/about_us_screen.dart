import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const turquoise = Color(0xFF40E0D0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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

            // Team Section
            _sectionTitle(AppLocalizations.of(context)!.projectTeam),

            const SizedBox(height: 24),

            // Supervisor
            _teamMember(
              name: "Dr. Peter Yau",
              role: AppLocalizations.of(context)!.projectSupervisor,
            ),

            const SizedBox(height: 32),

            _sectionTitle(
              AppLocalizations.of(context)!.developmentTeam,
              fontSize: 20,
            ),

            const SizedBox(height: 16),

            // Team Members
            _teamMember(name: "Jocasta Tan"),
            const SizedBox(height: 12),
            _teamMember(name: "Daniel Soong"),
            const SizedBox(height: 12),
            _teamMember(name: "Kaam Yan Hye"),
            const SizedBox(height: 12),
            _teamMember(name: "Natalie Narayanan"),

            const SizedBox(height: 40),

            // Yoga Instructor
            _teamMember(
              name: "Ms. Lim Li Peng",
              role: AppLocalizations.of(context)!.yogaInstructor,
            ),

            const SizedBox(height: 32),

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
