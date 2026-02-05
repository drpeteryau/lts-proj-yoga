import 'package:flutter/material.dart';
import '../data/yoga_data_complete.dart';
import '../models/yoga_session.dart';
import 'session_detail_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/yoga_localization_helper.dart';

class AdvancedSessionsScreen extends StatelessWidget {
  const AdvancedSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = YogaDataComplete.advancedSessions;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F8),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              GlobalAudioService.playClickSound();
              Navigator.pop(context);
            }),
        title: Text(
          AppLocalizations.of(context)!.advancedTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2AB5A5),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Warning banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2AB5A5).withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2AB5A5).withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF2AB5A5),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.dynamicFlowNotice,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return _buildSessionCard(context, sessions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, YogaSession session) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailScreen(session: session),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2AB5A5).withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2AB5A5).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2AB5A5).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Session icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2AB5A5).withOpacity(0.2),
                        const Color(0xFF2AB5A5).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Color(0xFF2AB5A5),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2AB5A5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.advancedLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        YogaLocalizationHelper.getSessionTitle(context, session.titleKey),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Color(0xFF2AB5A5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.minutesCount(session.totalDurationMinutes),                            
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2AB5A5),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.whatshot,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.highIntensity,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              YogaLocalizationHelper.getSessionDescription(context, session.descriptionKey),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Flow info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2AB5A5).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2AB5A5).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Color(0xFF2AB5A5),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.sunSalutationTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2AB5A5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFlowStep(AppLocalizations.of(context)!.step1),
                  _buildFlowStep(AppLocalizations.of(context)!.step2),
                  _buildFlowStep(AppLocalizations.of(context)!.step3),
                  _buildFlowStep(AppLocalizations.of(context)!.step4),
                  _buildFlowStep(AppLocalizations.of(context)!.step5),
                  _buildFlowStep(AppLocalizations.of(context)!.step6),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.loop,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.repeatRounds,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  GlobalAudioService.playClickSound();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SessionDetailScreen(session: session),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2AB5A5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_filled, size: 24),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.beginFlow,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildFlowStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2AB5A5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            step,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
