import '../models/hospital_model.dart';
import '../models/consultant_model.dart';
import '../models/insurance_plan_model.dart';
import 'firestore_service.dart';

/// Seeds initial data into Firestore.
/// Call this once from settings or a debug screen.
class SeedService {
  final FirestoreService _firestore;

  SeedService(this._firestore);

  Future<void> seedAll() async {
    await seedHospitals();
    await seedConsultants();
    await seedInsurancePlans();
  }

  Future<void> seedHospitals() async {
    final hospitals = [
      HospitalModel(
        id: '',
        name: 'Lagos University Teaching Hospital',
        address: 'Idi-Araba, Surulere, Lagos',
        phone: '+234 802 345 6789',
        rating: 4.5,
        latitude: 6.5158,
        longitude: 3.3575,
      ),
      HospitalModel(
        id: '',
        name: 'Reddington Hospital',
        address: '12 Idowu Martins St, Victoria Island',
        phone: '+234 803 456 7890',
        rating: 4.8,
        latitude: 6.4281,
        longitude: 3.4219,
      ),
      HospitalModel(
        id: '',
        name: 'Evercare Hospital',
        address: '2 Admiralty Way, Lekki Phase 1',
        phone: '+234 804 567 8901',
        rating: 4.7,
        latitude: 6.4412,
        longitude: 3.4762,
      ),
      HospitalModel(
        id: '',
        name: 'First Consultant Medical Centre',
        address: '29 Falomo Rd, Ikoyi, Lagos',
        phone: '+234 805 678 9012',
        rating: 4.3,
        latitude: 6.4491,
        longitude: 3.4318,
      ),
      HospitalModel(
        id: '',
        name: 'St. Nicholas Hospital',
        address: '57 Campbell St, Lagos Island',
        phone: '+234 806 789 0123',
        rating: 4.4,
        latitude: 6.4531,
        longitude: 3.3958,
      ),
    ];

    for (final h in hospitals) {
      await _firestore.addHospital(h);
    }
  }

  Future<void> seedConsultants() async {
    final consultants = [
      ConsultantModel(
        id: '',
        name: 'Dr. Adebayo Oluwaseun',
        specialty: 'Health Insurance Advisor',
        rating: 4.9,
        experience: '12 years',
      ),
      ConsultantModel(
        id: '',
        name: 'Mrs. Funke Adesanya',
        specialty: 'Motor Insurance Specialist',
        rating: 4.7,
        experience: '8 years',
      ),
      ConsultantModel(
        id: '',
        name: 'Mr. Chukwudi Okafor',
        specialty: 'Life & Term Insurance',
        rating: 4.8,
        experience: '15 years',
      ),
      ConsultantModel(
        id: '',
        name: 'Mrs. Halima Bello',
        specialty: 'Claims & Policy Review',
        rating: 4.6,
        experience: '6 years',
      ),
    ];

    for (final c in consultants) {
      await _firestore.addConsultant(c);
    }
  }

  Future<void> seedInsurancePlans() async {
    final plans = [
      InsurancePlanModel(
        id: '',
        company: 'Custodian & Allied Insurance',
        cover: '1 Car',
        addonsCount: 3,
        policyTerm: '1 year',
        premiumAmount: 95800,
        insuranceType: 'motor',
        features: [
          'Replacement cost or repair costs',
          'Medical Expenses',
          'Theft protection',
          'Fire damage cover',
        ],
        rating: 4.5,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'Leadway Assurance Plc',
        cover: '1 Car',
        addonsCount: 0,
        policyTerm: '1 year',
        premiumAmount: 181700,
        insuranceType: 'motor',
        features: [
          'Comprehensive cover',
          'Third party liability',
          'Towing services',
        ],
        rating: 4.3,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'Allianz Nigeria Insurance Plc',
        cover: '2 Cars',
        addonsCount: 1,
        policyTerm: '1 year',
        premiumAmount: 121800,
        insuranceType: 'motor',
        features: [
          'Multi-car discount',
          'Roadside assistance',
          'Personal accident cover',
        ],
        rating: 4.6,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'AXA Mansard Insurance',
        cover: 'Individual',
        addonsCount: 2,
        policyTerm: '1 year',
        premiumAmount: 125000,
        insuranceType: 'health',
        features: [
          'Inpatient & outpatient care',
          'Dental coverage',
          'Optical coverage',
          'Maternity cover',
        ],
        rating: 4.7,
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'Hygeia HMO',
        cover: 'Family',
        addonsCount: 1,
        policyTerm: '1 year',
        premiumAmount: 250000,
        insuranceType: 'health',
        features: [
          'Family coverage up to 6 members',
          'Specialist consultations',
          'Hospital admission',
        ],
        rating: 4.4,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'AIICO Insurance Plc',
        cover: '1 Car',
        addonsCount: 1,
        policyTerm: '1 year',
        premiumAmount: 110200,
        insuranceType: 'motor',
        features: [
          'Comprehensive motor cover',
          'Personal accident',
          'Third party extension',
        ],
        rating: 4.2,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      InsurancePlanModel(
        id: '',
        company: 'Mansard Insurance Plc',
        cover: '1 Car',
        addonsCount: 2,
        policyTerm: '1 year',
        premiumAmount: 89500,
        insuranceType: 'motor',
        features: [
          'Affordable comprehensive plan',
          'Excess buy-back option',
          'Flood extension',
        ],
        rating: 4.1,
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
    ];

    for (final p in plans) {
      await _firestore.createPlan(p);
    }
  }
}
