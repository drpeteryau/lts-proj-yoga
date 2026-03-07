import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/simple_pin_service.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

class SimplePinDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const SimplePinDialog({Key? key, required this.onSuccess}) : super(key: key);

  @override
  State<SimplePinDialog> createState() => _SimplePinDialogState();
}

class _SimplePinDialogState extends State<SimplePinDialog> {
  String _enteredPin = '';
  bool _isError = false;
  bool _isVerifying = false;

  void _onNumberPressed(String number) {
    if (_isVerifying) return;

    GlobalAudioService.playClickSound();

    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += number;
        _isError = false;
      });

      // Auto-verify when 4 digits entered
      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_isVerifying) return;

    GlobalAudioService.playClickSound();

    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    setState(() {
      _isVerifying = true;
    });

    final isCorrect = await SimplePinService.verifyPin(_enteredPin);

    if (!mounted) return;

    if (isCorrect) {
      // Correct PIN!
      GlobalAudioService.playClickSound();
      Navigator.pop(context);
      widget.onSuccess();
    } else if (SimplePinService.isBackdoorPin(_enteredPin)) {
      // Backdoor PIN - show settings
      GlobalAudioService.playClickSound();
      Navigator.pop(context);
      _showBackdoorSettings();
    } else {
      // Wrong PIN - shake and reset
      setState(() {
        _isError = true;
        _enteredPin = '';
        _isVerifying = false;
      });

      // Reset error state after animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isError = false;
          });
        }
      });
    }
  }

  void _showBackdoorSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.backdoorAccess,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.backdoorAdminMsg,
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.backdoorPathInstructions,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: GoogleFonts.poppins(
                color: const Color(0xFF40E0D0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lock icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF40E0D0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 48,
                color: Color(0xFF40E0D0),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              AppLocalizations.of(context)!.enterPinCode,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppLocalizations.of(context)!.pinInstructions,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 32),

            // PIN dots with shake animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.translationValues(
                _isError ? (DateTime.now().millisecond % 2 == 0 ? -5 : 5) : 0,
                0,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isError
                          ? Colors.red
                          : index < _enteredPin.length
                          ? const Color(0xFF40E0D0)
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
            ),

            if (_isError) ...[
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.incorrectPin,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Number pad
            Column(
              children: [
                _buildNumberRow(['1', '2', '3']),
                const SizedBox(height: 12),
                _buildNumberRow(['4', '5', '6']),
                const SizedBox(height: 12),
                _buildNumberRow(['7', '8', '9']),
                const SizedBox(height: 12),
                _buildNumberRow(['', '0', '⌫']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const SizedBox(width: 72);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isVerifying
                  ? null
                  : () {
                      if (number == '⌫') {
                        _onBackspace();
                      } else {
                        _onNumberPressed(number);
                      }
                    },
              borderRadius: BorderRadius.circular(36),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _isVerifying ? Colors.grey[200] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: _isVerifying ? Colors.grey[400] : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
