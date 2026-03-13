import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class BookingModel {
  final String id;
  final String userId;
  final String consultantId;
  final String consultantName;
  final String consultantSpecialty;
  final DateTime scheduledAt;
  final String? notes;
  final BookingStatus status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.consultantId,
    required this.consultantName,
    required this.consultantSpecialty,
    required this.scheduledAt,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  String get statusName {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      userId: map['userId'] ?? '',
      consultantId: map['consultantId'] ?? '',
      consultantName: map['consultantName'] ?? '',
      consultantSpecialty: map['consultantSpecialty'] ?? '',
      scheduledAt: (map['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'consultantId': consultantId,
      'consultantName': consultantName,
      'consultantSpecialty': consultantSpecialty,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'notes': notes,
      'status': status.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
