import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String studentId;
  final String? teacherId;
  final String date;
  final String type;
  final String surahName;
  final int ayahStart;
  final int ayahEnd;
  final int score;
  final List<String> mistakes;
  final String? notes;

  const SessionModel({
    required this.id,
    required this.studentId,
    this.teacherId,
    required this.date,
    this.type = 'hifz',
    required this.surahName,
    this.ayahStart = 1,
    this.ayahEnd = 1,
    required this.score,
    this.mistakes = const [],
    this.notes,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return SessionModel(
      id: doc.id,
      studentId: d['student_id'] as String? ?? '',
      teacherId: d['teacher_id'] as String?,
      date: d['date'] as String? ?? '',
      type: d['type'] as String? ?? 'hifz',
      surahName: d['surah_name'] as String? ?? '',
      ayahStart: (d['ayah_start'] as num?)?.toInt() ?? 1,
      ayahEnd: (d['ayah_end'] as num?)?.toInt() ?? 1,
      score: (d['score'] as num?)?.toInt() ?? 0,
      mistakes: (d['mistakes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: d['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'student_id': studentId,
        if (teacherId != null) 'teacher_id': teacherId,
        'date': date,
        'type': type,
        'surah_name': surahName,
        'ayah_start': ayahStart,
        'ayah_end': ayahEnd,
        'score': score,
        'mistakes': mistakes,
        if (notes != null) 'notes': notes,
        'created_at': FieldValue.serverTimestamp(),
      };
}
