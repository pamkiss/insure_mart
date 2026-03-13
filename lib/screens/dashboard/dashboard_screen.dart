import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';
import '../menu/menu_drawer.dart';
import 'widgets/insurance_card.dart';
import 'widgets/promo_banner.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final displayName = auth.displayName;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        drawer: const MenuDrawer(),
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Builder(
            builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hamburger menu
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 16,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Greeting
                Text(
                  'Good day $displayName,',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greetingOrange,
                  ),
                ),
                const SizedBox(height: 4),

                // Headline
                Text(
                  'Switch to the Simpler\nInsurance',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                // Insurance category cards - 2x2 grid
                Row(
                  children: [
                    Expanded(
                      child: InsuranceCard(
                        icon: Icons.medical_services_outlined,
                        label: 'Health\nInsurance',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.healthInsuranceStep1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InsuranceCard(
                        icon: Icons.directions_car_outlined,
                        label: 'Car\nInsurance',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.motorInsuranceStep1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InsuranceCard(
                        icon: Icons.two_wheeler_outlined,
                        label: 'Bike\nInsurance',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.motorInsuranceStep1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InsuranceCard(
                        icon: Icons.umbrella_outlined,
                        label: 'Term Plan\nInsurance',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.healthInsuranceStep1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Promo banner
                PromoBanner(
                  onViewPlans: () => Navigator.pushNamed(context, AppRoutes.insuranceQuotes),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
