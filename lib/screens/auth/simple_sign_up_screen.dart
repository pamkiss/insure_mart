import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class SimpleSignUpScreen extends ConsumerStatefulWidget {
  const SimpleSignUpScreen({super.key});

  @override
  ConsumerState<SimpleSignUpScreen> createState() => _SimpleSignUpScreenState();
}

class _SimpleSignUpScreenState extends ConsumerState<SimpleSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeToPrivacy = true;
  String? _usernameError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    setState(() {
      _usernameError = null;
    });

    if (!_formKey.currentState!.validate() || !_agreeToPrivacy) return;

    final auth = ref.read(authProvider);
    final success = await auth.signUpWithEmail(
      _emailController.text,
      _passwordController.text,
      _usernameController.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.dashboard, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(auth.errorMessage ?? 'Sign up failed')),
      );
    }
  }

  void _onFacebookSignUp() async {
    final auth = ref.read(authProvider);
    final success = await auth.signInWithFacebook();
    if (!mounted) return;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.dashboard, (route) => false);
    }
  }

  void _onGoogleSignUp() async {
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
          child: Form(
            key: _formKey,
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
                  'Create your account',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 40),
                // Username
                CustomTextField(
                  hintText: 'Username',
                  controller: _usernameController,
                  errorText: _usernameError,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Privacy policy checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToPrivacy,
                        onChanged: (value) {
                          setState(() {
                            _agreeToPrivacy = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                        children: [
                          const TextSpan(text: 'I agree with '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Sign up button
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _onSignUp,
                ),
                const SizedBox(height: 30),
                // Social signup
                Text(
                  'Register with',
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
                      onTap: _onFacebookSignUp,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      color: AppColors.googleRed,
                      onTap: _onGoogleSignUp,
                      isGoogle: true,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Login link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          'Sign In',
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
