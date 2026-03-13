import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { processing, underReview, approved, rejected, completed }

class OrderModel {
  final String id;
  final String userId;
  final String insuranceType;
  final String? planId;
  final String? planCompany;
  final double amount;
  final OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.insuranceType,
    this.planId,
    this.planCompany,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  String get statusName {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.underReview:
        return 'Under Review';
      case OrderStatus.approved:
        return 'Approved';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.completed:
        return 'Completed';
    }
  }

  String get formattedAmount {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'N$formatted';
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      userId: map['userId'] ?? '',
      insuranceType: map['insuranceType'] ?? '',
      planId: map['planId'],
      planCompany: map['planCompany'],
      amount: (map['amount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.processing,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'insuranceType': insuranceType,
      'planId': planId,
      'planCompany': planCompany,
      'amount': amount,
      'status': status.name,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
