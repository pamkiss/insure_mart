import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/wallet_model.dart';
import '../../providers/providers.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(walletTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.textDark, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Wallet',
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BalanceCard(walletAsync: walletAsync),
                    const SizedBox(height: 24),
                    Text(
                      'Recent Transactions',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTransactionsList(transactionsAsync),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(AsyncValue<List<WalletTransactionModel>> transactionsAsync) {
    return transactionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Failed to load transactions',
            style: GoogleFonts.poppins(color: AppColors.textGray),
          ),
        ),
      ),
      data: (transactions) {
        if (transactions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No transactions yet',
                style: GoogleFonts.poppins(color: AppColors.textGray),
              ),
            ),
          );
        }
        return Column(
          children: transactions.map((t) => _TransactionItem(transaction: t)).toList(),
        );
      },
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  final AsyncValue<WalletModel?> walletAsync;

  const _BalanceCard({required this.walletAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceText = walletAsync.when(
      loading: () => '...',
      error: (_, __) => 'N0.00',
      data: (wallet) => wallet?.formattedBalance ?? 'N0.00',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withAlpha(180),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            balanceText,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAmountDialog(context, ref, isDeposit: true),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text('Add Money',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAmountDialog(context, ref, isDeposit: false),
                  icon: const Icon(Icons.arrow_upward, size: 20),
                  label: Text('Withdraw',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAmountDialog(BuildContext context, WidgetRef ref, {required bool isDeposit}) {
    final controller = TextEditingController();
    final title = isDeposit ? 'Add Money' : 'Withdraw';

    showDialog(
      context: context,
      builder: (ctx) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: 'N ',
                      hintStyle: GoogleFonts.poppins(color: AppColors.textGray),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final amountText = controller.text.trim().replaceAll(',', '');
                          final amount = double.tryParse(amountText);
                          if (amount == null || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid amount')),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            final auth = ref.read(authProvider);
                            final firestore = ref.read(firestoreServiceProvider);
                            final userId = auth.firebaseUser!.uid;
                            final wallet = walletAsync.value;
                            final currentBalance = wallet?.balance ?? 0;

                            if (!isDeposit && amount > currentBalance) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Insufficient balance')),
                              );
                              setDialogState(() => isLoading = false);
                              return;
                            }

                            final newBalance = isDeposit
                                ? currentBalance + amount
                                : currentBalance - amount;

                            // Update balance
                            await firestore.updateWalletBalance(userId, newBalance);

                            // Add transaction record
                            final transaction = WalletTransactionModel(
                              id: '',
                              userId: userId,
                              title: isDeposit ? 'Wallet Top-up' : 'Wallet Withdrawal',
                              amount: amount,
                              type: isDeposit ? TransactionType.credit : TransactionType.debit,
                              createdAt: DateTime.now(),
                            );
                            await firestore.addWalletTransaction(transaction);

                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isDeposit
                                      ? 'N${controller.text} added successfully'
                                      : 'N${controller.text} withdrawn successfully'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed: ${e.toString()}')),
                              );
                            }
                            setDialogState(() => isLoading = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final WalletTransactionModel transaction;

  const _TransactionItem({required this.transaction});

  IconData get _icon {
    final title = transaction.title.toLowerCase();
    if (title.contains('health')) return Icons.medical_services_outlined;
    if (title.contains('car') || title.contains('motor')) return Icons.directions_car_outlined;
    if (title.contains('bike')) return Icons.two_wheeler_outlined;
    if (title.contains('top-up') || title.contains('topup')) return Icons.account_balance_wallet_outlined;
    if (title.contains('withdraw')) return Icons.arrow_upward;
    if (title.contains('cashback') || title.contains('reward')) return Icons.card_giftcard_outlined;
    return Icons.receipt_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (transaction.isDebit ? AppColors.error : Colors.green)
                    .withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _icon,
                color: transaction.isDebit ? AppColors.error : Colors.green,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    dateFormat.format(transaction.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              transaction.formattedAmount,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: transaction.isDebit ? AppColors.error : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
