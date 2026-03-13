class HospitalModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double rating;
  final double? latitude;
  final double? longitude;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.rating,
    this.latitude,
    this.longitude,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> map, String docId) {
    return HospitalModel(
      id: docId,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
