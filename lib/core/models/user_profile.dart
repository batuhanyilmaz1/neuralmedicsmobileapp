import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.age,
    this.gender,
    this.weightKg,
    this.heightCm,
    this.dailyCaloriesKcal,
    this.bloodType,
    this.healthProfileCompleted = false,
  });

  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final int? age;
  final String? gender;
  final double? weightKg;
  final double? heightCm;
  final int? dailyCaloriesKcal;
  final String? bloodType;
  final bool healthProfileCompleted;

  String get ageDisplay => age != null ? '$age' : '—';

  String get heightDisplay =>
      heightCm != null ? '${heightCm!.toStringAsFixed(0)} cm' : '—';

  String get caloriesDisplay =>
      dailyCaloriesKcal != null ? '$dailyCaloriesKcal kcal' : '—';

  String get weightDisplay =>
      weightKg != null ? '${weightKg!.toStringAsFixed(1)} kg' : '—';

  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm! <= 0) return null;
    final meters = heightCm! / 100;
    return weightKg! / (meters * meters);
  }

  String get bmiDisplay =>
      bmi != null ? bmi!.toStringAsFixed(1) : '—';

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfile(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      age: data['age'] as int?,
      gender: data['gender'] as String?,
      weightKg: (data['weightKg'] as num?)?.toDouble(),
      heightCm: (data['heightCm'] as num?)?.toDouble(),
      dailyCaloriesKcal: data['dailyCaloriesKcal'] as int?,
      bloodType: data['bloodType'] as String?,
      healthProfileCompleted: data['healthProfileCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (weightKg != null) 'weightKg': weightKg,
      if (heightCm != null) 'heightCm': heightCm,
      if (dailyCaloriesKcal != null) 'dailyCaloriesKcal': dailyCaloriesKcal,
      if (bloodType != null) 'bloodType': bloodType,
      'healthProfileCompleted': healthProfileCompleted,
    };
  }

  UserProfile copyWith({
    String? email,
    String? displayName,
    DateTime? createdAt,
    int? age,
    String? gender,
    double? weightKg,
    double? heightCm,
    int? dailyCaloriesKcal,
    String? bloodType,
    bool? healthProfileCompleted,
  }) {
    return UserProfile(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      dailyCaloriesKcal: dailyCaloriesKcal ?? this.dailyCaloriesKcal,
      bloodType: bloodType ?? this.bloodType,
      healthProfileCompleted:
          healthProfileCompleted ?? this.healthProfileCompleted,
    );
  }
}
