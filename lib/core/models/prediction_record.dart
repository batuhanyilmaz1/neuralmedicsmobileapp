class PredictionRecord {
  const PredictionRecord({
    this.id,
    required this.userId,
    required this.topClassId,
    required this.topClassLabel,
    required this.confidence,
    required this.usedMock,
    required this.inferenceMs,
    required this.createdAt,
    this.imagePath,
    this.probabilitiesJson,
  });

  final int? id;
  final String userId;
  final String topClassId;
  final String topClassLabel;
  final double confidence;
  final bool usedMock;
  final int inferenceMs;
  final DateTime createdAt;
  final String? imagePath;
  final String? probabilitiesJson;

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'top_class_id': topClassId,
      'top_class_label': topClassLabel,
      'confidence': confidence,
      'used_mock': usedMock ? 1 : 0,
      'inference_ms': inferenceMs,
      'created_at': createdAt.millisecondsSinceEpoch,
      'image_path': imagePath,
      'probabilities_json': probabilitiesJson,
    };
  }

  factory PredictionRecord.fromMap(Map<String, Object?> map) {
    return PredictionRecord(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      topClassId: map['top_class_id'] as String,
      topClassLabel: map['top_class_label'] as String,
      confidence: (map['confidence'] as num).toDouble(),
      usedMock: (map['used_mock'] as int) == 1,
      inferenceMs: map['inference_ms'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      imagePath: map['image_path'] as String?,
      probabilitiesJson: map['probabilities_json'] as String?,
    );
  }
}
