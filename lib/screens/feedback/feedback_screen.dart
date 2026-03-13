import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/feedback_model.dart';
import '../../providers/providers.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool _isSubmitting = false;
  int _selectedRating = 4;
  final _messageController = TextEditingController();

  final _ratingLabels = [
    'Terrible',
    'Bad',
    'Okay',
    'Good',
    'It\'s Excellent',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'How was your overall\nexperience?',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'It will help us to serve you better',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.accentCyan,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Star rating
                    _buildStarRating(),
                    const SizedBox(height: 8),
                    Text(
                      _ratingLabels[_selectedRating - 1],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Message input
                    Text(
                      'Your message ( optional )',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Please specify in detail',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textGray,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: _isSubmitting ? 'Submitting...' : 'Submit',
                onPressed: _isSubmitting ? null : () async {
                  final auth = ref.read(authProvider);
                  if (!auth.isAuthenticated || auth.firebaseUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to submit feedback')),
                    );
                    return;
                  }

                  setState(() => _isSubmitting = true);

                  final feedback = FeedbackModel(
                    id: '',
                    userId: auth.firebaseUser!.uid,
                    rating: _selectedRating,
                    message: _messageController.text.trim().isEmpty
                        ? null
                        : _messageController.text.trim(),
                    createdAt: DateTime.now(),
                  );

                  try {
                    final firestore = ref.read(firestoreServiceProvider);
                    await firestore.submitFeedback(feedback);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your feedback!'),
                          backgroundColor: AppColors.accentCyan,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } catch (_) {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to submit feedback. Please try again.')),
                      );
                    }
                  }
                },
                type: ButtonType.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final isSelected = index < _selectedRating;
          return GestureDetector(
            onTap: () => setState(() => _selectedRating = index + 1),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _StarFace(
                isSelected: isSelected,
                size: 52,
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          '$_selectedRating.0',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _StarFace extends StatelessWidget {
  final bool isSelected;
  final double size;

  const _StarFace({
    required this.isSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarFacePainter(isSelected: isSelected),
    );
  }
}

class _StarFacePainter extends CustomPainter {
  final bool isSelected;

  _StarFacePainter({required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Star body color
    final bodyColor = isSelected
        ? const Color(0xFF4CAF50)
        : const Color(0xFFB0BEC5);

    // Draw star shape
    final starPath = _createStarPath(center, radius, radius * 0.55);
    canvas.drawPath(starPath, Paint()..color = bodyColor);

    // Draw face
    final facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Eyes
    canvas.drawCircle(
      Offset(center.dx - radius * 0.22, center.dy - radius * 0.05),
      radius * 0.08,
      facePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.22, center.dy - radius * 0.05),
      radius * 0.08,
      facePaint,
    );

    // Smile
    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.12);
    smilePath.quadraticBezierTo(
      center.dx, center.dy + radius * 0.32,
      center.dx + radius * 0.2, center.dy + radius * 0.12,
    );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _createStarPath(Offset center, double outerRadius, double innerRadius) {
    final path = Path();
    const points = 5;
    const rotation = -90 * 3.14159 / 180;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 3.14159 / points) + rotation;
      final x = center.dx + radius * cosine(angle);
      final y = center.dy + radius * sine(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  double cosine(double angle) => _cos(angle);
  double sine(double angle) => _sin(angle);

  static double _cos(double x) {
    // Taylor series approximation
    x = x % (2 * 3.14159265359);
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _sin(double x) {
    x = x % (2 * 3.14159265359);
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _StarFacePainter oldDelegate) =>
      isSelected != oldDelegate.isSelected;
}
