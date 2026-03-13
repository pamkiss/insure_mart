import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/consultant_model.dart';
import '../../models/booking_model.dart';
import '../../providers/providers.dart';

class EConsultationScreen extends ConsumerWidget {
  const EConsultationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultantsAsync = ref.watch(consultantsProvider);

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
                    'eConsultation',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Connect with insurance experts for guidance on your policies and claims.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: consultantsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load consultants',
                    style: GoogleFonts.poppins(color: AppColors.textGray),
                  ),
                ),
                data: (consultants) {
                  if (consultants.isEmpty) {
                    return Center(
                      child: Text(
                        'No consultants available',
                        style: GoogleFonts.poppins(color: AppColors.textGray),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: consultants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _ConsultantCard(consultant: consultants[index]);
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

class _ConsultantCard extends ConsumerWidget {
  final ConsultantModel consultant;

  const _ConsultantCard({required this.consultant});

  void _showBookingDialog(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Book Consultation',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  consultant.specialty,
                  style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray),
                ),
                const SizedBox(height: 16),
                // Date picker
                Text('Date', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: AppColors.textGray),
                        const SizedBox(width: 8),
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Time picker
                Text('Time', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setDialogState(() => selectedTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: AppColors.textGray),
                        const SizedBox(width: 8),
                        Text(
                          selectedTime.format(ctx),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Notes
                Text('Notes (optional)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe your concern...',
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textGray),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
            ),
            ElevatedButton(
              onPressed: () async {
                final auth = ref.read(authProvider);
                if (!auth.isAuthenticated || auth.firebaseUser == null) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to book a consultation')),
                  );
                  return;
                }

                final scheduledAt = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                final booking = BookingModel(
                  id: '',
                  userId: auth.firebaseUser!.uid,
                  consultantId: consultant.id,
                  consultantName: consultant.name,
                  consultantSpecialty: consultant.specialty,
                  scheduledAt: scheduledAt,
                  notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                  status: BookingStatus.pending,
                  createdAt: DateTime.now(),
                );

                final firestore = ref.read(firestoreServiceProvider);
                await firestore.createBooking(booking);

                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Consultation booked with ${consultant.name}'),
                      backgroundColor: AppColors.accentCyan,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Book', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryBlue.withAlpha(25),
            child: Icon(Icons.person,
                color: AppColors.primaryBlue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  consultant.specialty,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.greetingOrange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${consultant.rating}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${consultant.experience} exp.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showBookingDialog(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size.zero,
            ),
            child: Text(
              'Consult',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
