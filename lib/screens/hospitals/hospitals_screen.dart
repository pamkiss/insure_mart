import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/hospital_model.dart';
import '../../providers/providers.dart';

class HospitalsScreen extends ConsumerWidget {
  const HospitalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitalsAsync = ref.watch(hospitalsProvider);

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
                    'Partner Hospitals',
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
              child: hospitalsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load hospitals',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (hospitals) {
                  if (hospitals.isEmpty) {
                    return Center(
                      child: Text(
                        'No hospitals available',
                        style: GoogleFonts.poppins(color: AppColors.textGray),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: hospitals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _HospitalCard(hospital: hospitals[index]);
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

class _HospitalCard extends StatelessWidget {
  final HospitalModel hospital;

  const _HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_hospital,
                    color: AppColors.accentCyan, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            i < hospital.rating.floor()
                                ? Icons.star
                                : (i < hospital.rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                            color: AppColors.greetingOrange,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          '${hospital.rating}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.textGray, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hospital.address,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textGray),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  color: AppColors.textGray, size: 16),
              const SizedBox(width: 4),
              Text(
                hospital.phone,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textGray),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
