import 'package:cloud_firestore/cloud_firestore.dart';

class InsurancePlanModel {
  final String id;
  final String company;
  final String cover;
  final int addonsCount;
  final String policyTerm;
  final double premiumAmount;
  final String insuranceType; // health, motor, bike, termPlan
  final List<String> features;
  final double? rating;
  final bool isFeatured;
  final DateTime createdAt;

  InsurancePlanModel({
    required this.id,
    required this.company,
    required this.cover,
    required this.addonsCount,
    required this.policyTerm,
    required this.premiumAmount,
    required this.insuranceType,
    this.features = const [],
    this.rating,
    this.isFeatured = false,
    required this.createdAt,
  });

  String get formattedPremium {
    final amount = premiumAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'N$amount/yr';
  }

  String get addonsText => addonsCount == 0 ? 'None' : '$addonsCount Addon${addonsCount > 1 ? 's' : ''}';

  factory InsurancePlanModel.fromMap(Map<String, dynamic> map, String docId) {
    return InsurancePlanModel(
      id: docId,
      company: map['company'] ?? '',
      cover: map['cover'] ?? '',
      addonsCount: map['addonsCount'] ?? 0,
      policyTerm: map['policyTerm'] ?? '1 year',
      premiumAmount: (map['premiumAmount'] ?? 0).toDouble(),
      insuranceType: map['insuranceType'] ?? 'health',
      features: List<String>.from(map['features'] ?? []),
      rating: (map['rating'] as num?)?.toDouble(),
      isFeatured: map['isFeatured'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'cover': cover,
      'addonsCount': addonsCount,
      'policyTerm': policyTerm,
      'premiumAmount': premiumAmount,
      'insuranceType': insuranceType,
      'features': features,
      'rating': rating,
      'isFeatured': isFeatured,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
