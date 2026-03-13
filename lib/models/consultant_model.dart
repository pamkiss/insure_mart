class ConsultantModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String experience;
  final bool isAvailable;

  ConsultantModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    this.isAvailable = true,
  });

  factory ConsultantModel.fromMap(Map<String, dynamic> map, String docId) {
    return ConsultantModel(
      id: docId,
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      experience: map['experience'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'experience': experience,
      'isAvailable': isAvailable,
    };
  }
}
