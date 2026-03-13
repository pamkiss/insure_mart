import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.background,
      width: MediaQuery.of(context).size.width * 0.78,
      child: Column(
        children: [
          // Profile header
          _buildProfileHeader(context, ref),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Home',
                  iconColor: AppColors.primaryBlue,
                  onTap: () => Navigator.pop(context),
                ),
                _buildMenuItem(
                  icon: Icons.medical_services_outlined,
                  label: 'My Insurance',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.myInsurance);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.local_hospital_outlined,
                  label: 'Hospitals',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.hospitals);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.phone_in_talk_outlined,
                  label: 'eConsultation',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.econsultation);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.verified_outlined,
                  label: 'My Policies',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.myPolicies);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_active_outlined,
                  label: 'Reminders',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.reminders);
                  },
                ),
                _buildWalletMenuItem(context, ref),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  label: 'Pending Orders',
                  iconColor: AppColors.primaryBlue,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.pendingOrders);
                  },
                ),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, color: AppColors.borderLight),

          // Bottom bar
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final name = auth.userModel?.fullName ?? auth.displayName;
    final phone = auth.userModel?.phoneNumber ?? '';
    final email = auth.userModel?.email ?? auth.firebaseUser?.email ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF3949AB),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone.isNotEmpty ? phone : email,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF42A5F5), size: 26),
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

  Widget _buildWalletMenuItem(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final balance = walletAsync.when(
      data: (wallet) {
        if (wallet == null) return 'N0';
        final formatted = wallet.balance.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
        return 'N$formatted';
      },
      loading: () => '...',
      error: (_, __) => 'N0',
    );

    return _buildMenuItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Wallet',
      iconColor: AppColors.primaryBlue,
      trailing: Text(
        balance,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.wallet);
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settingsScreen);
            },
          ),
          _buildBottomItem(
            icon: Icons.support_agent_outlined,
            label: '24x7 Help',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.help);
            },
          ),
          _buildBottomItem(
            icon: Icons.info_outline,
            label: 'About us',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.aboutUs);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textDark, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
