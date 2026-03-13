import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class PhoneSignInScreen extends ConsumerStatefulWidget {
  const PhoneSignInScreen({super.key});

  @override
  ConsumerState<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends ConsumerState<PhoneSignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+234';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_phoneController.text.isEmpty) return;
    final phone = '$_selectedCountryCode${_phoneController.text}';
    final auth = ref.read(authProvider);

    final success = await auth.verifyPhoneNumber(phone);

    if (!mounted) return;
    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,
        arguments: {'phoneNumber': phone},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Phone verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: _buildLogo(),
                ),
              ),
              const SizedBox(height: 16),
              // Brand name
              Text(
                'insuremart',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const Spacer(),
              // Phone input
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Country code dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          items: ['+234', '+1', '+44', '+91']
                              .map((code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(
                                      code,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryCode = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      height: 30,
                      width: 1,
                      color: AppColors.borderLight,
                    ),
                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          hintText: '805 174 2253',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textGray,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    // Submit button
                    GestureDetector(
                      onTap: _onSubmit,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.textLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Sign up later
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.dashboard, (route) => false);
                },
                child: Text(
                  'I will Sign up Later',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Terms
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                  children: [
                    const TextSpan(text: 'By Continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return CustomPaint(
      size: const Size(50, 65),
      painter: LogoPainter(),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint darkBluePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.fill;

    final Paint cyanPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.12),
      size.width * 0.15,
      darkBluePaint,
    );

    final bodyPath = Path();
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.28,
        size.width * 0.4,
        size.height * 0.65,
      ),
      const Radius.circular(10),
    );
    bodyPath.addRRect(bodyRect);
    canvas.drawPath(bodyPath, darkBluePaint);

    final capePath = Path();
    capePath.moveTo(size.width * 0.5, size.height * 0.35);
    capePath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.5,
      size.width * 0.65,
      size.height * 0.85,
    );
    capePath.lineTo(size.width * 0.5, size.height * 0.85);
    capePath.close();
    canvas.drawPath(capePath, cyanPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
