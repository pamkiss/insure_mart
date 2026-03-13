import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/insurance_policy_model.dart';
import '../../models/order_model.dart';
import '../../models/reminder_model.dart';
import '../../models/wallet_model.dart';
import '../../providers/insurance_form_provider.dart';
import '../../providers/providers.dart';
import '../../routes/app_routes.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedMethod = 'Credit/Debit Card';
  bool _saveCard = true;
  bool _isProcessing = false;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  final _methods = [
    'PayPal',
    'Google wallet',
    'Bank Transfer',
    'Credit/Debit Card',
  ];

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    // Validate card fields if card payment
    if (_selectedMethod == 'Credit/Debit Card') {
      final cardNum = _cardNumberController.text.replaceAll(' ', '');
      final expiry = _expiryController.text.trim();
      final cvv = _cvvController.text.trim();
      final name = _nameController.text.trim();

      if (cardNum.isEmpty || expiry.isEmpty || cvv.isEmpty || name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all card details')),
        );
        return;
      }
      if (cardNum.length < 13 || cardNum.length > 19 ||
          !RegExp(r'^\d+$').hasMatch(cardNum)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid card number')),
        );
        return;
      }
      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expiry must be in MM/YY format')),
        );
        return;
      }
      final month = int.tryParse(expiry.substring(0, 2)) ?? 0;
      if (month < 1 || month > 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid expiry month')),
        );
        return;
      }
      if (cvv.length < 3 || cvv.length > 4 ||
          !RegExp(r'^\d+$').hasMatch(cvv)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CVV must be 3 or 4 digits')),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final auth = ref.read(authProvider);
      final firestore = ref.read(firestoreServiceProvider);
      final formData = ref.read(insuranceFormProvider);
      final userId = auth.firebaseUser?.uid;

      if (userId == null) {
        throw Exception('Not authenticated');
      }

      // Get payment args
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final amount = (args?['amount'] as double?) ?? formData.premiumAmount ?? 95800;
      final insuranceType = args?['insuranceType'] ?? formData.insuranceType;
      final planCompany = args?['planCompany'] ?? formData.planCompany ?? 'Insurance Provider';
      final coverageAmount = (args?['coverageAmount'] as double?) ?? formData.coverageAmount ?? 7900000;
      final premiumAmount = (args?['premiumAmount'] as double?) ?? formData.premiumAmount ?? 95800;

      // Determine policy type
      InsuranceType policyType;
      String typeLabel;
      switch (insuranceType) {
        case 'motor':
          policyType = InsuranceType.car;
          typeLabel = 'Car Insurance';
          break;
        case 'bike':
          policyType = InsuranceType.bike;
          typeLabel = 'Bike Insurance';
          break;
        case 'termPlan':
          policyType = InsuranceType.termPlan;
          typeLabel = 'Term Plan Insurance';
          break;
        default:
          policyType = InsuranceType.health;
          typeLabel = 'Health Insurance';
      }

      // 1. Create order
      final now = DateTime.now();
      final order = OrderModel(
        id: '',
        userId: userId,
        insuranceType: typeLabel,
        planId: formData.planId,
        planCompany: planCompany,
        amount: amount,
        status: OrderStatus.processing,
        createdAt: now,
      );
      await firestore.createOrder(order);

      // 2. Create policy
      final policyNumber = 'POL-${policyType.name.substring(0, 3).toUpperCase()}-${now.year}-${now.millisecondsSinceEpoch.toString().substring(8)}';
      final policy = InsurancePolicyModel(
        id: '',
        userId: userId,
        type: policyType,
        provider: planCompany,
        coverageAmount: coverageAmount,
        premiumAmount: premiumAmount,
        status: PolicyStatus.active,
        startDate: now,
        expiryDate: now.add(const Duration(days: 365)),
        policyNumber: policyNumber,
        createdAt: now,
      );
      await firestore.createPolicy(policy);

      // 3. Create renewal reminder (11 months from now)
      final reminder = ReminderModel(
        id: '',
        userId: userId,
        title: '$typeLabel Renewal',
        amount: premiumAmount,
        dueDate: now.add(const Duration(days: 335)),
        status: ReminderStatus.upcoming,
        createdAt: now,
      );
      await firestore.createReminder(reminder);

      // 4. Add wallet transaction (debit)
      final transaction = WalletTransactionModel(
        id: '',
        userId: userId,
        title: '$typeLabel Premium',
        amount: amount,
        type: TransactionType.debit,
        createdAt: now,
      );
      await firestore.addWalletTransaction(transaction);

      // 5. Reset form
      ref.read(insuranceFormProvider.notifier).reset();

      if (!mounted) return;

      // Show success dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Payment Successful!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your $typeLabel policy has been created successfully.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Policy: $policyNumber',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentCyan,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Navigate back to dashboard, clearing the stack
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.dashboard,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Go to Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Payment',
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment methods
                    ..._methods.map((method) => _buildPaymentMethod(method)),
                    const SizedBox(height: 24),

                    // Credit card form (shown when selected)
                    if (_selectedMethod == 'Credit/Debit Card') ...[
                      Text(
                        'Credit Card',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card number
                      _buildCardField(
                        label: 'Card Number',
                        controller: _cardNumberController,
                        hint: '1234 5678 9012 3456',
                        suffixIcon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Expiry + CVV
                      Row(
                        children: [
                          Expanded(
                            child: _buildCardField(
                              label: 'Expiry/Validity',
                              controller: _expiryController,
                              hint: 'MM/YY',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildCardField(
                              label: 'CVV',
                              controller: _cvvController,
                              hint: '***',
                              keyboardType: TextInputType.number,
                              obscure: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name on card
                      _buildCardField(
                        label: 'Name on Card',
                        controller: _nameController,
                        hint: 'Full name as on card',
                      ),
                      const SizedBox(height: 16),

                      // Save card checkbox
                      InkWell(
                        onTap: () => setState(() => _saveCard = !_saveCard),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _saveCard
                                    ? AppColors.accentCyan
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _saveCard
                                      ? AppColors.accentCyan
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: _saveCard
                                  ? const Icon(Icons.check,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Save this card for future payment reference',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Pay button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Pay Securely',
                type: ButtonType.secondary,
                icon: Icons.lock_outline,
                isLoading: _isProcessing,
                onPressed: _processPayment,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String method) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accentCyan : AppColors.borderLight,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            _buildMethodIcon(method),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                method,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodIcon(String method) {
    IconData icon;
    Color color;
    switch (method) {
      case 'PayPal':
        icon = Icons.paypal_outlined;
        color = const Color(0xFF003087);
        break;
      case 'Google wallet':
        icon = Icons.account_balance_wallet;
        color = const Color(0xFF4285F4);
        break;
      case 'Bank Transfer':
        icon = Icons.account_balance;
        color = AppColors.textDark;
        break;
      case 'Credit/Debit Card':
        icon = Icons.credit_card;
        color = AppColors.textDark;
        break;
      default:
        icon = Icons.payment;
        color = AppColors.textGray;
    }
    return Icon(icon, color: color, size: 22);
  }

  Widget _buildCardField({
    required String label,
    required TextEditingController controller,
    String? hint,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.accentCyan,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (suffixIcon != null)
                Icon(suffixIcon, color: AppColors.primaryBlue, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
