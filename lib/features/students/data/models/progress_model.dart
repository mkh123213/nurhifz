import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressModel {
  final String id;
  final String studentId;
  final int juzCompleted;
  final int pagesCompleted;
  final int targetJuz;
  final String? lastSessionDate;

  const ProgressModel({
    required this.id,
    required this.studentId,
    this.juzCompleted = 0,
    this.pagesCompleted = 0,
    this.targetJuz = 30,
    this.lastSessionDate,
  });

  factory ProgressModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return ProgressModel(
      id: doc.id,
      studentId: d['student_id'] as String? ?? '',
      juzCompleted: (d['juz_completed'] as num?)?.toInt() ?? 0,
      pagesCompleted: (d['pages_completed'] as num?)?.toInt() ?? 0,
      targetJuz: (d['target_juz'] as num?)?.toInt() ?? 30,
      lastSessionDate: d['last_session_date'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'student_id': studentId,
        'juz_completed': juzCompleted,
        'pages_completed': pagesCompleted,
        'target_juz': targetJuz,
        if (lastSessionDate != null) 'last_session_date': lastSessionDate,
      };
}
