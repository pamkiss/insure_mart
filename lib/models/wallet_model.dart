import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { credit, debit }

class WalletModel {
  final String userId;
  final double balance;
  final DateTime updatedAt;

  WalletModel({
    required this.userId,
    required this.balance,
    required this.updatedAt,
  });

  String get formattedBalance {
    final amount = balance.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return 'N$amount';
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      userId: map['userId'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class WalletTransactionModel {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final TransactionType type;
  final String? description;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    this.description,
    required this.createdAt,
  });

  bool get isDebit => type == TransactionType.debit;

  String get formattedAmount {
    final prefix = isDebit ? '-' : '+';
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${prefix}N$formatted';
  }

  factory WalletTransactionModel.fromMap(Map<String, dynamic> map, String docId) {
    return WalletTransactionModel(
      id: docId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.debit,
      ),
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type.name,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
