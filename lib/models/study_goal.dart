class StudyGoal {
  final int? id;
  final String title;
  final DateTime finalExamDate;
  final DateTime? intermediateExamDate;
  final DateTime createdAt;

  StudyGoal({
    this.id,
    required this.title,
    required this.finalExamDate,
    this.intermediateExamDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'final_exam_date': finalExamDate.toIso8601String(),
      'intermediate_exam_date': intermediateExamDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory StudyGoal.fromMap(Map<String, dynamic> map) {
    return StudyGoal(
      id: map['id'] as int?,
      title: map['title'] as String,
      finalExamDate: DateTime.parse(map['final_exam_date'] as String),
      intermediateExamDate: map['intermediate_exam_date'] != null
          ? DateTime.parse(map['intermediate_exam_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}