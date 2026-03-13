import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class MotorInsuranceStep1Screen extends ConsumerWidget {
  const MotorInsuranceStep1Screen({super.key});

  static const _popularBrands = [
    'Toyota', 'Mercedes', 'Honda', 'Buick',
    'Lexus', 'Porsche', 'Volkswagen', 'Alfa Romeo',
  ];

  static const _allBrands = [
    'Audi', 'Alfa Romeo', 'Acura', 'Aston Martin', 'Abarth',
    'BMW', 'Bentley', 'Bugatti',
    'Chevrolet', 'Chrysler',
    'Dodge', 'Ferrari', 'Ford',
    'Genesis', 'Honda', 'Hyundai',
    'Infiniti', 'Jaguar', 'Jeep',
    'Kia', 'Lamborghini', 'Land Rover', 'Lexus',
    'Maserati', 'Mazda', 'McLaren', 'Mercedes',
    'Nissan', 'Peugeot', 'Porsche',
    'Rolls Royce', 'Subaru', 'Suzuki',
    'Tesla', 'Toyota', 'Volkswagen', 'Volvo',
  ];

  void _selectBrand(BuildContext context, WidgetRef ref, String brand) {
    ref.read(insuranceFormProvider.notifier).reset();
    ref.read(insuranceFormProvider.notifier).setInsuranceType('motor');
    ref.read(insuranceFormProvider.notifier).setCarBrand(brand);
    Navigator.pushNamed(
      context,
      AppRoutes.motorInsuranceStep2,
      arguments: {'brand': brand},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group brands by first letter
    final grouped = <String, List<String>>{};
    for (final brand in _allBrands) {
      final letter = brand[0].toUpperCase();
      grouped.putIfAbsent(letter, () => []);
      grouped[letter]!.add(brand);
    }
    final sortedKeys = grouped.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  Text(
                    'Step 1 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            'Let us help you find the right motor plan for you!',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Select your Car Brand',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'POPULAR BRANDS',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentCyan,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Popular brands grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () => _selectBrand(context, ref, _popularBrands[index]),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Spacer(),
                                  Icon(
                                    Icons.directions_car,
                                    color: AppColors.textGray.withAlpha(80),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _popularBrands[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.textGray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _popularBrands.length,
                      ),
                    ),
                  ),

                  // Alphabetical list
                  ...sortedKeys.expand((letter) {
                    return [
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          color: AppColors.scaffoldBackground,
                          child: Text(
                            letter,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final brand = grouped[letter]![index];
                            return InkWell(
                              onTap: () => _selectBrand(context, ref, brand),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 14),
                                child: Text(
                                  brand,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: grouped[letter]!.length,
                        ),
                      ),
                    ];
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
