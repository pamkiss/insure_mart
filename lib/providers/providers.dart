import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/insurance_policy_model.dart';
import '../models/insurance_plan_model.dart';
import '../models/wallet_model.dart';
import '../models/order_model.dart';
import '../models/reminder_model.dart';
import '../models/hospital_model.dart';
import '../models/consultant_model.dart';
import '../models/booking_model.dart';
import '../services/notification_service.dart';
import 'auth_provider.dart';

// ---- Core Services ----

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(
    authService: ref.watch(authServiceProvider),
    firestoreService: ref.watch(firestoreServiceProvider),
  );
});

// ---- Insurance Policies ----

final userPoliciesProvider = StreamProvider<List<InsurancePolicyModel>>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value([]);
  }
  return firestore.getUserPolicies(auth.firebaseUser!.uid);
});

// ---- Insurance Plans ----

final insurancePlansProvider = StreamProvider.family<List<InsurancePlanModel>, String?>((ref, type) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getInsurancePlans(type: type);
});

// ---- Wallet ----

final walletProvider = StreamProvider<WalletModel?>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value(null);
  }
  return firestore.getUserWallet(auth.firebaseUser!.uid);
});

final walletTransactionsProvider = StreamProvider<List<WalletTransactionModel>>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value([]);
  }
  return firestore.getWalletTransactions(auth.firebaseUser!.uid);
});

// ---- Orders ----

final pendingOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value([]);
  }
  return firestore.getUserOrders(auth.firebaseUser!.uid, pendingOnly: true);
});

// ---- Reminders ----

final remindersProvider = StreamProvider<List<ReminderModel>>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value([]);
  }
  return firestore.getUserReminders(auth.firebaseUser!.uid);
});

// ---- Hospitals ----

final hospitalsProvider = StreamProvider<List<HospitalModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getHospitals();
});

// ---- Consultants ----

final consultantsProvider = StreamProvider<List<ConsultantModel>>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.getConsultants();
});

// ---- Bookings ----

final userBookingsProvider = StreamProvider<List<BookingModel>>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  if (!auth.isAuthenticated || auth.firebaseUser == null) {
    return Stream.value([]);
  }
  return firestore.getUserBookings(auth.firebaseUser!.uid);
});

// ---- Notification Service ----

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
