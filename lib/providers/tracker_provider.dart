import 'dart:math';
import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';

import '../models/study_goal.dart';

class TrackerProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<StudyGoal> _goals = [];
  int _selectedGoalIndex = 0;

  List<StudyGoal> get goals => [..._goals];

  StudyGoal? get currentGoal {
    if (_goals.isEmpty) return null;
    if (_selectedGoalIndex >= _goals.length) _selectedGoalIndex = 0;
    return _goals[_selectedGoalIndex];
  }

  int get selectedGoalIndex => _selectedGoalIndex;

  void selectGoal(int index) {
    if (index >= 0 && index < _goals.length) {
      _selectedGoalIndex = index;
      notifyListeners();
    }
  }

  Future<void> init() async {
    // 1. Einmalige Übernahme aller Daten aus SharedPreferences in SQLite
    await _dbHelper.checkAndMigrateFromSharedPreferences();
    // 2. Abschlüsse aus SQLite laden
    await loadGoals();
  }

  Future<void> loadGoals() async {
    _goals = await _dbHelper.getAllGoals();
    notifyListeners();
  }

  Future<void> addGoal(String title, DateTime finalExamDate, DateTime? intermediateExamDate) async {
    final newGoal = StudyGoal(
      title: title,
      finalExamDate: finalExamDate,
      intermediateExamDate: intermediateExamDate,
    );
    await _dbHelper.insertGoal(newGoal);
    await loadGoals();
    _selectedGoalIndex = _goals.length - 1;
    notifyListeners();
  }

  Future<void> updateGoal(StudyGoal goal) async {
    await _dbHelper.updateGoal(goal);
    await loadGoals();
  }

  Future<void> deleteGoal(int id) async {
    await _dbHelper.deleteGoal(id);
    await loadGoals();
    if (_selectedGoalIndex >= _goals.length) {
      _selectedGoalIndex = max(0, _goals.length - 1);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> getTrackStats(String track) async {
    final goal = currentGoal;
    if (goal == null || goal.id == null) {
      return {
        'todayMinutes': 0,
        'weeklyMinutes': 0,
        'totalMinutes': 0,
        'pastWeeks': <Map<String, dynamic>>[],
        'dailyMap': <String, int>{},
      };
    }

    final entries = await _dbHelper.getEntriesForGoalAndTrack(goal.id!, track);
    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    int todayMins = 0;
    int grandTotal = 0;
    final Map<String, int> dailyMap = {};

    for (var e in entries) {
      final dateKey = "${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}";
      dailyMap[dateKey] = e.minutes;
      grandTotal += e.minutes;
      if (dateKey == todayStr) {
        todayMins = e.minutes;
      }
    }

    // Wochen-Minuten (Samstag als Start)
    final daysToSubtract = (today.weekday + 1) % 7;
    final startOfWeek = DateTime(today.year, today.month, today.day).subtract(Duration(days: daysToSubtract));

    int weeklyTotal = 0;
    for (int i = 0; i < 7; i++) {
      final d = startOfWeek.add(Duration(days: i));
      final k = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      weeklyTotal += dailyMap[k] ?? 0;
    }

    // Historie der vergangenen Wochen
    List<Map<String, dynamic>> pastWeeks = [];
    DateTime? earliestDate = entries.isNotEmpty ? entries.last.date : null;
    int maxWeeksBack = 4;

    if (earliestDate != null && earliestDate.isBefore(startOfWeek)) {
      final diffDays = startOfWeek.difference(earliestDate).inDays;
      maxWeeksBack = max(4, (diffDays / 7).ceil());
    }

    for (int w = 1; w <= maxWeeksBack; w++) {
      final pastWeekStart = startOfWeek.subtract(Duration(days: 7 * w));
      int pastTotal = 0;
      for (int d = 0; d < 7; d++) {
        final day = pastWeekStart.add(Duration(days: d));
        final k = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        pastTotal += dailyMap[k] ?? 0;
      }

      if (pastTotal > 0 || w <= 2) {
        pastWeeks.add({
          'label': w == 1 ? 'Letzte Woche' : 'Vor $w Wochen',
          'minutes': pastTotal,
        });
      }
    }

    return {
      'todayMinutes': todayMins,
      'weeklyMinutes': weeklyTotal,
      'totalMinutes': grandTotal,
      'pastWeeks': pastWeeks,
      'dailyMap': dailyMap,
    };
  }

  Future<void> addMinutes(String track, int minutesToAdd) async {
    final goal = currentGoal;
    if (goal == null || goal.id == null) return;

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final entries = await _dbHelper.getEntriesForGoalAndTrack(goal.id!, track);

    final currentEntry = entries.where((e) {
      final k = "${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}";
      return k == todayStr;
    }).toList();

    final currentMins = currentEntry.isNotEmpty ? currentEntry.first.minutes : 0;
    await _dbHelper.setDayMinutes(goal.id!, track, today, currentMins + minutesToAdd);
    notifyListeners();
  }

  Future<void> setTodayMinutes(String track, int exactMinutes) async {
    final goal = currentGoal;
    if (goal == null || goal.id == null) return;
    await _dbHelper.setDayMinutes(goal.id!, track, DateTime.now(), exactMinutes);
    notifyListeners();
  }
}