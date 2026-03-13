import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpComplete(String otp) async {
    if (otp.length != 4) return;
    final auth = ref.read(authProvider);
    final success = await auth.verifyOtp(otp);

    if (!mounted) return;
    if (success) {
      if (auth.userModel != null) {
        // Existing user — go straight to dashboard
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.dashboard, (_) => false);
      } else {
        // New user — needs profile
        Navigator.pushNamed(context, AppRoutes.createAccount,
            arguments: {'phoneNumber': widget.phoneNumber});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Invalid OTP')),
      );
      _otpController.clear();
    }
  }

  String _maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    return phone.substring(0, phone.length - 4).replaceAll(RegExp(r'\d'), 'x') +
        phone.substring(phone.length - 4);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 70,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 24,
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
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verify OTP',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    'Step 2 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Message
                    Text(
                      'We have sent an OTP to your mobile number',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _maskPhoneNumber(widget.phoneNumber),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Change',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // OTP Input
                    Center(
                      child: Pinput(
                        controller: _otpController,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        onCompleted: _onOtpComplete,
                        showCursor: true,
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 2,
                              height: 24,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Resend code
                    Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(authProvider)
                            .verifyPhoneNumber(widget.phoneNumber);
                      },
                      child: Text(
                        'Resend code',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
