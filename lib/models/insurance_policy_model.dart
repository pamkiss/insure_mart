import 'package:cloud_firestore/cloud_firestore.dart';

enum PolicyStatus { active, expired, cancelled }

enum InsuranceType { health, car, bike, termPlan }

class InsurancePolicyModel {
  final String id;
  final String userId;
  final InsuranceType type;
  final String provider;
  final double coverageAmount;
  final double premiumAmount;
  final PolicyStatus status;
  final DateTime startDate;
  final DateTime expiryDate;
  final String? policyNumber;
  final String? documentUrl;
  final DateTime createdAt;

  InsurancePolicyModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.provider,
    required this.coverageAmount,
    required this.premiumAmount,
    required this.status,
    required this.startDate,
    required this.expiryDate,
    this.policyNumber,
    this.documentUrl,
    required this.createdAt,
  });

  String get typeName {
    switch (type) {
      case InsuranceType.health:
        return 'Health Insurance';
      case InsuranceType.car:
        return 'Car Insurance';
      case InsuranceType.bike:
        return 'Bike Insurance';
      case InsuranceType.termPlan:
        return 'Term Plan Insurance';
    }
  }

  String get statusName {
    switch (status) {
      case PolicyStatus.active:
        return 'Active';
      case PolicyStatus.expired:
        return 'Expired';
      case PolicyStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory InsurancePolicyModel.fromMap(Map<String, dynamic> map, String docId) {
    return InsurancePolicyModel(
      id: docId,
      userId: map['userId'] ?? '',
      type: InsuranceType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => InsuranceType.health,
      ),
      provider: map['provider'] ?? '',
      coverageAmount: (map['coverageAmount'] ?? 0).toDouble(),
      premiumAmount: (map['premiumAmount'] ?? 0).toDouble(),
      status: PolicyStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PolicyStatus.active,
      ),
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate: (map['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      policyNumber: map['policyNumber'],
      documentUrl: map['documentUrl'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.name,
      'provider': provider,
      'coverageAmount': coverageAmount,
      'premiumAmount': premiumAmount,
      'status': status.name,
      'startDate': Timestamp.fromDate(startDate),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'policyNumber': policyNumber,
      'documentUrl': documentUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  InsurancePolicyModel copyWith({
    String? id,
    String? userId,
    InsuranceType? type,
    String? provider,
    double? coverageAmount,
    double? premiumAmount,
    PolicyStatus? status,
    DateTime? startDate,
    DateTime? expiryDate,
    String? policyNumber,
    String? documentUrl,
    DateTime? createdAt,
  }) {
    return InsurancePolicyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      provider: provider ?? this.provider,
      coverageAmount: coverageAmount ?? this.coverageAmount,
      premiumAmount: premiumAmount ?? this.premiumAmount,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      policyNumber: policyNumber ?? this.policyNumber,
      documentUrl: documentUrl ?? this.documentUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
