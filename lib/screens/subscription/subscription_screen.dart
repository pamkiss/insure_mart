import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 1;

  final _plans = [
    {'duration': '3 Months', 'oldPrice': 'N9,999', 'price': 'N6,999'},
    {'duration': '6 Months', 'oldPrice': 'N19,999', 'price': 'N9,999'},
    {'duration': '12 Months', 'oldPrice': 'N39,999', 'price': 'N19,999'},
  ];

  final _benefits = [
    '60% off on all insurance',
    'Access to top insurance from best coys.',
    '50+ Specialities covered',
    'Free follow up up to 5 days at office or online',
    'Covers up to 6 members of the family',
    'Unique pay per use healthcare membership',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero header
                  _buildHeroHeader(context),

                  // Select Plans
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Plans',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPlanCards(),
                        const SizedBox(height: 28),

                        // What you will get
                        Text(
                          'What you will get',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._benefits.map((b) => _buildBenefitItem(b)),
                        const SizedBox(height: 28),

                        // Top Hospitals
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Top Hospitals',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              'Add New',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildHospitalLogos(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Proceed to Pay button
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              text: 'Proceed to Pay',
              type: ButtonType.secondary,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0288D1),
            Color(0xFF0277BD),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(
            'InsureMart Subscription',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withAlpha(200),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Get 60% off all\ninsurance starting @\njust N6,999',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCards() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _plans.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final plan = _plans[index];
          final isSelected = index == _selectedPlanIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedPlanIndex = index),
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentCyan
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentCyan
                      : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan['duration']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textGray,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              size: 14, color: AppColors.accentCyan),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    plan['oldPrice']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withAlpha(180)
                          : AppColors.textGray,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    plan['price']!,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalLogos() {
    return Row(
      children: [
        _buildHospitalIcon(Icons.local_hospital, const Color(0xFF0288D1)),
        const SizedBox(width: 16),
        _buildHospitalIcon(Icons.medical_services, const Color(0xFFFF7043)),
        const SizedBox(width: 16),
        _buildHospitalIcon(Icons.health_and_safety, const Color(0xFF4CAF50)),
      ],
    );
  }

  Widget _buildHospitalIcon(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
