import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import '../../features/ai_tumor/tumor_prediction.dart';
import '../database/prediction_database.dart';
import '../models/prediction_record.dart';

class PredictionRepository {
  PredictionRepository._();
  static final PredictionRepository instance = PredictionRepository._();

  Future<PredictionRecord> savePrediction({
    required TumorPrediction prediction,
    String? imagePath,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('You must be signed in to save a prediction.');
    }

    final probs = <String, double>{};
    prediction.probabilities.forEach((key, value) {
      probs[key.id] = value;
    });

    final record = PredictionRecord(
      userId: uid,
      topClassId: prediction.topClass.id,
      topClassLabel: prediction.topClass.label,
      confidence: prediction.confidence,
      usedMock: prediction.usedMock,
      inferenceMs: prediction.inferenceMs,
      createdAt: DateTime.now(),
      imagePath: imagePath,
      probabilitiesJson: jsonEncode(probs),
    );

    final id = await PredictionDatabase.instance.insertPrediction(record);
    return PredictionRecord(
      id: id,
      userId: record.userId,
      topClassId: record.topClassId,
      topClassLabel: record.topClassLabel,
      confidence: record.confidence,
      usedMock: record.usedMock,
      inferenceMs: record.inferenceMs,
      createdAt: record.createdAt,
      imagePath: record.imagePath,
      probabilitiesJson: record.probabilitiesJson,
    );
  }

  Future<List<PredictionRecord>> recentForCurrentUser({int limit = 20}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    return PredictionDatabase.instance.predictionsForUser(uid, limit: limit);
  }
}
