import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/url_helper.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
                    'About Us',
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          'iM',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'InsureMart',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Our Mission',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'InsureMart is a digital insurance marketplace that makes it simple for Nigerians to discover, compare, and purchase insurance products. We believe everyone deserves accessible and affordable insurance protection.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textGray,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Us',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            text: '14 Victoria Island, Lagos, Nigeria',
                            onTap: () => openUrl(context,
                                'https://www.google.com/maps/search/14+Victoria+Island+Lagos+Nigeria'),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            text: 'info@insuremart.ng',
                            onTap: () => openUrl(context,'mailto:info@insuremart.ng'),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            text: '+234 800 123 4567',
                            onTap: () => openUrl(context,'tel:+2348001234567'),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.language,
                            text: 'www.insuremart.ng',
                            onTap: () =>
                                openUrl(context,'https://www.insuremart.ng'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Social media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialIcon(
                          icon: Icons.facebook,
                          onTap: () => openUrl(context,
                              'https://www.facebook.com/insuremart'),
                        ),
                        const SizedBox(width: 20),
                        _SocialIcon(
                          icon: Icons.close,
                          onTap: () =>
                              openUrl(context,'https://x.com/insuremart'),
                        ),
                        const SizedBox(width: 20),
                        _SocialIcon(
                          icon: Icons.camera_alt_outlined,
                          onTap: () => openUrl(context,
                              'https://www.instagram.com/insuremart'),
                        ),
                        const SizedBox(width: 20),
                        _SocialIcon(
                          icon: Icons.link,
                          onTap: () => openUrl(context,
                              'https://www.linkedin.com/company/insuremart'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '\u00a9 2026 InsureMart. All rights reserved.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGray,
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
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _InfoRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentCyan, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: onTap != null ? AppColors.accentCyan : AppColors.textGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SocialIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 22),
      ),
    );
  }
}
