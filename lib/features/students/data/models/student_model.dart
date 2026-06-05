import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String name;
  final String? teacherId;
  final String level;
  final String? phone;
  final int? age;
  final String? avatarUrl;
  final String? notes;
  final bool isActive;

  const StudentModel({
    required this.id,
    required this.name,
    this.teacherId,
    this.level = 'beginner',
    this.phone,
    this.age,
    this.avatarUrl,
    this.notes,
    this.isActive = true,
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return StudentModel(
      id: doc.id,
      name: d['name'] as String? ?? '',
      teacherId: d['teacher_id'] as String?,
      level: d['level'] as String? ?? 'beginner',
      phone: d['phone'] as String?,
      age: (d['age'] as num?)?.toInt(),
      avatarUrl: d['avatar_url'] as String?,
      notes: d['notes'] as String?,
      isActive: d['is_active'] as bool? ?? true,
    );
  }

  StudentModel copyWith({
    String? id,
    String? name,
    String? teacherId,
    String? level,
    String? phone,
    int? age,
    String? avatarUrl,
    String? notes,
    bool? isActive,
  }) =>
      StudentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        teacherId: teacherId ?? this.teacherId,
        level: level ?? this.level,
        phone: phone ?? this.phone,
        age: age ?? this.age,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        notes: notes ?? this.notes,
        isActive: isActive ?? this.isActive,
      );

  Map<String, dynamic> toFirestore() => {
        'name': name,
        if (teacherId != null) 'teacher_id': teacherId,
        'level': level,
        if (phone != null) 'phone': phone,
        if (age != null) 'age': age,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (notes != null) 'notes': notes,
        'is_active': isActive,
        'created_at': FieldValue.serverTimestamp(),
      };
}
