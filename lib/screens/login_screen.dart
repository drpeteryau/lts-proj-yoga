import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';
import 'complete_profile_screen.dart';
import '../services/global_audio_service.dart';

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

  // ✅ Normal email-password login
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
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
          const SnackBar(content: Text('Welcome back 🌿')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      if (kIsWeb) {
        // Web: use Supabase's redirect-based OAuth.
        // google_sign_in's signIn() can't reliably return an idToken on web,
        // and it sends a redirect_uri that doesn't match what Google expects.
        // Supabase handles the full OAuth dance server-side and redirects back.
        await Supabase.instance.client.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: '${Uri.base.origin}',
        );
        // Browser redirects away - AuthGate's onAuthStateChange picks up the
        // new session when the page reloads back here.
        return;
      }

      // Native: existing google_sign_in flow (works fine on Android/iOS)
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
        '337226396229-ns81hak1k1v6vbseb7e4r1n3tokcm9p7.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // user canceled
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Missing Google Auth Token');
      }

      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.session == null) {
        throw Exception('No session returned from Supabase');
      }

      final user = response.session!.user;

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      final bool isIncomplete = data == null ||
          data['full_name'] == null ||
          (data['full_name'] as String).trim().isEmpty ||
          data['age'] == null;

      if (!mounted) return;

      if (isIncomplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompleteProfileScreen(
              fullName: googleUser.displayName ?? '',
              email: googleUser.email,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
      if (mounted) setState(() => _isLoading = false);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                  const SizedBox(height: 40),
                  Lottie.network(
                    'https://lottie.host/30cd278d-76cf-45b1-b586-efce4269ff30/IgVs13JkK4.json',
                    height: 200,
                    repeat: true,
                    animate: true,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome Back 🧘‍♀️',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Log in to continue your healing journey.',
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
                          'Email',
                          _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildField(
                          Icons.lock_outline,
                          'Password',
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
                                : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // 🌸 Google Sign-In Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            icon: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ),
                            ),
                            label: const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : () async {
                              await GlobalAudioService.playClickSound();
                              _signInWithGoogle();
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: () {
                            GlobalAudioService.playClickSound();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Register",
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