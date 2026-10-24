import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/study_entry.dart';
import '../models/study_goal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static sql.Database? _database;

  DatabaseHelper._init();

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('study_tracker.db');
    return _database!;
  }

  Future<sql.Database> _initDB(String filePath) async {
    final dbPath = await sql.getDatabasesPath();
    final fullPath = path.join(dbPath, filePath);

    return await sql.openDatabase(
      fullPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(sql.Database db, int version) async {
    await db.execute('''
      CREATE TABLE goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        final_exam_date TEXT NOT NULL,
        intermediate_exam_date TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE study_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal_id INTEGER NOT NULL,
        track TEXT NOT NULL,
        date TEXT NOT NULL,
        minutes INTEGER NOT NULL,
        FOREIGN KEY (goal_id) REFERENCES goals (id) ON DELETE CASCADE
      )
    ''');
  }

  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  /// Migriert bestehende Daten aus SharedPreferences nur dann, wenn wirklich alte Daten vorhanden sind.
  /// Bei einer komplett frischen Neuinstallation wird KEIN Default-Ziel angelegt.
  Future<void> checkAndMigrateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isMigrated = prefs.getBool('migrated_to_sqlite') ?? false;

    if (isMigrated) {
      return;
    }

    final db = await database;
    final allKeys = prefs.getKeys().toList();

    // Prüfen, ob überhaupt alte Lernzeit-Keys in SharedPreferences liegen
    final hasOldData = allKeys.any((k) =>
        k.startsWith('study_') ||
        k.startsWith('homework_') ||
        (k.split('-').length == 3 && int.tryParse(k.split('-')[0]) != null));

    if (!hasOldData) {
      // Frische Installation -> keine Dummy-Ziele erzeugen, direkt als erledigt markieren
      await prefs.setBool('migrated_to_sqlite', true);
      return;
    }

    // Wenn echte Altdaten existieren: Initiales Ziel für die Migration anlegen
    final existingGoals = await db.query('goals');
    int goalId = 1;

    if (existingGoals.isEmpty) {
      goalId = await db.insert('goals', {
        'title': 'IHK - Wirtschaftsfachwirt',
        'final_exam_date': DateTime(2027, 4, 10).toIso8601String(),
        'intermediate_exam_date': DateTime(2026, 10, 20).toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } else {
      goalId = existingGoals.first['id'] as int;
    }

    final batch = db.batch();

    for (final key in allKeys) {
      if (key == 'migrated_to_sqlite') continue;

      String track = 'study';
      String datePart = key;

      if (key.startsWith('study_')) {
        track = 'study';
        datePart = key.replaceFirst('study_', '');
      } else if (key.startsWith('homework_')) {
        track = 'homework';
        datePart = key.replaceFirst('homework_', '');
      } else {
        // Altes Format vor Prefix-Trennung (z. B. "2026-9-5")
        final rawParts = key.split('-');
        if (rawParts.length == 3 && int.tryParse(rawParts[0]) != null) {
          track = 'study';
          datePart = key;
        } else {
          continue;
        }
      }

      final parts = datePart.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year != null && month != null && day != null) {
          final minutes = prefs.getInt(key) ?? 0;
          if (minutes > 0) {
            final standardDate = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
            batch.insert('study_entries', {
              'goal_id': goalId,
              'track': track,
              'date': standardDate,
              'minutes': minutes,
            });
          }
        }
      }
    }

    await batch.commit(noResult: true);
    await prefs.setBool('migrated_to_sqlite', true);

    if (kDebugMode) {
      print("Erfolgreich von SharedPreferences in SQLite migriert!");
    }
  }

  // --- CRUD METHODEN ---

  Future<List<StudyGoal>> getAllGoals() async {
    final db = await database;
    final maps = await db.query('goals', orderBy: 'id ASC');
    return maps.map((m) => StudyGoal.fromMap(m)).toList();
  }

  Future<int> insertGoal(StudyGoal goal) async {
    final db = await database;
    return await db.insert('goals', goal.toMap());
  }

  Future<int> updateGoal(StudyGoal goal) async {
    final db = await database;
    return await db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<int> deleteGoal(int id) async {
    final db = await database;
    await db.delete('study_entries', where: 'goal_id = ?', whereArgs: [id]);
    return await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<StudyEntry>> getEntriesForGoalAndTrack(int goalId, String track) async {
    final db = await database;
    final maps = await db.query(
      'study_entries',
      where: 'goal_id = ? AND track = ?',
      whereArgs: [goalId, track],
      orderBy: 'date DESC',
    );
    return maps.map((m) => StudyEntry.fromMap(m)).toList();
  }

  Future<void> setDayMinutes(int goalId, String track, DateTime date, int totalMinutes) async {
    final db = await database;
    final dateStr = _formatDate(date);

    if (totalMinutes <= 0) {
      await db.delete(
        'study_entries',
        where: 'goal_id = ? AND track = ? AND date = ?',
        whereArgs: [goalId, track, dateStr],
      );
      return;
    }

    final existing = await db.query(
      'study_entries',
      where: 'goal_id = ? AND track = ? AND date = ?',
      whereArgs: [goalId, track, dateStr],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'study_entries',
        {'minutes': totalMinutes},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } else {
      await db.insert('study_entries', {
        'goal_id': goalId,
        'track': track,
        'date': dateStr,
        'minutes': totalMinutes,
      });
    }
  }
  
}