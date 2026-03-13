import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/insurance_policy_model.dart';
import '../../providers/providers.dart';

class MyInsuranceScreen extends ConsumerWidget {
  const MyInsuranceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policiesAsync = ref.watch(userPoliciesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.textDark, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'My Insurance',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: policiesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Failed to load policies',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (policies) {
                  if (policies.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.policy_outlined,
                              size: 64, color: AppColors.textGray.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text(
                            'No insurance policies yet',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Browse plans to get started',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: policies.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _PolicyCard(policy: policies[index]);
                    },
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

class _PolicyCard extends StatelessWidget {
  final InsurancePolicyModel policy;

  const _PolicyCard({required this.policy});

  IconData get _icon {
    switch (policy.type) {
      case InsuranceType.health:
        return Icons.medical_services_outlined;
      case InsuranceType.car:
        return Icons.directions_car_outlined;
      case InsuranceType.bike:
        return Icons.two_wheeler_outlined;
      case InsuranceType.termPlan:
        return Icons.umbrella_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = policy.status == PolicyStatus.active;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final coverageFormatted = policy.coverageAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.primaryBlue, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.typeName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  policy.provider,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Coverage: N$coverageFormatted',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Expires: ${dateFormat.format(policy.expiryDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.green.withAlpha(25)
                  : AppColors.error.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              policy.statusName,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
