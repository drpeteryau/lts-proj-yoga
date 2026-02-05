import 'package:flutter/material.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

void showSeniorFriendlyWellnessDialog({
  required BuildContext context,
  required Color primaryTeal,
  required int totalActivities,
  required int currentStreak,
  required int weeklyMinutes,
  required int weeklyGoal,
  required int? bodyComfort,
  required int? flexibility,
  required int? balance,
  required int? energyLevel,
  required int? mood,
  required int? dailyConfidence,
  required int? bodyConnection,
  required int? overallWellbeing,
  required Function(int?) onBodyComfortChanged,
  required Function(int?) onFlexibilityChanged,
  required Function(int?) onBalanceChanged,
  required Function(int?) onEnergyLevelChanged,
  required Function(int?) onMoodChanged,
  required Function(int?) onDailyConfidenceChanged,
  required Function(int?) onBodyConnectionChanged,
  required Function(int?) onOverallWellbeingChanged,
  required Function(String) onBalanceReflectionChanged,
  required Function(String) onPostureReflectionChanged,
  required Function(String) onConsistencyReflectionChanged,
  required Function(String) onOtherReflectionChanged,
  required Function() onSubmit,
}) {
  // Local state for the dialog
  int? localBodyComfort = bodyComfort;
  int? localFlexibility = flexibility;
  int? localBalance = balance;
  int? localEnergyLevel = energyLevel;
  int? localMood = mood;
  int? localDailyConfidence = dailyConfidence;
  int? localBodyConnection = bodyConnection;
  int? localOverallWellbeing = overallWellbeing;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.wellnessDialogTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Section 1 - Physical Comfort & Mobility
                    _buildSectionHeader(AppLocalizations.of(context)!.section1Title, Colors.blue),
                    const SizedBox(height: 16),

                    // Q1: Body Comfort
                    _buildQuestion(
                      AppLocalizations.of(context)!.qBodyComfortFull,
                      [
                        AppLocalizations.of(context)!.optComfort1,
                        AppLocalizations.of(context)!.optComfort2,
                        AppLocalizations.of(context)!.optComfort3,
                        AppLocalizations.of(context)!.optComfort4,
                        AppLocalizations.of(context)!.optComfort5
                      ],
                      localBodyComfort,
                          (value) {
                        setDialogState(() => localBodyComfort = value);
                        onBodyComfortChanged(value);
                      },
                    ),

                    // Q2: Flexibility
                    _buildQuestion(
                      AppLocalizations.of(context)!.qFlexibilityFull,
                      [
                        AppLocalizations.of(context)!.optFlexibility1,
                        AppLocalizations.of(context)!.optFlexibility2,
                        AppLocalizations.of(context)!.optFlexibility3,
                        AppLocalizations.of(context)!.optFlexibility4,
                        AppLocalizations.of(context)!.optFlexibility5
                      ],
                      localFlexibility,
                          (value) {
                        setDialogState(() => localFlexibility = value);
                        onFlexibilityChanged(value);
                      },
                    ),

                    // Q3: Balance
                    _buildQuestion(
                      AppLocalizations.of(context)!.qBalanceFull,
                      [
                        AppLocalizations.of(context)!.optBalance1,
                        AppLocalizations.of(context)!.optBalance2,
                        AppLocalizations.of(context)!.optBalance3,
                        AppLocalizations.of(context)!.optBalance4,
                        AppLocalizations.of(context)!.optBalance5
                      ],
                      localBalance,
                          (value) {
                        setDialogState(() => localBalance = value);
                        onBalanceChanged(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Section 2 - Energy & Mood
                    _buildSectionHeader(AppLocalizations.of(context)!.section2Title, Colors.orange),
                    const SizedBox(height: 16),

                    // Q4: Energy Level
                    _buildQuestion(
                      AppLocalizations.of(context)!.qEnergyFull,
                      [
                        AppLocalizations.of(context)!.optEnergy1,
                        AppLocalizations.of(context)!.optEnergy2,
                        AppLocalizations.of(context)!.optEnergy3,
                        AppLocalizations.of(context)!.optEnergy4,
                        AppLocalizations.of(context)!.optEnergy5
                      ],
                      localEnergyLevel,
                          (value) {
                        setDialogState(() => localEnergyLevel = value);
                        onEnergyLevelChanged(value);
                      },
                    ),

                    // Q5: Mood
                    _buildQuestion(
                      AppLocalizations.of(context)!.qMoodFull,
                      [
                        AppLocalizations.of(context)!.optMood1,
                        AppLocalizations.of(context)!.optMood2,
                        AppLocalizations.of(context)!.optMood3,
                        AppLocalizations.of(context)!.optMood4,
                        AppLocalizations.of(context)!.optMood5
                      ],
                      localMood,
                          (value) {
                        setDialogState(() => localMood = value);
                        onMoodChanged(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Section 3 - Awareness & Confidence
                    _buildSectionHeader(AppLocalizations.of(context)!.section3Title, Colors.purple),
                    const SizedBox(height: 16),

                    // Q6: Daily Confidence
                    _buildQuestion(
                      AppLocalizations.of(context)!.qConfidenceFull,
                      [
                        AppLocalizations.of(context)!.optConfidence1,
                        AppLocalizations.of(context)!.optConfidence2,
                        AppLocalizations.of(context)!.optConfidence3,
                        AppLocalizations.of(context)!.optConfidence4,
                        AppLocalizations.of(context)!.optConfidence5
                      ],
                      localDailyConfidence,
                          (value) {
                        setDialogState(() => localDailyConfidence = value);
                        onDailyConfidenceChanged(value);
                      },
                    ),

                    // Q7: Body Connection
                    _buildQuestion(
                      AppLocalizations.of(context)!.qBodyConnectionFull,
                      [
                        AppLocalizations.of(context)!.optConnection1,
                        AppLocalizations.of(context)!.optConnection2,
                        AppLocalizations.of(context)!.optConnection3,
                        AppLocalizations.of(context)!.optConnection4,
                        AppLocalizations.of(context)!.optConnection5
                      ],
                      localBodyConnection,
                          (value) {
                        setDialogState(() => localBodyConnection = value);
                        onBodyConnectionChanged(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Section 4 - Overall Wellbeing
                    _buildSectionHeader(AppLocalizations.of(context)!.section4Title, Colors.green),
                    const SizedBox(height: 16),

                    // Q8: Overall Wellbeing
                    _buildQuestion(
                      AppLocalizations.of(context)!.qOverallFull,
                      [
                        AppLocalizations.of(context)!.optOverall1,
                        AppLocalizations.of(context)!.optOverall2,
                        AppLocalizations.of(context)!.optOverall3,
                        AppLocalizations.of(context)!.optOverall4,
                        AppLocalizations.of(context)!.optOverall5
                      ],
                      localOverallWellbeing,
                          (value) {
                        setDialogState(() => localOverallWellbeing = value);
                        onOverallWellbeingChanged(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Monthly Reflections Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F8F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.monthlyReflections,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2CC5B6),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!.shareImprovements,
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Balance Reflection
                    _buildReflectionField(
                      AppLocalizations.of(context)!.labelBalance,
                      AppLocalizations.of(context)!.hintBalance,
                      onBalanceReflectionChanged,
                    ),

                    // Posture Reflection
                    _buildReflectionField(
                      AppLocalizations.of(context)!.labelPosture,
                      AppLocalizations.of(context)!.hintPosture,
                      onPostureReflectionChanged,
                    ),

                    // Consistency Reflection
                    _buildReflectionField(
                      AppLocalizations.of(context)!.labelConsistency,
                      AppLocalizations.of(context)!.hintConsistency,
                      onConsistencyReflectionChanged,
                    ),

                    // Other Reflection
                    _buildReflectionField(
                      AppLocalizations.of(context)!.labelOther,
                      AppLocalizations.of(context)!.hintOther,
                      onOtherReflectionChanged,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  Navigator.pop(dialogContext);
                },
                child: Text(AppLocalizations.of(context)!.skipForNow, style: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
              ElevatedButton(
                onPressed: () async {
                  await GlobalAudioService.playClickSound();
                  // Validate all required fields
                  if (localBodyComfort == null ||
                      localFlexibility == null ||
                      localBalance == null ||
                      localEnergyLevel == null ||
                      localMood == null ||
                      localDailyConfidence == null ||
                      localBodyConnection == null ||
                      localOverallWellbeing == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.validationErrorCheckIn),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(dialogContext);
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.submitCheckIn,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildSectionHeader(String title, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );
}

Widget _buildQuestion(
    String question,
    List<String> options,
    int? selectedValue,
    Function(int?) onChanged,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),
      ...List.generate(options.length, (index) {
        final value = index + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: selectedValue == value
                ? const Color(0xFF2CC5B6).withOpacity(0.15)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedValue == value
                  ? const Color(0xFF2CC5B6)
                  : Colors.grey.shade300,
              width: selectedValue == value ? 2 : 1,
            ),
          ),
          child: RadioListTile<int>(
            title: Text(
              options[index],
              style: TextStyle(
                fontSize: 15,
                fontWeight: selectedValue == value ? FontWeight.w600 : FontWeight.normal,
                color: selectedValue == value ? const Color(0xFF2CC5B6) : Colors.black87,
              ),
            ),
            value: value,
            groupValue: selectedValue,
            activeColor: const Color(0xFF2CC5B6),
            onChanged: onChanged,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
        );
      }),
      const SizedBox(height: 20),
    ],
  );
}

Widget _buildReflectionField(
    String label,
    String hint,
    Function(String) onChanged,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        maxLines: 2,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2CC5B6), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.all(14),
        ),
        onChanged: onChanged,
      ),
      const SizedBox(height: 14),
    ],
  );
}