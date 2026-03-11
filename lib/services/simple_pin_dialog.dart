import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/simple_pin_service.dart';
import '../services/global_audio_service.dart';
import '../l10n/app_localizations.dart';

class SimplePinDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  const SimplePinDialog({super.key, required this.onSuccess});

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
    final width = MediaQuery.of(context).size.width;
    final isSmallPhone = width < 360;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsets.all(isSmallPhone ? 20 : 28),
          child: _buildContent(isSmallPhone),
        ),
      ),
    );
  }

  Widget _buildContent(bool isSmallPhone) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF40E0D0).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 40,
            color: Color(0xFF40E0D0),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          AppLocalizations.of(context)!.enterPinCode,
          style: GoogleFonts.poppins(
            fontSize: isSmallPhone ? 20 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          AppLocalizations.of(context)!.pinInstructions,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: isSmallPhone ? 13 : 14,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 24),

        _buildPinDots(),

        if (_isError) ...[
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.incorrectPin,
            style: GoogleFonts.poppins(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        const SizedBox(height: 24),

        _buildKeypad(isSmallPhone),
      ],
    );
  }

  Widget _buildPinDots() {
    final width = MediaQuery.of(context).size.width;
    final isSmallPhone = width < 360;

    final dotSize = isSmallPhone ? 14.0 : 16.0;
    final spacing = isSmallPhone ? 6.0 : 8.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      transform: Matrix4.translationValues(
        _isError ? 6 : 0,
        0,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: spacing),
            width: dotSize,
            height: dotSize,
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
    );
  }

  Widget _buildKeypad(bool isSmallPhone) {
    return Column(
      children: [
        _buildNumberRow(['1','2','3'], isSmallPhone),
        const SizedBox(height: 10),
        _buildNumberRow(['4','5','6'], isSmallPhone),
        const SizedBox(height: 10),
        _buildNumberRow(['7','8','9'], isSmallPhone),
        const SizedBox(height: 10),
        _buildNumberRow(['','0','⌫'], isSmallPhone),
      ],
    );
  }

  Widget _buildNumberRow(List<String> numbers, bool isSmallPhone) {
    final size = isSmallPhone ? 60.0 : 70.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {

        if (number.isEmpty) {
          return SizedBox(width: size);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
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
              borderRadius: BorderRadius.circular(size),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _isVerifying
                      ? Colors.grey[200]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(size),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallPhone ? 20 : 24,
                      fontWeight: FontWeight.w600,
                      color: _isVerifying
                          ? Colors.grey[400]
                          : Colors.black87,
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
