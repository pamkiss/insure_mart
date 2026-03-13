import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsuranceFormData {
  // Common
  final String insuranceType; // health, motor, bike, termPlan
  final String? planId;
  final String? planCompany;
  final double? premiumAmount;
  final double? coverageAmount;

  // Health Insurance
  final String? gender;
  final String? fullName;
  final List<String> selectedMembers;
  final Map<String, String?> memberAges;

  // Motor Insurance
  final String? carBrand;
  final String? carModel;
  final String? carDetails;
  final String? carValue;
  final List<String> selectedExtensions;

  const InsuranceFormData({
    this.insuranceType = '',
    this.planId,
    this.planCompany,
    this.premiumAmount,
    this.coverageAmount,
    this.gender,
    this.fullName,
    this.selectedMembers = const [],
    this.memberAges = const {},
    this.carBrand,
    this.carModel,
    this.carDetails,
    this.carValue,
    this.selectedExtensions = const [],
  });

  InsuranceFormData copyWith({
    String? insuranceType,
    String? planId,
    String? planCompany,
    double? premiumAmount,
    double? coverageAmount,
    String? gender,
    String? fullName,
    List<String>? selectedMembers,
    Map<String, String?>? memberAges,
    String? carBrand,
    String? carModel,
    String? carDetails,
    String? carValue,
    List<String>? selectedExtensions,
  }) {
    return InsuranceFormData(
      insuranceType: insuranceType ?? this.insuranceType,
      planId: planId ?? this.planId,
      planCompany: planCompany ?? this.planCompany,
      premiumAmount: premiumAmount ?? this.premiumAmount,
      coverageAmount: coverageAmount ?? this.coverageAmount,
      gender: gender ?? this.gender,
      fullName: fullName ?? this.fullName,
      selectedMembers: selectedMembers ?? this.selectedMembers,
      memberAges: memberAges ?? this.memberAges,
      carBrand: carBrand ?? this.carBrand,
      carModel: carModel ?? this.carModel,
      carDetails: carDetails ?? this.carDetails,
      carValue: carValue ?? this.carValue,
      selectedExtensions: selectedExtensions ?? this.selectedExtensions,
    );
  }
}

class InsuranceFormNotifier extends StateNotifier<InsuranceFormData> {
  InsuranceFormNotifier() : super(const InsuranceFormData());

  void reset() => state = const InsuranceFormData();

  void setInsuranceType(String type) {
    state = state.copyWith(insuranceType: type);
  }

  // Health Insurance
  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setFullName(String name) {
    state = state.copyWith(fullName: name);
  }

  void setSelectedMembers(List<String> members) {
    state = state.copyWith(selectedMembers: members);
  }

  void setMemberAges(Map<String, String?> ages) {
    state = state.copyWith(memberAges: ages);
  }

  // Motor Insurance
  void setCarBrand(String brand) {
    state = state.copyWith(carBrand: brand);
  }

  void setCarModel(String model, String details, String value) {
    state = state.copyWith(
      carModel: model,
      carDetails: details,
      carValue: value,
    );
  }

  void setExtensions(List<String> extensions) {
    state = state.copyWith(selectedExtensions: extensions);
  }

  // Plan selection (from quotes screen)
  void selectPlan({
    required String planId,
    required String company,
    required double premium,
    required double coverage,
  }) {
    state = state.copyWith(
      planId: planId,
      planCompany: company,
      premiumAmount: premium,
      coverageAmount: coverage,
    );
  }
}

final insuranceFormProvider =
    StateNotifierProvider<InsuranceFormNotifier, InsuranceFormData>((ref) {
  return InsuranceFormNotifier();
});
