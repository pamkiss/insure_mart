import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Terms & Conditions',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      '1. Acceptance of Terms',
                      'By accessing and using the InsureMart mobile application, you accept and agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use this application.',
                    ),
                    _buildSection(
                      '2. Use of Service',
                      'InsureMart provides a digital marketplace for insurance products. You agree to use the service only for lawful purposes and in accordance with these Terms. You must be at least 18 years old to use this service.',
                    ),
                    _buildSection(
                      '3. User Account',
                      'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.',
                    ),
                    _buildSection(
                      '4. Insurance Products',
                      'Insurance products listed on InsureMart are provided by licensed insurance companies. InsureMart acts as an intermediary and does not underwrite any insurance policies. All insurance terms, conditions, and coverage are determined by the respective insurance providers.',
                    ),
                    _buildSection(
                      '5. Payment Terms',
                      'All payments made through the application are processed securely. Premium amounts, coverage details, and payment schedules are as specified in your chosen insurance policy. Refund policies vary by insurance provider.',
                    ),
                    _buildSection(
                      '6. Privacy',
                      'Your use of InsureMart is also governed by our Privacy Policy. By using our service, you consent to the collection and use of information as detailed in the Privacy Policy.',
                    ),
                    _buildSection(
                      '7. Limitation of Liability',
                      'InsureMart shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
                    ),
                    _buildSection(
                      '8. Changes to Terms',
                      'InsureMart reserves the right to modify these terms at any time. Continued use of the application after changes constitutes acceptance of the modified terms.',
                    ),
                    _buildSection(
                      '9. Contact Information',
                      'For questions about these Terms & Conditions, please contact us at legal@insuremart.ng or call +234 800 123 4567.',
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Last updated: March 2026',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textGray,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
