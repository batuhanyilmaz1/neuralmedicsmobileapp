import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class UserFirestoreService {
  UserFirestoreService._();
  static final UserFirestoreService instance = UserFirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(doc);
  }

  Future<UserProfile> upsertProfile({
    required User user,
    String? displayName,
  }) async {
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw Exception('The signed-in user has no email address.');
    }

    final ref = _users.doc(user.uid);
    final existing = await ref.get();
    final name = (displayName ?? user.displayName ?? '').trim();

    if (existing.exists) {
      await ref.set(
        {
          'email': email,
          if (name.isNotEmpty) 'displayName': name,
        },
        SetOptions(merge: true),
      );
    } else {
      await ref.set(
        UserProfile(
          uid: user.uid,
          email: email,
          displayName: name,
          createdAt: DateTime.now(),
        ).toFirestore(),
      );
    }

    final updated = await ref.get();
    return UserProfile.fromFirestore(updated);
  }

  Future<UserProfile> updateHealthProfile({
    required String uid,
    required int age,
    required String gender,
    required double weightKg,
    required double heightCm,
    int? dailyCaloriesKcal,
    String? bloodType,
    bool markCompleted = true,
  }) async {
    final ref = _users.doc(uid);
    final existing = await ref.get();
    if (!existing.exists) {
      throw Exception('User profile not found.');
    }

    await ref.set(
      {
        'age': age,
        'gender': gender,
        'weightKg': weightKg,
        'heightCm': heightCm,
        if (dailyCaloriesKcal != null) 'dailyCaloriesKcal': dailyCaloriesKcal,
        if (bloodType != null && bloodType.isNotEmpty) 'bloodType': bloodType,
        'healthProfileCompleted': markCompleted,
        'heartRateBpm': FieldValue.delete(),
      },
      SetOptions(merge: true),
    );

    final updated = await ref.get();
    return UserProfile.fromFirestore(updated);
  }
}
