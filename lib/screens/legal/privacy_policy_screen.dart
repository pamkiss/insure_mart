import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                    'Privacy Policy',
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
                      '1. Information We Collect',
                      'We collect personal information you provide when creating an account, including your name, email address, phone number, and date of birth. We also collect information related to your insurance applications and transactions.',
                    ),
                    _buildSection(
                      '2. How We Use Your Information',
                      'We use your information to provide and improve our services, process insurance applications, communicate with you about your policies, and comply with legal obligations. We may also use anonymized data for analytics.',
                    ),
                    _buildSection(
                      '3. Information Sharing',
                      'We share your information with insurance providers to process your applications and claims. We do not sell your personal information to third parties. We may share data with service providers who assist in operating our platform.',
                    ),
                    _buildSection(
                      '4. Data Security',
                      'We implement industry-standard security measures to protect your personal information, including encryption, secure data storage, and access controls. However, no method of transmission over the internet is 100% secure.',
                    ),
                    _buildSection(
                      '5. Your Rights',
                      'You have the right to access, correct, or delete your personal information. You can update your profile details in the app settings or contact our support team for assistance.',
                    ),
                    _buildSection(
                      '6. Cookies and Tracking',
                      'Our application may use local storage and analytics tools to improve your experience. You can manage these preferences in your device settings.',
                    ),
                    _buildSection(
                      '7. Data Retention',
                      'We retain your personal information for as long as your account is active or as needed to provide services. We may retain certain information as required by law or for legitimate business purposes.',
                    ),
                    _buildSection(
                      '8. Changes to This Policy',
                      'We may update this Privacy Policy from time to time. We will notify you of significant changes through the app or via email.',
                    ),
                    _buildSection(
                      '9. Contact Us',
                      'If you have questions about this Privacy Policy, please contact us at privacy@insuremart.ng or call +234 800 123 4567.',
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
