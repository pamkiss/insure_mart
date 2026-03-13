import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../models/user_model.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const CreateAccountScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _occupationController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _occupationController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = ref.read(authProvider);
    final user = UserModel(
      uid: auth.firebaseUser!.uid,
      fullName: _fullnameController.text,
      email: _emailController.text,
      username: _usernameController.text,
      phoneNumber: widget.phoneNumber,
      occupation: _occupationController.text,
      address: _addressController.text,
      dateOfBirth: _dobController.text,
      authMethod: 'phone',
      createdAt: DateTime.now(),
    );

    final success = await auth.createUserProfile(user);
    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRoutes.verifyEmail,
          arguments: {'email': _emailController.text});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(auth.errorMessage ?? 'Failed to create profile')),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.textLight,
              surface: AppColors.background,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'Get Started!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentCyan,
                    ),
                  ),
                  Text(
                    'Step 3 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textLight.withValues(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create your Account',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Fullname
                      CustomTextField(
                        hintText: 'Fullname',
                        controller: _fullnameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email
                      CustomTextField(
                        hintText: 'Email address',
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
                      // Username
                      CustomTextField(
                        hintText: 'Username',
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Occupation
                      CustomTextField(
                        hintText: 'Occupation',
                        controller: _occupationController,
                      ),
                      const SizedBox(height: 16),
                      // Residential address
                      CustomTextField(
                        hintText: 'Residential address',
                        controller: _addressController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Date of Birth
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            hintText: 'Date of Birth',
                            controller: _dobController,
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Create Account button
                      CustomButton(
                        text: 'Create Account',
                        onPressed: _onCreateAccount,
                        type: ButtonType.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
