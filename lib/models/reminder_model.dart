import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderStatus { upcoming, overdue, completed }

class ReminderModel {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final DateTime dueDate;
  final ReminderStatus status;
  final String? policyId;
  final DateTime createdAt;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.policyId,
    required this.createdAt,
  });

  String get statusName {
    switch (status) {
      case ReminderStatus.upcoming:
        return 'Upcoming';
      case ReminderStatus.overdue:
        return 'Overdue';
      case ReminderStatus.completed:
        return 'Paid';
    }
  }

  String get formattedAmount {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'N$formatted';
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReminderModel(
      id: docId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReminderStatus.upcoming,
      ),
      policyId: map['policyId'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'amount': amount,
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.name,
      'policyId': policyId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
