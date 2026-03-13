import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/url_helper.dart';
import '../../models/insurance_plan_model.dart';
import '../../routes/app_routes.dart';

class PackageDetailsScreen extends StatelessWidget {
  final InsurancePlanModel? plan;

  const PackageDetailsScreen({super.key, this.plan});

  @override
  Widget build(BuildContext context) {
    final displayPlan = plan;
    final company = displayPlan?.company ?? 'Custodian & Allied Insurance';
    final premium = displayPlan?.formattedPremium ?? 'N95,800/yr';
    final cover = displayPlan?.cover ?? 'N5M';
    final rating = displayPlan?.rating ?? 4.5;
    final features = displayPlan?.features ?? _defaultFeatures;
    final insuranceType = displayPlan?.insuranceType ?? 'motor';

    final title = insuranceType == 'health'
        ? 'Health Insurance Plan'
        : insuranceType == 'motor'
            ? 'Car Insurance Plan'
            : 'Insurance Plan';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header image area
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: AppColors.scaffoldBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,
                                color: AppColors.textDark),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Icon(
                              insuranceType == 'health'
                                  ? Icons.medical_services
                                  : insuranceType == 'motor'
                                      ? Icons.directions_car
                                      : Icons.shield,
                              size: 80,
                              color: AppColors.textGray.withAlpha(100),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            '$title - $cover Cover',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By $company',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                premium,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Rating
                          Row(
                            children: [
                              Text(
                                rating.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              ...List.generate(
                                5,
                                (i) => Icon(
                                  i < rating.floor()
                                      ? Icons.star
                                      : (i < rating.ceil()
                                          ? Icons.star_half
                                          : Icons.star_border),
                                  size: 16,
                                  color: const Color(0xFFFFC107),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Overview
                          Text(
                            'Overview',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            insuranceType == 'health'
                                ? 'This comprehensive health insurance plan provides coverage for hospitalization, medical expenses, and specialist consultations. It includes coverage for pre and post-hospitalization expenses and access to a wide network of hospitals.'
                                : 'Comprehensive Motor Insurance offers the Policyholder the widest range of motor insurance protection as it covers for damage or loss of the policyholder\'s vehicle and includes all the benefit of Third Party Motor Insurance policy. Towing fee is covered up to a maximum limit provided your car is towed to a nearest and reasonable place.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textGray,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Features
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  insuranceType == 'health'
                                      ? 'Features & Benefits of\nHealth Insurance Plan'
                                      : 'Features & Extent of Cover in\nComprehensive Motor Insurance',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...features.map((f) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        color: AppColors.accentCyan, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 24),

                          // Company Reviews
                          Text(
                            'Company Reviews',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildRatingBars(),
                          const SizedBox(height: 16),

                          // Review tabs
                          Row(
                            children: [
                              _buildTab('Most helpful', true),
                              const SizedBox(width: 12),
                              _buildTab('Recent', false),
                              const SizedBox(width: 12),
                              _buildTab('Critical', false),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Sample reviews
                          ..._reviews.map((r) => _buildReviewCard(r)),
                          const SizedBox(height: 8),

                          Center(
                            child: Text(
                              'View More Reviews',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => openUrl(context, 'tel:+2348001234567'),
                      icon: const Icon(Icons.call, size: 18),
                      label: Text('Call',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accentCyan,
                        side: const BorderSide(color: AppColors.accentCyan),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.checkout);
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: Text('Buy Insurance',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCyan,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBars() {
    final ratings = [
      {'stars': 5, 'count': 112},
      {'stars': 4, 'count': 30},
      {'stars': 3, 'count': 10},
      {'stars': 2, 'count': 45},
      {'stars': 1, 'count': 5},
    ];
    const total = 231;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: ratings.map((r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text(
                    '${r['stars']}',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textGray),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 120,
                    height: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (r['count'] as int) / total,
                        backgroundColor: AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation(AppColors.accentCyan),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${r['count']}',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Text(
              'Based on',
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textGray),
            ),
            Text(
              '$total Reviews',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentCyan,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentCyan : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.accentCyan : AppColors.borderLight,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: isActive ? Colors.white : AppColors.textGray,
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, String> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${review['rating']} out 5',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              ...List.generate(
                int.parse(review['rating']!),
                (_) => const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review['text']!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.accentCyan,
                child: Text(
                  review['name']![0],
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                review['name']!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Text(
                review['date']!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _defaultFeatures = [
    'Replacement cost or repair costs',
    'Medical Expenses',
    'Theft of the policyholder\'s vehicle',
    'Fire to the policyholder\'s vehicle',
    'Replacement Cost or repair costs',
    'Medical Expenses',
  ];

  static const _reviews = [
    {
      'rating': '5',
      'text':
          'Friendly and explained me very well about my problem. Even only by his words I feel better. Thanks Custodian.',
      'name': 'Justin Elone',
      'date': '14 Jun 2019',
    },
    {
      'rating': '4',
      'text':
          'Very friendly and time punctual and detail description of comprehensive motor insurance is very good and cooperative.',
      'name': 'Tosin Amuda',
      'date': '17 May 2020',
    },
  ];
}
