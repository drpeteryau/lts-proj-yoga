import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import '../services/global_audio_service.dart';
import 'package:flutter/foundation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
void initState() {
  super.initState();

  _validateResetToken();
}

void _validateResetToken() {
  if (!kIsWeb) return;

  final uri = Uri.base;

  final hasToken =
      uri.queryParameters.containsKey('code') ||
      uri.fragment.contains('access_token');

  final session = Supabase.instance.client.auth.currentSession;

  // Token missing OR token expired (no recovery session)
  if (!hasToken || session == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This reset link has expired. Please request a new one."),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    });
  }
}



  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;

  Future<void> _resetPassword() async {

    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {

     await Supabase.instance.client.auth.updateUser(
  UserAttributes(password: password),
);

await Supabase.instance.client.auth.signOut();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("Password updated successfully. Please log in again."),
  ),
);

if (kIsWeb) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );

} else {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );
}

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reset failed: $e")),
      );

    }
    finally {
      
  if (mounted) {
    setState(() => _isLoading = false);
  }
    }

  }

  Widget _buildField(
      IconData icon,
      String label,
      TextEditingController controller,
      {bool obscure = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
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

                const SizedBox(height: 40),

                Lottie.network(
                  'https://lottie.host/b882a045-2582-4815-90ce-0591a1d2434c/URk6v1m8VD.json',
                  height: 180,
                ),

                const SizedBox(height: 10),

                const Text(
                  "Reset Your Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter a new secure password",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
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
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      _buildField(
                        Icons.lock_outline,
                        "New Password",
                        _passwordController,
                        obscure: true,
                      ),

                      _buildField(
                        Icons.lock_outline,
                        "Confirm Password",
                        _confirmController,
                        obscure: true,
                      ),

                      const SizedBox(height: 20),

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

                          onPressed: _isLoading
                              ? null
                              : () async {
                            await GlobalAudioService.playClickSound();
                            _resetPassword();
                          },

                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "Update Password",
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

                const SizedBox(height: 60),

              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
void dispose() {
  _passwordController.dispose();
  _confirmController.dispose();
  super.dispose();
}
}