import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/insurance_plan_model.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class InsuranceQuotesScreen extends ConsumerStatefulWidget {
  const InsuranceQuotesScreen({super.key});

  @override
  ConsumerState<InsuranceQuotesScreen> createState() =>
      _InsuranceQuotesScreenState();
}

class _InsuranceQuotesScreenState extends ConsumerState<InsuranceQuotesScreen> {
  String _sortBy = 'Featured';
  String _filterType = 'All';
  RangeValues _premiumRange = const RangeValues(0, 200000);
  double _minRating = 0;
  Map<String, bool> _selectedFeatures = {
    'Medical Expenses': false,
    'Fire & Theft': false,
    'Third Party': false,
    'Flood Coverage': false,
    'Roadside Assistance': false,
  };

  static final _fallbackPlans = [
    InsurancePlanModel(
      id: 'plan_1',
      company: 'Custodian & Allied Insurance',
      cover: 'N5M',
      addonsCount: 2,
      policyTerm: '1 year',
      premiumAmount: 95800,
      insuranceType: 'motor',
      features: [
        'Replacement cost or repair costs',
        'Medical Expenses',
        'Theft of the policyholder\'s vehicle',
        'Fire to the policyholder\'s vehicle',
        'Towing fee up to maximum limit',
      ],
      rating: 4.5,
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
    InsurancePlanModel(
      id: 'plan_2',
      company: 'Leadway Assurance',
      cover: 'N3M',
      addonsCount: 1,
      policyTerm: '1 year',
      premiumAmount: 65000,
      insuranceType: 'motor',
      features: [
        'Third party property damage',
        'Medical Expenses',
        'Fire and theft coverage',
        'Personal accident cover',
      ],
      rating: 4.2,
      isFeatured: false,
      createdAt: DateTime.now(),
    ),
    InsurancePlanModel(
      id: 'plan_3',
      company: 'AXA Mansard Insurance',
      cover: 'N10M',
      addonsCount: 3,
      policyTerm: '1 year',
      premiumAmount: 142500,
      insuranceType: 'motor',
      features: [
        'Comprehensive vehicle coverage',
        'Medical Expenses',
        'Theft and fire protection',
        'Flood and natural disaster',
        'Excess buy back',
        'Roadside assistance',
      ],
      rating: 4.7,
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
    InsurancePlanModel(
      id: 'plan_4',
      company: 'AIICO Insurance',
      cover: 'N2M',
      addonsCount: 0,
      policyTerm: '1 year',
      premiumAmount: 45000,
      insuranceType: 'motor',
      features: [
        'Third party liability',
        'Basic medical expenses',
        'Fire coverage',
      ],
      rating: 3.8,
      isFeatured: false,
      createdAt: DateTime.now(),
    ),
    InsurancePlanModel(
      id: 'plan_5',
      company: 'Coronation Insurance',
      cover: 'N7.5M',
      addonsCount: 2,
      policyTerm: '1 year',
      premiumAmount: 118000,
      insuranceType: 'health',
      features: [
        'Comprehensive health coverage',
        'Dental and optical',
        'Specialist consultation',
        'Hospital admission',
        'Prescription drugs',
      ],
      rating: 4.4,
      isFeatured: true,
      createdAt: DateTime.now(),
    ),
  ];

  List<InsurancePlanModel> _applySortAndFilter(
      List<InsurancePlanModel> plans) {
    var result = List<InsurancePlanModel>.from(plans);

    // Apply type filter
    if (_filterType != 'All') {
      final typeKey = _filterType.toLowerCase();
      result =
          result.where((p) => p.insuranceType.toLowerCase() == typeKey).toList();
    }

    // Apply premium range filter
    result = result
        .where((p) =>
            p.premiumAmount >= _premiumRange.start &&
            p.premiumAmount <= _premiumRange.end)
        .toList();

    // Apply minimum rating filter
    if (_minRating > 0) {
      result = result.where((p) => (p.rating ?? 0) >= _minRating).toList();
    }

    // Apply feature filters
    final activeFeatures = _selectedFeatures.entries
        .where((e) => e.value)
        .map((e) => e.key.toLowerCase())
        .toList();
    if (activeFeatures.isNotEmpty) {
      result = result.where((plan) {
        final planFeatures =
            plan.features.map((f) => f.toLowerCase()).join(' ');
        return activeFeatures
            .any((feature) => planFeatures.contains(feature));
      }).toList();
    }

    // Apply sort
    switch (_sortBy) {
      case 'Fee Low to High':
        result.sort((a, b) => a.premiumAmount.compareTo(b.premiumAmount));
        break;
      case 'Fee High to Low':
        result.sort((a, b) => b.premiumAmount.compareTo(a.premiumAmount));
        break;
      case 'Rating High to Low':
        result.sort(
            (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case 'Newest First':
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest First':
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Featured':
        result.sort((a, b) {
          if (a.isFeatured && !b.isFeatured) return -1;
          if (!a.isFeatured && b.isFeatured) return 1;
          return 0;
        });
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(insurancePlansProvider(null));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,
                                color: AppColors.textDark),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Plans',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.help),
                        child: Row(
                          children: [
                            const Icon(Icons.support_agent_outlined,
                                color: AppColors.accentCyan, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              'Need Help?',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.accentCyan,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Info bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insurance Plans  ·  ${_filterType == 'All' ? 'All Types' : _filterType}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Modify Details',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  color: AppColors.scaffoldBackground,
                ),

                // Plans list
                Expanded(
                  child: plansAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) {
                      final filtered = _applySortAndFilter(_fallbackPlans);
                      return filtered.isEmpty
                          ? _buildEmptyState()
                          : _buildPlansList(context, filtered);
                    },
                    data: (plans) {
                      final displayPlans =
                          plans.isEmpty ? _fallbackPlans : plans;
                      final filtered = _applySortAndFilter(displayPlans);
                      return filtered.isEmpty
                          ? _buildEmptyState()
                          : _buildPlansList(context, filtered);
                    },
                  ),
                ),
              ],
            ),

            // Floating Sort / Filter pill
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _showSortSheet(context),
                        child: Row(
                          children: [
                            const Icon(Icons.sort,
                                size: 20, color: AppColors.textDark),
                            const SizedBox(width: 6),
                            Text(
                              'Sort',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 20),
                        color: AppColors.borderLight,
                      ),
                      GestureDetector(
                        onTap: () => _showFilterSheet(context),
                        child: Row(
                          children: [
                            const Icon(Icons.tune,
                                size: 20, color: AppColors.textDark),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark,
                              ),
                            ),
                            if (_filterType != 'All' ||
                                _minRating > 0 ||
                                _selectedFeatures.values.any((v) => v)) ...[
                              const SizedBox(width: 2),
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.textGray),
          const SizedBox(height: 16),
          Text(
            'No plans match your filters',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textGray,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _filterType = 'All';
                _premiumRange = const RangeValues(0, 200000);
                _minRating = 0;
                _selectedFeatures.updateAll((_, __) => false);
                _sortBy = 'Featured';
              });
            },
            child: Text(
              'Reset Filters',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentCyan,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(
      BuildContext context, List<InsurancePlanModel> plans) {
    return ListView.builder(
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        return _buildPlanCard(context, plans[index]);
      },
    );
  }

  Widget _buildPlanCard(BuildContext context, InsurancePlanModel plan) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.borderLight.withValues(alpha: 0.5)),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.textGray,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.company,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoCol('Cover', plan.cover),
                        const SizedBox(width: 16),
                        _buildInfoCol('Addons', plan.addonsText),
                        const SizedBox(width: 16),
                        _buildInfoCol('Policy Term', plan.policyTerm),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.accentCyan,
                    ),
                  ),
                  Text(
                    plan.formattedPremium,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _showPreviewSheet(context, plan);
                    },
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColors.accentCyan),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Preview',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.packageDetails,
                        arguments: {'plan': plan},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              GoogleFonts.poppins(fontSize: 10, color: AppColors.textGray),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  void _showPreviewSheet(BuildContext context, InsurancePlanModel plan) {
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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Icon(Icons.shield_outlined,
                      color: AppColors.textGray, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.company,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${plan.rating ?? 0}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.textGray),
                          ),
                          const SizedBox(width: 4),
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < (plan.rating?.floor() ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: const Color(0xFFFFC107),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:
                      const Icon(Icons.close, color: AppColors.textGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPreviewInfo('Cover', plan.cover),
                _buildPreviewInfo('Addons', plan.addonsText),
                _buildPreviewInfo('Term', plan.policyTerm),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Premium: ${plan.formattedPremium}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accentCyan,
              ),
            ),
            if (plan.features.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Key Features',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              ...plan.features.take(4).map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: AppColors.accentCyan, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textGray),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.packageDetails,
                    arguments: {'plan': plan},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  'View Full Details',
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
      ),
    );
  }

  Widget _buildPreviewInfo(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: AppColors.textGray)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark)),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SortBottomSheet(
        selected: _sortBy,
        onSelected: (value) {
          setState(() => _sortBy = value);
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        selectedType: _filterType,
        premiumRange: _premiumRange,
        minRating: _minRating,
        selectedFeatures: Map.from(_selectedFeatures),
        onApply: (type, range, rating, features) {
          setState(() {
            _filterType = type;
            _premiumRange = range;
            _minRating = rating;
            _selectedFeatures = features;
          });
        },
      ),
    );
  }
}

