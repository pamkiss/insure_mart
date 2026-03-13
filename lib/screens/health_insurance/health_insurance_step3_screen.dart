import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class HealthInsuranceStep3Screen extends ConsumerStatefulWidget {
  final List<String> members;

  const HealthInsuranceStep3Screen({
    super.key,
    required this.members,
  });

  @override
  ConsumerState<HealthInsuranceStep3Screen> createState() =>
      _HealthInsuranceStep3ScreenState();
}

class _HealthInsuranceStep3ScreenState
    extends ConsumerState<HealthInsuranceStep3Screen> {
  final Map<String, String?> _ages = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final member in widget.members) {
      _ages[member] = null;
    }
  }

  void _showAgePicker(String member) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: 83,
            itemBuilder: (context, index) {
              final age = (index + 18).toString();
              return ListTile(
                title: Text(age, style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _ages[member] = age;
                    _error = null;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Step 3 of 4',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Add age of each member',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Add Age',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Age list
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: widget.members.asMap().entries.map((entry) {
                          final isLast =
                              entry.key == widget.members.length - 1;
                          final member = entry.value;
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      member,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showAgePicker(member),
                                      child: Row(
                                        children: [
                                          Text(
                                            _ages[member] ?? 'Select Age',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: _ages[member] != null
                                                  ? AppColors.textDark
                                                  : AppColors.textGray,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.textGray,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                const Divider(
                                    height: 0, indent: 20, endIndent: 20),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Proceed button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Proceed',
                type: ButtonType.secondary,
                onPressed: () {
                  final missingAges = _ages.entries.where((e) => e.value == null).toList();
                  if (missingAges.isNotEmpty) {
                    setState(() => _error = 'Please select age for all members');
                    return;
                  }

                  ref.read(insuranceFormProvider.notifier).setMemberAges(_ages);
                  Navigator.pushNamed(context, AppRoutes.healthInsuranceStep4);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
