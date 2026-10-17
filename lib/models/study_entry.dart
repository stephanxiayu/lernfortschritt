class StudyEntry {
  final int? id;
  final int goalId;
  final String track; // 'study' oder 'homework'
  final DateTime date;
  final int minutes;

  StudyEntry({
    this.id,
    required this.goalId,
    required this.track,
    required this.date,
    required this.minutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goal_id': goalId,
      'track': track,
      'date': "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      'minutes': minutes,
    };
  }

  factory StudyEntry.fromMap(Map<String, dynamic> map) {
    return StudyEntry(
      id: map['id'] as int?,
      goalId: map['goal_id'] as int,
      track: map['track'] as String,
      date: DateTime.parse(map['date'] as String),
      minutes: map['minutes'] as int,
    );
  }
}