import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/insurance_policy_model.dart';
import '../models/insurance_plan_model.dart';
import '../models/wallet_model.dart';
import '../models/order_model.dart';
import '../models/reminder_model.dart';
import '../models/hospital_model.dart';
import '../models/consultant_model.dart';
import '../models/booking_model.dart';
import '../models/feedback_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- Users ----

  Future<void> saveUserProfile(UserModel user) {
    return _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).update(data);
  }

  Future<bool> isUsernameTaken(String username) async {
    final query = await _db
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  // ---- Insurance Policies ----

  Future<String> createPolicy(InsurancePolicyModel policy) async {
    final doc = await _db.collection('policies').add(policy.toMap());
    return doc.id;
  }

  Stream<List<InsurancePolicyModel>> getUserPolicies(String userId) {
    return _db
        .collection('policies')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => InsurancePolicyModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updatePolicyStatus(String policyId, PolicyStatus status) {
    return _db.collection('policies').doc(policyId).update({
      'status': status.name,
    });
  }

  // ---- Insurance Plans ----

  Stream<List<InsurancePlanModel>> getInsurancePlans({String? type}) {
    Query<Map<String, dynamic>> query = _db.collection('plans');
    if (type != null) {
      query = query.where('insuranceType', isEqualTo: type);
    }
    return query.orderBy('isFeatured', descending: true).snapshots().map(
        (snap) => snap.docs
            .map((doc) => InsurancePlanModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<InsurancePlanModel?> getPlan(String planId) async {
    final doc = await _db.collection('plans').doc(planId).get();
    if (!doc.exists || doc.data() == null) return null;
    return InsurancePlanModel.fromMap(doc.data()!, doc.id);
  }

  Future<String> createPlan(InsurancePlanModel plan) async {
    final doc = await _db.collection('plans').add(plan.toMap());
    return doc.id;
  }

  // ---- Wallet ----

  Stream<WalletModel?> getUserWallet(String userId) {
    return _db
        .collection('wallets')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return WalletModel.fromMap(doc.data()!);
    });
  }

  Future<void> initializeWallet(String userId) {
    return _db.collection('wallets').doc(userId).set({
      'userId': userId,
      'balance': 0.0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWalletBalance(String userId, double newBalance) {
    return _db.collection('wallets').doc(userId).update({
      'balance': newBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> addWalletTransaction(WalletTransactionModel transaction) async {
    final doc = await _db
        .collection('wallets')
        .doc(transaction.userId)
        .collection('transactions')
        .add(transaction.toMap());
    return doc.id;
  }

  Stream<List<WalletTransactionModel>> getWalletTransactions(String userId) {
    return _db
        .collection('wallets')
        .doc(userId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => WalletTransactionModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ---- Orders ----

  Future<String> createOrder(OrderModel order) async {
    final doc = await _db.collection('orders').add(order.toMap());
    return doc.id;
  }

  Stream<List<OrderModel>> getUserOrders(String userId, {bool pendingOnly = false}) {
    Query<Map<String, dynamic>> query = _db
        .collection('orders')
        .where('userId', isEqualTo: userId);

    if (pendingOnly) {
      query = query.where('status', whereIn: ['processing', 'underReview']);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) {
    return _db.collection('orders').doc(orderId).update({
      'status': status.name,
    });
  }

  // ---- Reminders ----

  Future<String> createReminder(ReminderModel reminder) async {
    final doc = await _db.collection('reminders').add(reminder.toMap());
    return doc.id;
  }

  Stream<List<ReminderModel>> getUserReminders(String userId) {
    return _db
        .collection('reminders')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ReminderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateReminderStatus(String reminderId, ReminderStatus status) {
    return _db.collection('reminders').doc(reminderId).update({
      'status': status.name,
    });
  }

  // ---- Hospitals ----

  Stream<List<HospitalModel>> getHospitals() {
    return _db
        .collection('hospitals')
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => HospitalModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<String> addHospital(HospitalModel hospital) async {
    final doc = await _db.collection('hospitals').add(hospital.toMap());
    return doc.id;
  }

  // ---- Consultants ----

  Stream<List<ConsultantModel>> getConsultants() {
    return _db
        .collection('consultants')
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ConsultantModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<String> addConsultant(ConsultantModel consultant) async {
    final doc = await _db.collection('consultants').add(consultant.toMap());
    return doc.id;
  }

  // ---- Bookings ----

  Future<String> createBooking(BookingModel booking) async {
    final doc = await _db.collection('bookings').add(booking.toMap());
    return doc.id;
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) {
    return _db.collection('bookings').doc(bookingId).update({
      'status': status.name,
    });
  }

  // ---- Feedback ----

  Future<String> submitFeedback(FeedbackModel feedback) async {
    final doc = await _db.collection('feedback').add(feedback.toMap());
    return doc.id;
  }
}
