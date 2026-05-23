import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/prediction_record.dart';

class PredictionDatabase {
  PredictionDatabase._();
  static final PredictionDatabase instance = PredictionDatabase._();

  static const _dbName = 'neuralmedics_predictions.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<void> init() async {
    await database;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE predictions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            top_class_id TEXT NOT NULL,
            top_class_label TEXT NOT NULL,
            confidence REAL NOT NULL,
            used_mock INTEGER NOT NULL,
            inference_ms INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            image_path TEXT,
            probabilities_json TEXT
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_predictions_user ON predictions(user_id, created_at DESC)',
        );
      },
    );
  }

  Future<int> insertPrediction(PredictionRecord record) async {
    final db = await database;
    return db.insert('predictions', record.toMap()..remove('id'));
  }

  Future<List<PredictionRecord>> predictionsForUser(
    String userId, {
    int limit = 50,
  }) async {
    final db = await database;
    final rows = await db.query(
      'predictions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(PredictionRecord.fromMap).toList();
  }

  Future<void> deleteAllForUser(String userId) async {
    final db = await database;
    await db.delete('predictions', where: 'user_id = ?', whereArgs: [userId]);
  }
}
