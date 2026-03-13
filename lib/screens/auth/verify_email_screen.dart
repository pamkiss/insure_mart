import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class VerifyEmailScreen extends ConsumerWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verify Email',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    'Step 4 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Message
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textGray,
                        ),
                        children: [
                          const TextSpan(
                              text:
                                  'Please click the link we sent to your email address '),
                          TextSpan(
                            text: email,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const Spacer(),
                    // Email illustration
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Envelope
                              Container(
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              // Envelope flap
                              Positioned(
                                top: 60,
                                child: CustomPaint(
                                  size: const Size(120, 40),
                                  painter: EnvelopeFlapPainter(),
                                ),
                              ),
                              // Letter
                              Positioned(
                                top: 40,
                                child: Container(
                                  width: 100,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppColors.textGray
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 50,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppColors.textGray
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 60,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: AppColors.textGray
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Resend link
                    Text(
                      "Didn't receive the link?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        ref.read(authProvider).sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Verification email sent')),
                        );
                      },
                      child: Text(
                        'Resend link',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Continue button (for demo purposes)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to dashboard
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.dashboard,
                            (route) => false,
                          );
                        },
                        child: Text(
                          'I have verified my email',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.accentCyan,
                            fontWeight: FontWeight.w500,
                          ),
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

class EnvelopeFlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
