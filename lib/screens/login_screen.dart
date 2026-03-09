import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('invalid login credentials') ||
        errorString.contains('invalid_credentials') ||
        errorString.contains('statuscode: 400')) {
      return AppLocalizations.of(context)!.invalidCredentials;
    } else if (errorString.contains('email not confirmed') ||
        errorString.contains('email_not_confirmed')) {
      return AppLocalizations.of(context)!.emailNotVerified;
    } else if (errorString.contains('user not found') ||
        errorString.contains('user_not_found')) {
      return AppLocalizations.of(context)!.accountNotFound;
    } else if (errorString.contains('too many requests') ||
        errorString.contains('rate limit')) {
      return AppLocalizations.of(context)!.tooManyAttempts;
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      return AppLocalizations.of(context)!.networkError;
    } else {
      return AppLocalizations.of(context)!.unknownError;
    }
  }

  // ✅ Normal email-password login
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fillRequiredFields)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      if (response.session == null) throw Exception('Invalid credentials');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginSuccess)),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changeLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                appLocale.value = const Locale('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('简体中文'),
              onTap: () {
                appLocale.value = const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hans',
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('繁體中文'),
              onTap: () {
                appLocale.value = const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant',
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
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
          child: Stack(
              children: [
          // Main content
          SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Lottie.network(
                  'https://lottie.host/30cd278d-76cf-45b1-b586-efce4269ff30/IgVs13JkK4.json',
                  height: 200,
                  repeat: true,
                  animate: true,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.loginSubtitle,
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
                      _buildField(
                        Icons.email_outlined,
                        AppLocalizations.of(context)!.email,
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildField(
                        Icons.lock_outline,
                        AppLocalizations.of(context)!.password,
                        _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      // 🌿 Normal Log In Button
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
                          onPressed: _isLoading ? null : () async {
                            await GlobalAudioService.playClickSound();
                            _login();
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            AppLocalizations.of(context)!.logIn,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 12),

                      // Forgot Password Link
                      TextButton(
                        onPressed: () {
                          GlobalAudioService.playClickSound();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () {
                          GlobalAudioService.playClickSound();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.dontHaveAccount,
                          style: TextStyle(
                            color: turquoise,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),

          // Language selector button (top right) - positioned AFTER content for proper z-index
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  print('Language button tapped!'); // Debug
                  GlobalAudioService.playClickSound();
                  _showLanguageDialog();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          ]),
        ),
      ),
    );
  }

  Widget _buildField(
      IconData icon, String label, TextEditingController controller,
      {bool obscureText = false,
        TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF40E0D0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF40E0D0)),
          ),
        ),
      ),
    );
  }
}