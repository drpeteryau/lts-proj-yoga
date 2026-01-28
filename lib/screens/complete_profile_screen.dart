import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_navigation_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String? fullName;
  final String? email;

  const CompleteProfileScreen({super.key, this.fullName, this.email});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _experienceLevel = 'Beginner';
  String _preferredSessionLength = '15 minutes';
  String _preferredLanguage = 'English';
  bool _pushNotifications = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.fullName ?? '';
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final age = int.tryParse(_ageController.text.trim());
    if (age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }

    // 🧮 Determine age group (same logic as RegisterScreen)
    String ageGroup = 'Unknown';
    if (age < 18) {
      ageGroup = 'Under 18';
    } else if (age <= 24) {
      ageGroup = '18-24 years';
    } else if (age <= 34) {
      ageGroup = '25-34 years';
    } else if (age <= 44) {
      ageGroup = '35-44 years';
    } else if (age <= 54) {
      ageGroup = '45-54 years';
    } else if (age <= 64) {
      ageGroup = '55-64 years';
    } else if (age <= 74) {
      ageGroup = '65-74 years';
    } else {
      ageGroup = '75+ years';
    }

    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('No Supabase user found');

      // ✅ Use upsert so it works for both new and existing users
      await Supabase.instance.client.from('profiles').upsert({
        'id': user.id,
        'email': widget.email,
        'full_name': _nameController.text.trim(),
        'age': age,
        'age_group': ageGroup,
        'experience_level': _experienceLevel,
        'preferred_session_length': _preferredSessionLength,
        'preferred_language': _preferredLanguage,
        'push_notifications_enabled': _pushNotifications,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile completed 🌿')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const turquoise = Color(0xFF40E0D0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF40E0D0), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Lottie.network(
                    'https://lottie.host/4d498849-4530-4e3f-8ccd-b236f1adfd5b/A0bBqkmU5s.json',
                    height: 180,
                    repeat: true,
                    animate: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Complete Your Profile 🌸',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Just a few quick details to personalize your yoga journey.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          icon: Icons.person_outline,
                          label: 'Full Name',
                          controller: _nameController,
                        ),
                        _buildTextField(
                          icon: Icons.cake_outlined,
                          label: 'Age',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          icon: Icons.fitness_center,
                          label: 'Experience Level',
                          value: _experienceLevel,
                          items: const ['Beginner', 'Intermediate', 'Advanced'],
                          onChanged: (v) => setState(() => _experienceLevel = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          icon: Icons.timer_outlined,
                          label: 'Session Length',
                          value: _preferredSessionLength,
                          items: const [
                            '5 minutes',
                            '10 minutes',
                            '15 minutes',
                            '20 minutes',
                            '30 minutes',
                            '45 minutes',
                            '60 minutes',
                          ],
                          onChanged: (v) => setState(() => _preferredSessionLength = v!),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          icon: Icons.language,
                          label: 'Preferred Language',
                          value: _preferredLanguage,
                          items: const ['English', 'Mandarin'],
                          onChanged: (v) => setState(() => _preferredLanguage = v!),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Enable Notifications',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Switch(
                              value: _pushNotifications,
                              onChanged: (v) =>
                                  setState(() => _pushNotifications = v),
                              activeThumbColor: turquoise,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: turquoise,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : _saveProfile,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    const turquoise = Color(0xFF40E0D0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: turquoise),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: turquoise),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    const turquoise = Color(0xFF40E0D0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(icon, color: turquoise),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
