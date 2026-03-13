import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class MotorInsuranceStep2Screen extends ConsumerStatefulWidget {
  final String brand;

  const MotorInsuranceStep2Screen({super.key, required this.brand});

  @override
  ConsumerState<MotorInsuranceStep2Screen> createState() =>
      _MotorInsuranceStep2ScreenState();
}

class _MotorInsuranceStep2ScreenState extends ConsumerState<MotorInsuranceStep2Screen> {
  int _selectedYear = 2020;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _availableYears = List.generate(15, (i) => 2024 - i);

  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Year',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: _availableYears.length,
                itemBuilder: (context, index) {
                  final year = _availableYears[index];
                  final isSelected = year == _selectedYear;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedYear = year);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: AppColors.borderLight, width: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$year',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: AppColors.textDark,
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: AppColors.accentCyan, size: 24),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExtensionsSheet(Map<String, String> model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExtensionsSheet(
        model: model,
        onProceed: (selectedExtensions) {
          // Save form data
          final notifier = ref.read(insuranceFormProvider.notifier);
          notifier.setCarModel(
            model['name']!,
            model['details']!,
            model['value']!,
          );
          notifier.setExtensions(selectedExtensions);

          Navigator.of(context).pop(); // close bottom sheet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushNamed(AppRoutes.insuranceQuotes);
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allModels = _getCarModels();
    final models = _searchQuery.isEmpty
        ? allModels
        : allModels
            .where((m) =>
                m['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                m['details']!.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar with back arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: AppColors.textGray, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textGray,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.close,
                                  color: AppColors.textGray, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.mic_none, color: AppColors.textDark),
                ],
              ),
            ),

            // Title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select your Car Model',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showYearPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Year: $_selectedYear',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down,
                              size: 18, color: AppColors.textGray),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Car model list
            Expanded(
              child: models.isEmpty
                  ? Center(
                      child: Text(
                        'No models found',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.textGray),
                      ),
                    )
                  : ListView.builder(
                      itemCount: models.length,
                      itemBuilder: (context, index) {
                        final model = models[index];
                        return InkWell(
                          onTap: () {
                            _showExtensionsSheet(model);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Car image
                                SizedBox(
                                  width: 60,
                                  height: 40,
                                  child: model['image'] != null
                                      ? Image.asset(
                                          model['image']!,
                                          fit: BoxFit.contain,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.borderLight
                                                .withAlpha(80),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.directions_car,
                                            color: AppColors.textGray,
                                            size: 24,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model['name']!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        model['details']!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'VALUED AT',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        color: AppColors.textGray,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Text(
                                      model['value']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getCarModels() {
    return [
      {
        'name': 'Acura CDX',
        'details': 'Honda/Hatchback/$_selectedYear',
        'value': 'N14.5m',
      },
      {
        'name': 'McLaren720s',
        'details': 'Maclaren/Hatchback/$_selectedYear',
        'value': 'N58m',
        'image': 'assets/images/car_logos/mclaren720s.png',
      },
      {
        'name': 'Jaguar XEL',
        'details': 'Tata/Luxury/$_selectedYear',
        'value': 'N35.8m',
      },
      {
        'name': 'Audi RS6',
        'details': 'Audi/Hatchback/$_selectedYear',
        'value': 'N72.7m',
      },
      {
        'name': 'Lexus LC',
        'details': 'Toyota/Luxury/$_selectedYear',
        'value': 'N72.7m',
      },
      {
        'name': 'Volvo S90',
        'details': 'Volvo/Sedan/$_selectedYear',
        'value': 'N72.7m',
        'image': 'assets/images/car_logos/volvo_s90.png',
      },
      {
        'name': 'Porsche 718',
        'details': 'Porsche/Luxury/$_selectedYear',
        'value': 'N62.5m',
      },
    ];
  }
}

class _ExtensionsSheet extends StatefulWidget {
  final Map<String, String> model;
  final void Function(List<String>) onProceed;

  const _ExtensionsSheet({required this.model, required this.onProceed});

  @override
  State<_ExtensionsSheet> createState() => _ExtensionsSheetState();
}

class _ExtensionsSheetState extends State<_ExtensionsSheet> {
  final Map<String, bool> _extensions = {
    'Excess Buy Back (EBB)': true,
    'Flood Extension': true,
    'SRCC Extension': false,
    'Additional Third Party Property Damage': false,
    'Personal Effects': false,
  };

  @override
  Widget build(BuildContext context) {
    final selectedCount = _extensions.values.where((v) => v).length;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car info
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 50,
                child: widget.model['image'] != null
                    ? Image.asset(
                        widget.model['image']!,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                            Icons.directions_car, color: AppColors.textGray),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${widget.model['details']!} 2.3L EcoBoost',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                    Text(
                      'N62.5m - N74.8m',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Add Extensions to your Car',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Extensions list
          ..._extensions.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _extensions[entry.key] = !entry.value;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: entry.value
                            ? AppColors.accentCyan
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: entry.value
                              ? AppColors.accentCyan
                              : AppColors.borderLight,
                        ),
                      ),
                      child: entry.value
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Proceed button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final selected = _extensions.entries
                    .where((e) => e.value)
                    .map((e) => e.key)
                    .toList();
                widget.onProceed(selected);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                selectedCount > 0
                    ? 'Proceed with $selectedCount Extension${selectedCount > 1 ? "s" : ""}'
                    : 'Proceed without Extensions',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
