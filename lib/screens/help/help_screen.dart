import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/url_helper.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                    '24x7 Help',
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.support_agent,
                              color: Colors.white, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Need Help?',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Our team is available 24/7 to assist you',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ContactButton(
                                  icon: Icons.phone,
                                  label: 'Call Us',
                                  detail: '+234 800 123 4567',
                                  onTap: () => openUrl(context,'tel:+2348001234567'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ContactButton(
                                  icon: Icons.email,
                                  label: 'Email',
                                  detail: 'help@insuremart.ng',
                                  onTap: () =>
                                      openUrl(context,'mailto:help@insuremart.ng'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Social media reach
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
                          Text(
                            'Reach us on Social Media',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SocialRow(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            label: 'Facebook',
                            handle: '@insuremart',
                            onTap: () => openUrl(context,
                                'https://www.facebook.com/insuremart'),
                          ),
                          const SizedBox(height: 12),
                          _SocialRow(
                            icon: Icons.close,
                            color: AppColors.textDark,
                            label: 'X (Twitter)',
                            handle: '@insuremart',
                            onTap: () =>
                                openUrl(context,'https://x.com/insuremart'),
                          ),
                          const SizedBox(height: 12),
                          _SocialRow(
                            icon: Icons.camera_alt_outlined,
                            color: const Color(0xFFE4405F),
                            label: 'Instagram',
                            handle: '@insuremart',
                            onTap: () => openUrl(context,
                                'https://www.instagram.com/insuremart'),
                          ),
                          const SizedBox(height: 12),
                          _SocialRow(
                            icon: Icons.link,
                            color: const Color(0xFF0077B5),
                            label: 'LinkedIn',
                            handle: 'InsureMart',
                            onTap: () => openUrl(context,
                                'https://www.linkedin.com/company/insuremart'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Frequently Asked Questions',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._faqs.map((faq) => _FaqItem(faq: faq)),
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

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback? onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.detail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(50)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentCyan, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              detail,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String handle;
  final VoidCallback? onTap;

  const _SocialRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.handle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  handle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.textGray),
        ],
      ),
    );
  }
}

final _faqs = [
  {
    'question': 'How do I file a claim?',
    'answer':
        'Go to My Insurance, select your policy, and tap "File Claim". Fill out the required details and submit supporting documents.',
  },
  {
    'question': 'How long does claim processing take?',
    'answer':
        'Claims are typically processed within 5-7 business days. Complex claims may take up to 14 business days.',
  },
  {
    'question': 'Can I cancel my insurance policy?',
    'answer':
        'Yes, you can cancel within 30 days for a full refund. After 30 days, cancellation is subject to our terms and conditions.',
  },
  {
    'question': 'How do I update my personal information?',
    'answer':
        'Go to Settings and update your profile details. For changes to policy beneficiaries, please contact our support team.',
  },
];

class _FaqItem extends StatefulWidget {
  final Map<String, String> faq;

  const _FaqItem({required this.faq});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.faq['question']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textGray,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  widget.faq['answer']!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textGray,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
