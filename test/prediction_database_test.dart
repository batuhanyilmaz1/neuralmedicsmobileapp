import 'package:flutter_test/flutter_test.dart';
import 'package:neuralmedicsmobileapp/core/database/prediction_database.dart';
import 'package:neuralmedicsmobileapp/core/models/prediction_record.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('insert and read prediction for user', () async {
    final db = PredictionDatabase.instance;
    await db.init();

    final record = PredictionRecord(
      userId: 'test-user',
      topClassId: 'glioma',
      topClassLabel: 'Glioma',
      confidence: 0.91,
      usedMock: true,
      inferenceMs: 120,
      createdAt: DateTime(2026, 1, 1),
      probabilitiesJson: '{"glioma":0.91}',
    );

    await db.insertPrediction(record);
    final list = await db.predictionsForUser('test-user');

    expect(list, isNotEmpty);
    expect(list.first.topClassId, 'glioma');
    expect(list.first.confidence, closeTo(0.91, 0.001));
  });
}
