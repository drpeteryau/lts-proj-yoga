import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lottie/lottie.dart';
import 'main_navigation_screen.dart';
import 'login_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  final String _experienceLevel = 'Beginner';
  String _preferredSessionLength = '15 minutes';
  String _preferredLanguage = 'English';
  bool _pushNotifications = true;
  bool _isLoading = false;

  // Current step in registration flow
  int _currentStep = 0;

  Future<void> _register() async {
    // Validate email
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errEmailEmpty)),
      );
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errEmailInvalid)),
      );
      return;
    }

    // Validate password
    final password = _passwordController.text;
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errPasswordEmpty)),
      );
      return;
    }

    // Password requirements validation
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 1 uppercase letter'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 1 lowercase letter'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain at least 1 number'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password must contain at least 1 special character (!@#\$%^&*...)'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final int? age = int.tryParse(_ageController.text.trim());

      if (age == null) {
        throw Exception('Please enter a valid age');
      }

      // Determine age group
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

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
      );

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      final user = response.user!;

      if (response.session == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please check your email to confirm your account'),
              duration: Duration(seconds: 5),
            ),
          );
          Navigator.pop(context);
        }
        return;
      }

      await Supabase.instance.client.from('profiles').insert({
        'id': user.id,
        'email': email,
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.welcomeName(_nameController.text.trim())),
            backgroundColor: const Color(0xFF40E0D0),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('❌ Registration failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextStep() {
    // Validate current step before proceeding
    if (_currentStep == 0) {
      // Step 1: Validate name and age
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errNameEmpty)),
        );
        return;
      }

      final age = int.tryParse(_ageController.text.trim());
      if (age == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errAgeEmpty)),
        );
        return;
      }

      if (age < 1 || age > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errAgeRange)),
        );
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
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
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Animated Lottie header based on step
                SizedBox(
                  height: 140,
                  child: _buildStepAnimation(),
                ),
                const SizedBox(height: 10),

                Text(
                  AppLocalizations.of(context)!.registerTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.registerSubtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),

                // Progress indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(0, AppLocalizations.of(context)!.stepPersonal),
                    _buildStepLine(0),
                    _buildStepIndicator(1, AppLocalizations.of(context)!.stepPreferences),
                    _buildStepLine(1),
                    _buildStepIndicator(2, AppLocalizations.of(context)!.stepAccount),
                  ],
                ),
                const SizedBox(height: 25),

                // White card with form
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _buildStepContent(),
                ),

                const SizedBox(height: 20),

                // Navigation buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  await GlobalAudioService.playClickSound();
                                  _previousStep();
                                },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.back,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                await GlobalAudioService.playClickSound();
                                _currentStep < 2 ? _nextStep() : _register();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: turquoise,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _currentStep < 2
                                    ? AppLocalizations.of(context)!.continueButton
                                    : AppLocalizations.of(context)!.createAccount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Link to login
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await GlobalAudioService.playClickSound();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                  child: Text(
                    AppLocalizations.of(context)!.alreadyHaveAccount,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepAnimation() {
    // You can use free Lottie files from https://lottiefiles.com
    // For now using placeholder URLs - replace with your actual Lottie files
    String animationUrl;
    switch (_currentStep) {
      case 0:
        // Personal info - person/profile animation
        return Lottie.network(
          'https://lottie.host/4d498849-4530-4e3f-8ccd-b236f1adfd5b/A0bBqkmU5s.json',
          fit: BoxFit.contain,
        );
      case 1:
        // Preferences - settings/yoga animation
        return Lottie.network(
          'https://lottie.host/30cd278d-76cf-45b1-b586-efce4269ff30/IgVs13JkK4.json',
          fit: BoxFit.contain,
        );
      case 2:
        // Account - security/lock animation
        return Lottie.network(
          'https://lottie.host/b882a045-2582-4815-90ce-0591a1d2434c/URk6v1m8VD.json',
          fit: BoxFit.contain,
        );
      default:
        return Lottie.network(
          'https://lottie.host/4f447e6f-2fd4-4d3d-bb0f-8185fbdaa182/1ZqHgsZMiH.json',
          fit: BoxFit.contain,
        );
    }
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? Colors.white : Colors.white38,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Color(0xFF40E0D0), size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color:
                          isActive ? const Color(0xFF40E0D0) : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? Colors.white : Colors.white38,
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildPreferencesStep();
      case 2:
        return _buildAccountStep();
      default:
        return _buildPersonalInfoStep();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.getToknowYou,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF40E0D0),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.tellUsAbout,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        _buildIconField(
          icon: Icons.person_outline,
          label: AppLocalizations.of(context)!.fullName,
          controller: _nameController,
          hint: AppLocalizations.of(context)!.nameHint,
        ),
        const SizedBox(height: 16),
        _buildIconField(
          icon: Icons.cake_outlined,
          label: AppLocalizations.of(context)!.age,
          controller: _ageController,
          hint: AppLocalizations.of(context)!.ageHint,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.yourPreferences,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF40E0D0),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.customizeYoga,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        _buildDropdownCard(
          icon: Icons.fitness_center,
          label: AppLocalizations.of(context)!.experienceLevel,
          // value: _experienceLevel,
          value: 'Beginner',
          items: const ['Beginner', 'Intermediate', 'Advanced'],
          // onChanged: (value) => setState(() => _experienceLevel = value!),
          onChanged: null,
        ),
        const SizedBox(height: 16),
        _buildDropdownCard(
          icon: Icons.timer_outlined,
          label: AppLocalizations.of(context)!.sessionLength,
          value: _preferredSessionLength,
          items: const [
            '5 minutes',
            '10 minutes',
            '15 minutes',
            '20 minutes',
            '30 minutes'
          ],
          onChanged: (value) =>
              setState(() => _preferredSessionLength = value!),
        ),
        const SizedBox(height: 16),
        _buildDropdownCard(
          icon: Icons.language,
          label: AppLocalizations.of(context)!.language,
          value: _preferredLanguage,
          items: const ['English', 'Mandarin'],
          onChanged: (value) => setState(() => _preferredLanguage = value!),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF40E0D0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF40E0D0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.enableNotifications,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
                activeThumbColor: const Color(0xFF40E0D0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.secureAccount,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF40E0D0),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.createCredentials,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 24),
        _buildIconField(
          icon: Icons.email_outlined,
          label: AppLocalizations.of(context)!.email,
          controller: _emailController,
          hint: AppLocalizations.of(context)!.emailHint,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildIconField(
          icon: Icons.lock_outline,
          label: AppLocalizations.of(context)!.password,
          controller: _passwordController,
          hint:
              AppLocalizations.of(context)!.passwordHint,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.passwordReqTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _buildPasswordRequirement(AppLocalizations.of(context)!.reqLength),
              _buildPasswordRequirement(AppLocalizations.of(context)!.reqUpper),
              _buildPasswordRequirement(AppLocalizations.of(context)!.reqLower),
              _buildPasswordRequirement(AppLocalizations.of(context)!.reqNumber),
              _buildPasswordRequirement(AppLocalizations.of(context)!.reqSpecial),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF40E0D0)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF40E0D0), width: 2.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownCard({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF40E0D0), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  items: items.map((item) {
                    String displayLabel;
                    // Map the internal value to the localized string
                    switch (item) {
                      case 'Beginner': displayLabel = AppLocalizations.of(context)!.beginner; break;
                      case '5 minutes': displayLabel = AppLocalizations.of(context)!.min5; break;
                      case '10 minutes': displayLabel = AppLocalizations.of(context)!.min10; break;
                      case '15 minutes': displayLabel = AppLocalizations.of(context)!.min15; break;
                      case '20 minutes': displayLabel = AppLocalizations.of(context)!.min20; break;
                      case '30 minutes': displayLabel = AppLocalizations.of(context)!.min30; break;
                      case 'English': displayLabel = AppLocalizations.of(context)!.english; break;
                      case 'Mandarin': displayLabel = AppLocalizations.of(context)!.mandarin; break;
                      default: displayLabel = item;
                    }

                    return DropdownMenuItem(value: item, child: Text(displayLabel));
                  }).toList(),
                  onChanged: _isLoading ? null : onChanged,
                  onTap: () async {
                    await GlobalAudioService.playClickSound();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
