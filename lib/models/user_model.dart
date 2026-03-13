import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? fullName;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final String? occupation;
  final String? address;
  final String? dateOfBirth;
  final String? authMethod;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    this.fullName,
    this.email,
    this.username,
    this.phoneNumber,
    this.occupation,
    this.address,
    this.dateOfBirth,
    this.authMethod,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'],
      email: map['email'],
      username: map['username'],
      phoneNumber: map['phoneNumber'],
      occupation: map['occupation'],
      address: map['address'],
      dateOfBirth: map['dateOfBirth'],
      authMethod: map['authMethod'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'authMethod': authMethod,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (username != null && username!.isNotEmpty) return username!;
    if (email != null && email!.isNotEmpty) return email!.split('@').first;
    return 'User';
  }
}
