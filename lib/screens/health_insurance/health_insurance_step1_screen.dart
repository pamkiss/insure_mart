import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class HealthInsuranceStep1Screen extends ConsumerStatefulWidget {
  const HealthInsuranceStep1Screen({super.key});

  @override
  ConsumerState<HealthInsuranceStep1Screen> createState() =>
      _HealthInsuranceStep1ScreenState();
}

class _HealthInsuranceStep1ScreenState
    extends ConsumerState<HealthInsuranceStep1Screen> {
  String? _selectedGender;
  final _nameController = TextEditingController();
  String? _genderError;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    // Reset form when starting a new flow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(insuranceFormProvider.notifier).reset();
      ref.read(insuranceFormProvider.notifier).setInsuranceType('health');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _genderError = null;
      _nameError = null;

      if (_selectedGender == null) {
        _genderError = 'Please select your gender';
        valid = false;
      }
      if (_nameController.text.trim().isEmpty) {
        _nameError = 'Please enter your name';
        valid = false;
      } else if (_nameController.text.trim().length < 2) {
        _nameError = 'Name must be at least 2 characters';
        valid = false;
      }
    });
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  Text(
                    'Step 1 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Let us help you find the right health plan for you!',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Gender selection
                    Text(
                      'Select your Gender',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderCard(
                            label: 'Male',
                            icon: Icons.male,
                            color: AppColors.accentCyan,
                            isSelected: _selectedGender == 'Male',
                            onTap: () =>
                                setState(() {
                                  _selectedGender = 'Male';
                                  _genderError = null;
                                }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderCard(
                            label: 'Female',
                            icon: Icons.female,
                            color: const Color(0xFFFF7043),
                            isSelected: _selectedGender == 'Female',
                            onTap: () =>
                                setState(() {
                                  _selectedGender = 'Female';
                                  _genderError = null;
                                }),
                          ),
                        ),
                      ],
                    ),
                    if (_genderError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _genderError!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: 28),

                    // Name input
                    Text(
                      'Your Name',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) {
                        if (_nameError != null) setState(() => _nameError = null);
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g John Smith',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                        errorText: _nameError,
                        filled: true,
                        fillColor: AppColors.scaffoldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.borderLight),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Proceed button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Proceed',
                type: ButtonType.secondary,
                onPressed: () {
                  if (_validate()) {
                    final notifier = ref.read(insuranceFormProvider.notifier);
                    notifier.setGender(_selectedGender!);
                    notifier.setFullName(_nameController.text.trim());
                    Navigator.pushNamed(context, AppRoutes.healthInsuranceStep2);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
