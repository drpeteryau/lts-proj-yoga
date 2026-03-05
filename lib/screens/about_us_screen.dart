import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const turquoise = Color(0xFF40E0D0);
  static const background = Color(0xFFEAF6F4);
  static const textDark = Color(0xFF1F3D3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutUsTitle),
        centerTitle: true,
        backgroundColor: turquoise,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // App Title Card
            _card(
              child: Column(
                children: [
                  Text(
                    "HealYoga",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.appSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Mission Card
            _card(
              title: AppLocalizations.of(context)!.missionTitle,
              child: Text(
                AppLocalizations.of(context)!.missionContent,
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Features Card
            _card(
              title: AppLocalizations.of(context)!.featuresTitle,
              child: Column(
                children: [
                  FeatureItem(text: AppLocalizations.of(context)!.feature1),
                  FeatureItem(text: AppLocalizations.of(context)!.feature2),
                  FeatureItem(text: AppLocalizations.of(context)!.feature3),
                  FeatureItem(text: AppLocalizations.of(context)!.feature4),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Credits Card
            _card(
              title: AppLocalizations.of(context)!.creditsTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.projectSupervisor,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Dr. Peter Yau"),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.teamMembers,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("• Jocasta Tan"),
                  Text("• Daniel Soong"),
                  Text("• Kaam Yan Hye"),
                  Text("• Natalie Narayanan"),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.yogaInstructor,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Ms Lim Li Peng"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Package Licenses Card
            _card(
              title: AppLocalizations.of(context)!.licensesTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
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
                      icon: const Icon(Icons.description_outlined),
                      label: Text(AppLocalizations.of(context)!.viewLicensesButton),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: turquoise,
                        side: const BorderSide(color: turquoise),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              AppLocalizations.of(context)!.copyright,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _card({String? title, required Widget child}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF40E0D0)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}