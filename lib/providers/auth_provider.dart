import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, authenticating }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthStatus _status = AuthStatus.uninitialized;
  User? _firebaseUser;
  UserModel? _userModel;
  String? _verificationId;
  int? _resendToken;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String get displayName => _userModel?.displayName ?? 'User';

  AuthProvider({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      _status = AuthStatus.unauthenticated;
      _firebaseUser = null;
      _userModel = null;
    } else {
      _firebaseUser = user;
      _userModel = await _firestoreService.getUserProfile(user.uid);
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  // ---- Phone Auth ----

  Future<bool> verifyPhoneNumber(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    final completer = Completer<bool>();

    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onVerificationCompleted: (credential) async {
        await _authService.signInWithPhoneCredential(credential);
        _setLoading(false);
        if (!completer.isCompleted) completer.complete(true);
      },
      onVerificationFailed: (e) {
        _setError(e.message ?? 'Phone verification failed');
        _setLoading(false);
        if (!completer.isCompleted) completer.complete(false);
      },
      onCodeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        _setLoading(false);
        if (!completer.isCompleted) completer.complete(true);
      },
      onCodeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
      forceResendingToken: _resendToken,
    );

    return completer.future;
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) {
      _setError('Verification session expired. Please resend OTP.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final credential = _authService.createPhoneCredential(
          _verificationId!, smsCode);
      await _authService.signInWithPhoneCredential(credential);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Invalid OTP');
      _setLoading(false);
      return false;
    }
  }

  // ---- Email Auth ----

  Future<bool> signUpWithEmail(
      String email, String password, String username) async {
    _setLoading(true);
    _clearError();

    try {
      final cred = await _authService.signUpWithEmail(email, password);
      final user = UserModel(
        uid: cred.user!.uid,
        email: email,
        username: username,
        authMethod: 'email',
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveUserProfile(user);
      await _firestoreService.initializeWallet(cred.user!.uid);
      _userModel = user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  // ---- Google Auth ----

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final cred = await _authService.signInWithGoogle();
      // Create profile if new user
      final existing =
          await _firestoreService.getUserProfile(cred.user!.uid);
      if (existing == null) {
        final user = UserModel(
          uid: cred.user!.uid,
          fullName: cred.user!.displayName,
          email: cred.user!.email,
          authMethod: 'google',
          createdAt: DateTime.now(),
        );
        await _firestoreService.saveUserProfile(user);
        await _firestoreService.initializeWallet(cred.user!.uid);
        _userModel = user;
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ---- Password Reset ----

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  // ---- Profile ----

  Future<bool> createUserProfile(UserModel user) async {
    _setLoading(true);
    _clearError();

    try {
      await _firestoreService.saveUserProfile(user);
      _userModel = user;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save profile');
      _setLoading(false);
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  // ---- Sign Out ----

  Future<void> signOut() async {
    await _authService.signOut();
  }

  // ---- Helpers ----

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak (min 6 characters)';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}
