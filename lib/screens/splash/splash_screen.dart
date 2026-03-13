import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated) {
        // Initialize push notifications for authenticated user
        final notificationService = ref.read(notificationServiceProvider);
        await notificationService.initialize(auth.firebaseUser?.uid);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: _buildLogo(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Brand name
                    Text(
                      'insuremart',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    // Stylized "i" logo with person figure
    return CustomPaint(
      size: const Size(60, 80),
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

    // Draw the head (circle)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.12),
      size.width * 0.15,
      darkBluePaint,
    );

    // Draw the body (rounded rectangle)
    final bodyPath = Path();
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.28,
        size.width * 0.4,
        size.height * 0.65,
      ),
      const Radius.circular(12),
    );
    bodyPath.addRRect(bodyRect);
    canvas.drawPath(bodyPath, darkBluePaint);

    // Draw the cape/accent (curved shape on the right)
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