class _SortBottomSheet extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _SortBottomSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<_SortBottomSheet> {
  late String _selected;

  final _options = [
    'Newest First',
    'Oldest First',
    'Featured',
    'Rating High to Low',
    'Fee Low to High',
    'Fee High to Low',
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Sort by',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          ..._options.map((option) {
            final isSelected = option == _selected;
            return InkWell(
              onTap: () {
                setState(() => _selected = option);
                widget.onSelected(option);
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
                      option,
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
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final String selectedType;
  final RangeValues premiumRange;
  final double minRating;
  final Map<String, bool> selectedFeatures;
  final void Function(
      String type, RangeValues range, double rating, Map<String, bool> features)
      onApply;

  const _FilterBottomSheet({
    required this.selectedType,
    required this.premiumRange,
    required this.minRating,
    required this.selectedFeatures,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late String _selectedType;
  late RangeValues _premiumRange;
  late double _minRating;
  late Map<String, bool> _selectedFeatures;

  final _types = ['All', 'Motor', 'Health', 'Bike', 'Term Plan'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _premiumRange = widget.premiumRange;
    _minRating = widget.minRating;
    _selectedFeatures = Map.from(widget.selectedFeatures);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = 'All';
                      _premiumRange = const RangeValues(0, 200000);
                      _selectedFeatures.updateAll((_, __) => false);
                      _minRating = 0;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Insurance Type
                  Text(
                    'Insurance Type',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _types.map((type) {
                      final isSelected = type == _selectedType;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentCyan
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentCyan
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Text(
                            type,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Premium Range
                  Text(
                    'Premium Range',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'N${_formatNumber(_premiumRange.start.toInt())} - N${_formatNumber(_premiumRange.end.toInt())}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RangeSlider(
                    values: _premiumRange,
                    min: 0,
                    max: 200000,
                    divisions: 20,
                    activeColor: AppColors.accentCyan,
                    inactiveColor: AppColors.borderLight,
                    onChanged: (values) {
                      setState(() => _premiumRange = values);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Minimum Rating
                  Text(
                    'Minimum Rating',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      final starValue = (i + 1).toDouble();
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _minRating = starValue),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            starValue <= _minRating
                                ? Icons.star
                                : Icons.star_border,
                            size: 32,
                            color: const Color(0xFFFFC107),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Coverage Features
                  Text(
                    'Coverage Features',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._selectedFeatures.entries.map((entry) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFeatures[entry.key] = !entry.value;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
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
                            const SizedBox(width: 12),
                            Text(
                              entry.key,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _selectedType,
                    _premiumRange,
                    _minRating,
                    _selectedFeatures,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Apply Filters',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
