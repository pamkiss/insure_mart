import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/url_helper.dart';
import '../../providers/providers.dart';

class InviteFriendsScreen extends ConsumerWidget {
  const InviteFriendsScreen({super.key});

  static const _shareMessage =
      'Join InsureMart - the simplest way to get insurance in Nigeria! Sign up now and get N500 bonus. Download: https://insuremart.ng/download';

  void _shareToWhatsApp(BuildContext context) {
    openUrl(context,
        'https://wa.me/?text=${Uri.encodeComponent(_shareMessage)}');
  }

  void _shareToFacebook(BuildContext context) {
    openUrl(context,
        'https://www.facebook.com/sharer/sharer.php?quote=${Uri.encodeComponent(_shareMessage)}');
  }

  void _shareToTwitter(BuildContext context) {
    openUrl(context,
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(_shareMessage)}');
  }

  void _shareToLinkedIn(BuildContext context) {
    openUrl(context,
        'https://www.linkedin.com/sharing/share-offsite/?url=${Uri.encodeComponent('https://insuremart.ng')}');
  }

  void _shareViaSms(BuildContext context) {
    openUrl(context, 'sms:?body=${Uri.encodeComponent(_shareMessage)}');
  }

  String _getReferralLink(WidgetRef ref) {
    final auth = ref.read(authProvider);
    final uid = auth.firebaseUser?.uid ?? 'guest';
    return 'https://insuremart.ng/invite/$uid';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralLink = _getReferralLink(ref);
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite Friends',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Invite friends & family and earn N500.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // WhatsApp Friends section
                    Text(
                      'Whatsapp Friends',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFriendsList(context),
                    const SizedBox(height: 28),

                    // Share on Social Media
                    Text(
                      'Share on Social Media',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSocialIcons(context),
                    const SizedBox(height: 28),

                    // Invite input
                    _buildInviteInput(context, referralLink),
                    const SizedBox(height: 20),

                    // General share button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: _shareMessage));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invite message copied to clipboard!'),
                              backgroundColor: Color(0xFF25D366),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, size: 20),
                        label: Text(
                          'Share via Other Apps',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bottom illustration
                    _buildIllustration(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final friends = ['Sherlin', 'Adam', 'Komal', 'Gary', 'Wilda'];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () => _shareToWhatsApp(context),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withAlpha(40),
                      child: Icon(
                        Icons.person,
                        color: Colors.white.withAlpha(150),
                        size: 28,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF25D366),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  friends[index],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    final socials = [
      {
        'icon': Icons.chat_bubble,
        'color': const Color(0xFF25D366),
        'onTap': () => _shareToWhatsApp(context),
      },
      {
        'icon': Icons.facebook,
        'color': AppColors.facebookBlue,
        'onTap': () => _shareToFacebook(context),
      },
      {
        'icon': Icons.alternate_email,
        'color': const Color(0xFF1DA1F2),
        'onTap': () => _shareToTwitter(context),
      },
      {
        'icon': Icons.link,
        'color': const Color(0xFF0077B5),
        'onTap': () => _shareToLinkedIn(context),
      },
      {
        'icon': Icons.message,
        'color': const Color(0xFF0084FF),
        'onTap': () => _shareViaSms(context),
      },
    ];

    return Row(
      children: socials.map((social) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: social['onTap'] as VoidCallback,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: social['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                social['icon'] as IconData,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInviteInput(BuildContext context, String referralLink) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              referralLink,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withAlpha(200),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white, size: 20),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: referralLink),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Link copied to clipboard!',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  backgroundColor: const Color(0xFF25D366),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Image.asset(
      'assets/images/invite_friends_illustration.png',
      height: 140,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox(height: 140),
    );
  }
}
