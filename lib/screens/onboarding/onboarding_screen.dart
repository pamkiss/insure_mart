import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Comprehensive Coverage',
      subtitle: 'Get the best insurance plans tailored for your needs',
      icon: Icons.shield_outlined,
    ),
    OnboardingContent(
      title: 'True Customer\nCentricity',
      subtitle: 'We are committed to providing superior customer experience',
      icon: Icons.people_outline,
    ),
    OnboardingContent(
      title: 'Faster Claims\nSettlement',
      subtitle: 'We settle your all your claims between 10-30 minutes',
      icon: Icons.speed_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToPhoneSignIn();
    }
  }

  void _navigateToPhoneSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.phoneSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative dots
            ..._buildDecorativeDots(),
            // Main content
            Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: _navigateToPhoneSignIn,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textLight.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _contents.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_contents[index]);
                    },
                  ),
                ),
                // Page indicator
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _contents.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      expansionFactor: 3,
                      spacing: 6,
                      dotColor: AppColors.textLight.withValues(alpha: 0.3),
                      activeDotColor: AppColors.textLight,
                    ),
                  ),
                ),
                // Next/Get Started button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  child: CustomButton(
                    text: _currentPage == _contents.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _onNextPressed,
                    type: ButtonType.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                content.icon,
                size: 80,
                color: AppColors.textLight,
              ),
            ),
          ),
          const SizedBox(height: 60),
          // Title
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textLight.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecorativeDots() {
    return [
      _buildDot(top: 100, left: 30, size: 6, opacity: 0.3),
      _buildDot(top: 150, left: 80, size: 4, opacity: 0.5),
      _buildDot(top: 200, right: 50, size: 8, opacity: 0.2),
      _buildDot(top: 280, left: 120, size: 5, opacity: 0.4),
      _buildDot(top: 320, right: 100, size: 6, opacity: 0.3),
      _buildDot(top: 400, left: 40, size: 4, opacity: 0.5),
      _buildDot(top: 350, right: 30, size: 7, opacity: 0.2),
      _buildDot(bottom: 300, left: 60, size: 5, opacity: 0.4, isCyan: true),
      _buildDot(bottom: 250, right: 80, size: 6, opacity: 0.5, isCyan: true),
    ];
  }

  Widget _buildDot({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
    bool isCyan = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isCyan ? AppColors.accentCyan : AppColors.textLight)
              .withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
