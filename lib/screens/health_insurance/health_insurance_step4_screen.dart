import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class HealthInsuranceStep4Screen extends ConsumerWidget {
  const HealthInsuranceStep4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(insuranceFormProvider);

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
                    'Step 4 of 4',
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
                      'Review your details',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please confirm the information below before viewing plans.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Summary card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow('Insurance Type', 'Health Insurance'),
                          const Divider(height: 24),
                          _buildRow('Name', formData.fullName ?? '-'),
                          const Divider(height: 24),
                          _buildRow('Gender', formData.gender ?? '-'),
                          const Divider(height: 24),
                          _buildRow(
                            'Members',
                            formData.selectedMembers.isEmpty
                                ? '-'
                                : formData.selectedMembers.join(', '),
                          ),
                          if (formData.memberAges.isNotEmpty) ...[
                            const Divider(height: 24),
                            Text(
                              'Member Ages',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...formData.memberAges.entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '  ${e.key}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    Text(
                                      '${e.value ?? "-"} years',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Proceed button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: CustomButton(
                text: 'View Plans',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.insuranceQuotes);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
