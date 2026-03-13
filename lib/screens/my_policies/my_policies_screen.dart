import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/url_helper.dart';
import '../../models/insurance_policy_model.dart';
import '../../providers/providers.dart';

class MyPoliciesScreen extends ConsumerWidget {
  const MyPoliciesScreen({super.key});

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
                    'My Policies',
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
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load policies',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (policies) {
                  final withDocs = policies.where((p) => p.policyNumber != null).toList();
                  if (withDocs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.description_outlined,
                              size: 64, color: AppColors.textGray.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text(
                            'No policy documents',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: withDocs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _PolicyDocItem(policy: withDocs[index]);
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

class _PolicyDocItem extends StatelessWidget {
  final InsurancePolicyModel policy;

  const _PolicyDocItem({required this.policy});

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
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${policy.typeName} Policy',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  policy.policyNumber ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Issued: ${dateFormat.format(policy.startDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (policy.documentUrl != null &&
                  policy.documentUrl!.isNotEmpty) {
                openUrl(context, policy.documentUrl!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Policy document not yet available for download'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.download_outlined,
                color: AppColors.accentCyan, size: 24),
          ),
        ],
      ),
    );
  }
}
