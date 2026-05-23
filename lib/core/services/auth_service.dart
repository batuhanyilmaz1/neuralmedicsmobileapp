import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_profile.dart';
import 'user_firestore_service.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserFirestoreService _users = UserFirestoreService.instance;

  UserProfile? _profile;

  User? get firebaseUser => _auth.currentUser;
  UserProfile? get profile => _profile;
  bool get isLoggedIn => _auth.currentUser != null;

  bool get needsHealthProfileSetup =>
      isLoggedIn &&
      _profile != null &&
      _profile!.healthProfileCompleted != true;

  String get postAuthRoute =>
      needsHealthProfileSetup ? '/profile-setup' : '/home';

  String get displayName =>
      _profile?.displayName.trim().isNotEmpty == true
          ? _profile!.displayName
          : _auth.currentUser?.displayName?.trim().isNotEmpty == true
              ? _auth.currentUser!.displayName!
              : _auth.currentUser?.email ?? 'Kullanıcı';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserProfile?> loadSessionProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      _profile = null;
      return null;
    }
    _profile = await _users.getProfile(user.uid) ??
        await _users.upsertProfile(user: user);
    return _profile;
  }

  Future<UserProfile> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedName = name.trim();

    final credential = await _auth.createUserWithEmailAndPassword(
      email: trimmedEmail,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Hesap oluşturulamadı.');
    }

    if (trimmedName.isNotEmpty) {
      await user.updateDisplayName(trimmedName);
    }

    _profile = await _users.upsertProfile(
      user: user,
      displayName: trimmedName,
    );
    return _profile!;
  }

  /// Returns `null` when the user cancels the Google sign-in sheet.
  Future<UserProfile?> signInWithGoogle() async {
    try {
      final UserCredential credential;
      if (kIsWeb) {
        credential = await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        final account = await GoogleSignIn.instance.authenticate();
        final idToken = account.authentication.idToken;
        if (idToken == null || idToken.isEmpty) {
          throw Exception('Google oturum açma kimlik belirteci alınamadı.');
        }
        credential = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(idToken: idToken),
        );
      }

      final user = credential.user;
      if (user == null) {
        throw Exception('Google ile giriş başarısız.');
      }

      _profile = await _users.getProfile(user.uid) ??
          await _users.upsertProfile(user: user);
      return _profile;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Giriş başarısız.');
    }

    _profile = await _users.getProfile(user.uid) ??
        await _users.upsertProfile(user: user);
    return _profile!;
  }

  Future<UserProfile> updateHealthProfile({
    required int age,
    required String gender,
    required double weightKg,
    required double heightCm,
    int? dailyCaloriesKcal,
    String? bloodType,
    bool markCompleted = true,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('Oturum bulunamadı.');
    }

    _profile = await _users.updateHealthProfile(
      uid: uid,
      age: age,
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      dailyCaloriesKcal: dailyCaloriesKcal,
      bloodType: bloodType,
      markCompleted: markCompleted,
    );
    return _profile!;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// E-posta/şifre ile kayıtlı hesaplar için true döner.
  bool get canResetPassword {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((info) => info.providerId == 'password');
  }

  Future<void> sendPasswordResetToCurrentUser() async {
    final email = _auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw Exception('Hesabınıza bağlı e-posta bulunamadı.');
    }
    if (!canResetPassword) {
      throw Exception(
        'Bu hesap Google ile giriş yapıyor. Şifre sıfırlama yalnızca '
        'e-posta/şifre hesapları için geçerlidir.',
      );
    }
    await sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
    _profile = null;
  }

  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Geçerli bir e-posta adresi girin.';
        case 'user-disabled':
          return 'Bu hesap devre dışı bırakılmış.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-posta veya şifre hatalı.';
        case 'email-already-in-use':
          return 'Bu e-posta ile kayıtlı bir hesap zaten var.';
        case 'weak-password':
          return 'Şifre en az 6 karakter olmalıdır.';
        case 'too-many-requests':
          return 'Çok fazla deneme. Lütfen daha sonra tekrar deneyin.';
        case 'account-exists-with-different-credential':
          return 'Bu e-posta farklı bir giriş yöntemiyle kayıtlı.';
        case 'popup-closed-by-user':
          return 'Giriş iptal edildi.';
        default:
          return error.message ?? 'Kimlik doğrulama başarısız.';
      }
    }
    if (error is GoogleSignInException) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
          return 'Giriş iptal edildi.';
        default:
          return error.description ?? 'Google ile giriş başarısız.';
      }
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}
