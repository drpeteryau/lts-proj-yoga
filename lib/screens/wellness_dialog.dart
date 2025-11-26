import 'package:flutter/material.dart';

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
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Wellness Check-in',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFFE3F8F5), const Color(0xFFD0F7F0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.insights, color: Color(0xFF2CC5B6), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Your Progress Summary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('📅 Total Sessions: $totalActivities', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text('🔥 Current Streak: $currentStreak days', style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text('🏆 Weekly Goal: $weeklyMinutes / $weeklyGoal minutes', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section 1 - Physical Comfort & Mobility
                  _buildSectionHeader('Section 1 – Physical Comfort & Mobility', Colors.blue),
                  const SizedBox(height: 16),
                  
                  // Q1: Body Comfort
                  _buildQuestion(
                    '1️⃣ How comfortable does your body feel during movement?',
                    ['Not comfortable', 'Slightly comfortable', 'Moderately comfortable', 'Very comfortable', 'Extremely comfortable'],
                    bodyComfort,
                    (value) {
                      setState(() {});
                      onBodyComfortChanged(value);
                    },
                  ),
                  
                  // Q2: Flexibility
                  _buildQuestion(
                    '2️⃣ How would you describe your flexibility recently?',
                    ['Much stiffer', 'A little stiff', 'About the same', 'A bit more flexible', 'Much more flexible'],
                    flexibility,
                    (value) {
                      setState(() {});
                      onFlexibilityChanged(value);
                    },
                  ),
                  
                  // Q3: Balance
                  _buildQuestion(
                    '3️⃣ How steady do you feel when standing or balancing?',
                    ['Not steady at all', 'Slightly steady', 'Moderately steady', 'Very steady', 'Extremely steady'],
                    balance,
                    (value) {
                      setState(() {});
                      onBalanceChanged(value);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Section 2 - Energy & Mood
                  _buildSectionHeader('Section 2 – Energy & Mood', Colors.orange),
                  const SizedBox(height: 16),
                  
                  // Q4: Energy Level
                  _buildQuestion(
                    '4️⃣ How is your overall energy level?',
                    ['Very low', 'Low', 'Average', 'Good', 'Very good'],
                    energyLevel,
                    (value) {
                      setState(() {});
                      onEnergyLevelChanged(value);
                    },
                  ),
                  
                  // Q5: Mood
                  _buildQuestion(
                    '5️⃣ How has your mood been lately?',
                    ['Often stressed or down', 'Sometimes stressed', 'Mostly okay', 'Mostly positive', 'Very positive and calm'],
                    mood,
                    (value) {
                      setState(() {});
                      onMoodChanged(value);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Section 3 - Awareness & Confidence
                  _buildSectionHeader('Section 3 – Awareness & Confidence', Colors.purple),
                  const SizedBox(height: 16),
                  
                  // Q6: Daily Confidence
                  _buildQuestion(
                    '6️⃣ How confident do you feel performing daily activities?',
                    ['Not confident', 'Slightly confident', 'Somewhat confident', 'Confident', 'Very confident'],
                    dailyConfidence,
                    (value) {
                      setState(() {});
                      onDailyConfidenceChanged(value);
                    },
                  ),
                  
                  // Q7: Body Connection
                  _buildQuestion(
                    '7️⃣ How connected do you feel to your body during yoga practice?',
                    ['Not connected', 'A little connected', 'Moderately connected', 'Very connected', 'Deeply connected'],
                    bodyConnection,
                    (value) {
                      setState(() {});
                      onBodyConnectionChanged(value);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Section 4 - Overall Wellbeing
                  _buildSectionHeader('⭐ Overall Wellbeing', Colors.green),
                  const SizedBox(height: 16),
                  
                  // Q8: Overall Wellbeing
                  _buildQuestion(
                    '8️⃣ Overall, how would you rate your wellbeing this month?',
                    ['Poor', 'Fair', 'Good', 'Very good', 'Excellent'],
                    overallWellbeing,
                    (value) {
                      setState(() {});
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💭 Monthly Reflections (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2CC5B6),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Share specific improvements you\'ve noticed:',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Balance Reflection
                  _buildReflectionField(
                    '🧘 Balance Improvements',
                    'e.g., I can stand on one leg longer...',
                    onBalanceReflectionChanged,
                  ),
                  
                  // Posture Reflection
                  _buildReflectionField(
                    '🪑 Posture Improvements',
                    'e.g., My back feels straighter...',
                    onPostureReflectionChanged,
                  ),
                  
                  // Consistency Reflection
                  _buildReflectionField(
                    '📅 Consistency & Habits',
                    'e.g., I practice every morning now...',
                    onConsistencyReflectionChanged,
                  ),
                  
                  // Other Reflection
                  _buildReflectionField(
                    '💬 Other Thoughts',
                    'Any other improvements or notes...',
                    onOtherReflectionChanged,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Skip for Now', style: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
              ElevatedButton(
                onPressed: () {
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
                child: const Text(
                  'Submit Check-in',
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
