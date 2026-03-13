import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends ConsumerState<ForgotPasswordOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 120; // 2 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    return '0${phone.substring(1, 2)}${'x' * (phone.length - 4)}${phone.substring(phone.length - 2)}';
  }

  bool _isVerifying = false;

  void _onSubmitCode() async {
    if (_otpController.text.length != 6) return;

    setState(() => _isVerifying = true);

    final auth = ref.read(authProvider);
    final success = await auth.verifyOtp(_otpController.text);

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (success) {
      Navigator.pushNamed(context, AppRoutes.createNewPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Invalid verification code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendCode() async {
    final auth = ref.read(authProvider);
    await auth.verifyPhoneNumber(widget.phoneNumber);
    if (!mounted) return;
    setState(() {
      _remainingSeconds = 120;
    });
    _timer?.cancel();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textDark,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                'Enter the verify code',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                'We just send you a verify code via a phone ${_maskPhoneNumber(widget.phoneNumber)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  showCursor: true,
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 2,
                        height: 22,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Submit button
              CustomButton(
                text: _isVerifying ? 'Verifying...' : 'Submit Code',
                onPressed: _isVerifying ? null : _onSubmitCode,
              ),
              const SizedBox(height: 20),
              // Timer
              Center(
                child: Text(
                  'The verify code will be expire in ${_formatTime(_remainingSeconds)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textGray,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Resend code
              Center(
                child: GestureDetector(
                  onTap: _remainingSeconds == 0 ? _resendCode : null,
                  child: Text(
                    'Resend code',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _remainingSeconds == 0
                          ? AppColors.accentCyan
                          : AppColors.textGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
