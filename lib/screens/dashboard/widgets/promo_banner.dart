import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback? onViewPlans;

  const PromoBanner({
    super.key,
    this.onViewPlans,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.promoBannerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exclusively on InsureMart',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greetingOrange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Save up to 80% on\nHome Insurance',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Starting @ N19,999',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onViewPlans,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'View Plans',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/promo_illustration.png',
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
