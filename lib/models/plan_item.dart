import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum PlanType { lesson, task, event, note }

class PlanItem {
  final String id;
  String title;
  String? subtitle;
  String? location;
  DateTime startTime;
  DateTime endTime;
  PlanType type;
  String category;
  Color color;
  bool isCompleted;
  String? note;
  /// Minutes before start. null = no reminder. 0 = at start.
  int? reminderOffsetMin;

  PlanItem({
    String? id,
    required this.title,
    this.subtitle,
    this.location,
    required this.startTime,
    required this.endTime,
    this.type = PlanType.lesson,
    this.category = 'Dərs',
    this.color = const Color(0xFF6C5CE7),
    this.isCompleted = false,
    this.note,
    this.reminderOffsetMin = 10,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'location': location,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'type': type.index,
        'category': category,
        'color': color.value, // ignore: deprecated_member_use
        'isCompleted': isCompleted,
        'note': note,
        'reminderOffsetMin': reminderOffsetMin,
      };

  factory PlanItem.fromJson(Map<String, dynamic> json) => PlanItem(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        location: json['location'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        type: PlanType.values[json['type'] ?? 0],
        category: json['category'] ?? 'Dərs',
        color: Color(json['color'] ?? 0xFF6C5CE7),
        isCompleted: json['isCompleted'] ?? false,
        note: json['note'],
        reminderOffsetMin: json['reminderOffsetMin'],
      );

  PlanItem copyWith({
    String? title,
    String? subtitle,
    String? location,
    DateTime? startTime,
    DateTime? endTime,
    PlanType? type,
    String? category,
    Color? color,
    bool? isCompleted,
    String? note,
    int? reminderOffsetMin,
    bool clearReminder = false,
  }) {
    return PlanItem(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      category: category ?? this.category,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      note: note ?? this.note,
      reminderOffsetMin:
          clearReminder ? null : (reminderOffsetMin ?? this.reminderOffsetMin),
    );
  }
}

const reminderOffsets = <int, String>{
  -1: 'Xəbərdarlıq yoxdur',
  0: 'Dərs başlayanda',
  5: '5 dəqiqə əvvəl',
  10: '10 dəqiqə əvvəl',
  15: '15 dəqiqə əvvəl',
  30: '30 dəqiqə əvvəl',
  60: '1 saat əvvəl',
};

String reminderLabel(int? minutes) {
  if (minutes == null) return reminderOffsets[-1]!;
  return reminderOffsets[minutes] ?? 'Xəbərdarlıq yoxdur';
}

String weekdayShort(DateTime day) {
  const labels = {
    1: 'B.e',
    2: 'Ç.a',
    3: 'Çər',
    4: 'C.a',
    5: 'Cüm',
    6: 'Şən',
    7: 'Baz',
  };
  return labels[day.weekday] ?? '';
}
