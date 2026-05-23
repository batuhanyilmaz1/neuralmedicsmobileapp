import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuralmedicsmobileapp/core/models/user_profile.dart';

void main() {
  test('UserProfile toFirestore contains expected fields', () {
    final profile = UserProfile(
      uid: 'uid-1',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: DateTime(2026, 5, 23),
      age: 30,
      gender: 'Erkek',
      weightKg: 75,
      heightCm: 175,
      dailyCaloriesKcal: 2000,
      healthProfileCompleted: true,
    );

    final map = profile.toFirestore();
    expect(map['email'], 'test@example.com');
    expect(map['displayName'], 'Test User');
    expect(map['age'], 30);
    expect(map['healthProfileCompleted'], true);
    expect(map['createdAt'], isA<Timestamp>());
  });
}
