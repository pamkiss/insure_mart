import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class HealthInsuranceStep2Screen extends ConsumerStatefulWidget {
  const HealthInsuranceStep2Screen({super.key});

  @override
  ConsumerState<HealthInsuranceStep2Screen> createState() =>
      _HealthInsuranceStep2ScreenState();
}

class _HealthInsuranceStep2ScreenState
    extends ConsumerState<HealthInsuranceStep2Screen> {
  final Map<String, bool> _members = {
    'Self': true,
    'Spouse': true,
    'Child': false,
    'Mother': false,
    'Father': false,
  };
  String? _error;

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
                    'Step 2 of 4',
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
                      'Who all you want to cover in health insurance',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Select Members',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Members list
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: _members.entries.map((entry) {
                          final isLast = entry.key == _members.keys.last;
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _members[entry.key] = !entry.value;
                                    _error = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: entry.value
                                              ? AppColors.accentCyan
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: entry.value
                                                ? AppColors.accentCyan
                                                : AppColors.borderLight,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: entry.value
                                            ? const Icon(Icons.check,
                                                size: 16, color: Colors.white)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast)
                                const Divider(height: 0, indent: 20, endIndent: 20),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.error,
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
                  final selected = _members.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  if (selected.isEmpty) {
                    setState(() => _error = 'Please select at least one member');
                    return;
                  }

                  ref.read(insuranceFormProvider.notifier).setSelectedMembers(selected);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.healthInsuranceStep3,
                    arguments: {'members': selected},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
