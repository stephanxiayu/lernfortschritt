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
    await _dbHelper.checkAndMigrateFromSharedPreferences();
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

  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayStr = _formatDate(today);

    // 1. Alle Tageswerte aufbauen (Dubletten aufsummieren)
    final Map<String, int> dailyMap = {};
    for (var e in entries) {
      final key = _formatDate(e.date);
      dailyMap[key] = (dailyMap[key] ?? 0) + e.minutes;
    }

    // 2. Heute erfasst
    final int todayMins = dailyMap[todayStr] ?? 0;

    // 3. Gesamte Zeit aller Zeiten
    int grandTotal = 0;
    dailyMap.forEach((_, mins) => grandTotal += mins);

    // 4. Reguläre Kalenderwoche: Montag bis Sonntag
    // DateTime.weekday: Mo = 1, Di = 2, Mi = 3, Do = 4, Fr = 5, Sa = 6, So = 7
    // Tage seit Montag dieser Woche:
    final daysSinceMonday = today.weekday - DateTime.monday; // Mo=0, Di=1, ..., So=6
    final startOfWeek = today.subtract(Duration(days: daysSinceMonday));

    // Wir summieren exakt von Montag bis einschließlich heute
    int weeklyTotal = 0;
    for (int i = 0; i <= daysSinceMonday; i++) {
      final d = startOfWeek.add(Duration(days: i));
      final k = _formatDate(d);
      weeklyTotal += dailyMap[k] ?? 0;
    }

    // 5. Historie der vergangenen Wochen (jeweils 7 Tage von Montag bis Sonntag)
    List<Map<String, dynamic>> pastWeeks = [];
    DateTime? earliestDate = entries.isNotEmpty ? entries.last.date : null;
    int maxWeeksBack = 11;

    if (earliestDate != null && earliestDate.isBefore(startOfWeek)) {
      final diffDays = startOfWeek.difference(earliestDate).inDays;
      maxWeeksBack = max(11, (diffDays / 7).ceil());
    }

    for (int w = 1; w <= maxWeeksBack; w++) {
      final pastWeekStart = startOfWeek.subtract(Duration(days: 7 * w));
      int pastTotal = 0;
      for (int d = 0; d < 7; d++) {
        final day = pastWeekStart.add(Duration(days: d));
        final k = _formatDate(day);
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayStr = _formatDate(today);
    
    final entries = await _dbHelper.getEntriesForGoalAndTrack(goal.id!, track);

    // Bisherige Minuten für den heutigen Tag ermitteln
    int currentMins = 0;
    for (var e in entries) {
      if (_formatDate(e.date) == todayStr) {
        currentMins += e.minutes;
      }
    }

    await _dbHelper.setDayMinutes(goal.id!, track, today, currentMins + minutesToAdd);
    notifyListeners();
  }

  Future<void> setTodayMinutes(String track, int exactMinutes) async {
    final goal = currentGoal;
    if (goal == null || goal.id == null) return;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    await _dbHelper.setDayMinutes(goal.id!, track, today, exactMinutes);
    notifyListeners();
  }
}