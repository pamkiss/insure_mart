import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';
import '../../services/seed_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notification Settings',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() => _notificationsEnabled = value);
                      },
                      activeThumbColor: Colors.green,
                    ),
                  ),
                  _buildSettingItem(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _buildSettingItem(
                    icon: Icons.share_outlined,
                    label: 'Share Our App',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.inviteFriends);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.star_outline,
                    label: 'Rate Our App',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.feedback);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.account_balance_outlined,
                    label: 'Terms & Conditions',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.termsConditions);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.check_box_outlined,
                    label: 'Privacy Policy',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.support_agent_outlined,
                    label: 'Need Help?',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.help);
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.storage_outlined,
                    label: 'Seed Demo Data',
                    onTap: () async {
                      final firestore = ref.read(firestoreServiceProvider);
                      final seed = SeedService(firestore);
                      try {
                        await seed.seedAll();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Demo data seeded successfully!')),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Seed failed: $e')),
                        );
                      }
                    },
                  ),
                  _buildSettingItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () async {
                      await ref.read(authProvider).signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Current password',
                hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGray),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'New password',
                hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGray),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm new password',
                hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.textGray),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textGray),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text.isEmpty ||
                  newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password must be at least 6 characters'),
                  ),
                );
                return;
              }
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              try {
                final authService = ref.read(authServiceProvider);
                // Re-authenticate with current password first
                final user = authService.currentUser;
                if (user?.email != null) {
                  await authService.signInWithEmail(
                    user!.email!,
                    currentPasswordController.text,
                  );
                }
                await authService.updatePassword(newPasswordController.text);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Update',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textDark, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
