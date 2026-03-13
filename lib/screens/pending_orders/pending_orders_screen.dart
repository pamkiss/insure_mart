import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/order_model.dart';
import '../../providers/providers.dart';

class PendingOrdersScreen extends ConsumerWidget {
  const PendingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(pendingOrdersProvider);

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
                    'Pending Orders',
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
              child: ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load orders',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 64, color: AppColors.textGray.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text(
                            'No pending orders',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _OrderCard(order: orders[index]);
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
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  IconData get _icon {
    final type = order.insuranceType.toLowerCase();
    if (type.contains('health')) return Icons.medical_services_outlined;
    if (type.contains('car') || type.contains('motor')) return Icons.directions_car_outlined;
    if (type.contains('bike')) return Icons.two_wheeler_outlined;
    return Icons.umbrella_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = order.status == OrderStatus.processing;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: AppColors.primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.insuranceType,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      order.id,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order.formattedAmount,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(order.createdAt),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textGray,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isProcessing
                      ? AppColors.greetingOrange.withAlpha(25)
                      : AppColors.accentCyan.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isProcessing
                        ? AppColors.greetingOrange
                        : AppColors.accentCyan,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
