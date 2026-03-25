import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final auth = ref.read(authProvider);
    final success = await auth.signInWithEmail(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.dashboard, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(auth.errorMessage ?? 'Login failed')),
      );
    }
  }

  void _onFacebookLogin() async {
    final auth = ref.read(authProvider);
    final success = await auth.signInWithFacebook();
    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.dashboard, (route) => false);
    }
  }

  void _onGoogleLogin() async {
    final auth = ref.read(authProvider);
    final success = await auth.signInWithGoogle();
    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.dashboard, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                'Welcome back!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 40),
              // Username
              CustomTextField(
                hintText: 'Email',
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password
              CustomTextField(
                hintText: 'Password',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Remember password & Forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberPassword,
                          onChanged: (value) {
                            setState(() {
                              _rememberPassword = value ?? false;
                            });
                          },
                          activeColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember password',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: Text(
                      'Forgot?',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Login button
              CustomButton(
                text: 'Log In',
                onPressed: _onLogin,
              ),
              const SizedBox(height: 30),
              // Social login
              Text(
                'Log in with',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSocialButton(
                    icon: Icons.facebook,
                    color: AppColors.facebookBlue,
                    onTap: _onFacebookLogin,
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: AppColors.googleRed,
                    onTap: _onGoogleLogin,
                    isGoogle: true,
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // Sign up link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have any account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.simpleSignUp);
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isGoogle = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: isGoogle
              ? Text(
                  'G',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                )
              : Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
        ),
      ),
    );
  }
}
