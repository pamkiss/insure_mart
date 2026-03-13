import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/reminder_model.dart';
import '../../providers/providers.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersProvider);

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
                    'Reminders',
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
              child: remindersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load reminders',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (reminders) {
                  if (reminders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_none,
                              size: 64, color: AppColors.textGray.withAlpha(100)),
                          const SizedBox(height: 16),
                          Text(
                            'No reminders',
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
                    itemCount: reminders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ReminderItem(reminder: reminders[index]);
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

class _ReminderItem extends StatelessWidget {
  final ReminderModel reminder;

  const _ReminderItem({required this.reminder});

  Color get _statusColor {
    switch (reminder.status) {
      case ReminderStatus.overdue:
        return AppColors.error;
      case ReminderStatus.completed:
        return Colors.green;
      case ReminderStatus.upcoming:
        return AppColors.greetingOrange;
    }
  }

  IconData get _statusIcon {
    switch (reminder.status) {
      case ReminderStatus.overdue:
        return Icons.warning_amber_rounded;
      case ReminderStatus.completed:
        return Icons.check_circle_outline;
      case ReminderStatus.upcoming:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Due: ${dateFormat.format(reminder.dueDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
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
                reminder.formattedAmount,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  reminder.statusName,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
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
