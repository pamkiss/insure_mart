import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final int rating;
  final String? message;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.rating,
    this.message,
    required this.createdAt,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      userId: map['userId'] ?? '',
      rating: map['rating'] ?? 0,
      message: map['message'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
