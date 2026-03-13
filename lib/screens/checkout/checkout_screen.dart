import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/insurance_form_provider.dart';
import '../../routes/app_routes.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _quantity = 1;
  int _selectedAddress = 0;
  final _couponController = TextEditingController();
  bool _couponApplied = false;
  double _discount = 0;

  final List<Map<String, String>> _addresses = [
    {
      'title': "Fala's House",
      'address':
          'J-2301, Adesanya Williams Street, Opp. Global Business School, Victoria Island Lagos',
    },
    {
      'title': 'Office',
      'address': '16 Ajayi Street, Onike Yaba, Lagos.',
    },
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(insuranceFormProvider);
    final premium = formData.premiumAmount ?? 95800;
    final coverage = formData.coverageAmount ?? 7900000;
    final totalBeforeDiscount = premium * _quantity;
    final total = totalBeforeDiscount - _discount;

    String formatAmount(double amount) {
      return amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }

    final insuranceLabel = formData.insuranceType == 'motor'
        ? '${formData.carModel ?? "Car"} Motor Insurance'
        : 'Health Insurance';
    final company = formData.planCompany ?? 'Custodian & Allied Insurance';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checkout',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '$_quantity item${_quantity > 1 ? "s" : ""}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
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
                    // Item card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.business,
                                color: AppColors.textGray, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: insuranceLabel,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  company,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'N${formatAmount(premium)}/yr',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const Spacer(),
                          _buildQuantityButton(Icons.remove, () {
                            if (_quantity > 1) {
                              setState(() => _quantity--);
                            }
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$_quantity',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          _buildQuantityButton(Icons.add, () {
                            setState(() => _quantity++);
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Coupon
                    Text(
                      'HAVE A COUPON CODE?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer_outlined,
                              color: AppColors.textGray, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _couponApplied
                                ? Row(
                                    children: [
                                      Text(
                                        _couponController.text,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'APPLIED!',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )
                                : TextField(
                                    controller: _couponController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter coupon code',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textGray,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                          ),
                          if (_couponApplied)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _couponApplied = false;
                                  _discount = 0;
                                  _couponController.clear();
                                });
                              },
                              child: const Icon(Icons.cancel,
                                  color: AppColors.textGray, size: 20),
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                final code = _couponController.text.trim().toUpperCase();
                                if (code.isEmpty) return;
                                // Validate known coupon codes
                                final coupons = {
                                  'INSURE10': 0.10,
                                  'WELCOME': 0.05,
                                  'SAVE500': -1.0, // fixed 500
                                  'FIRST': 0.15,
                                };
                                if (coupons.containsKey(code)) {
                                  final rate = coupons[code]!;
                                  setState(() {
                                    _couponApplied = true;
                                    _discount = rate < 0
                                        ? 500
                                        : (premium * _quantity * rate);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Invalid coupon code'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Apply',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Address section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SELECT ADDRESS',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showAddAddressDialog(),
                          child: Text(
                            'Add New',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _addresses.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, index) {
                          return _buildAddressCard(
                            index,
                            _addresses[index]['title']!,
                            _addresses[index]['address']!,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Price breakdown
                    _buildPriceRow('Amount Insured', 'N ${formatAmount(coverage)}'),
                    _buildPriceRow('Insurance Premium', 'N ${formatAmount(premium)}'),
                    _buildPriceRow('Quantity', '$_quantity'),
                    if (_discount > 0)
                      _buildPriceRow('Coupon Discount', '-N ${formatAmount(_discount)}'),
                    const Divider(height: 24),
                    _buildPriceRow('Total Amount', 'N ${formatAmount(total)}', isBold: true),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Pay button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Proceed to Pay N ${formatAmount(total)}',
                type: ButtonType.secondary,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'amount': total,
                      'insuranceType': formData.insuranceType,
                      'planCompany': company,
                      'coverageAmount': coverage,
                      'premiumAmount': premium,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add New Address',
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
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Label (e.g. Home, Office)',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textGray),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Full address',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textGray),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.textGray)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty ||
                  addressController.text.trim().isEmpty) {
                return;
              }
              setState(() {
                _addresses.add({
                  'title': titleController.text.trim(),
                  'address': addressController.text.trim(),
                });
                _selectedAddress = _addresses.length - 1;
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Add',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accentCyan),
        ),
        child: Icon(icon, color: AppColors.accentCyan, size: 18),
      ),
    );
  }

  Widget _buildAddressCard(int index, String title, String address) {
    final isSelected = _selectedAddress == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = index),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.radio_button_checked,
                      color: AppColors.accentCyan, size: 20)
                else
                  const Icon(Icons.radio_button_off,
                      color: AppColors.borderLight, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              address,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textGray,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: AppColors.textDark,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
