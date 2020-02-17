import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/src/scheduling.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class ScheduleList {
  /// Unqiue identifier for this list
  final String id;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  final Schedule schedule;

  final String scheduleTime;

  final Map<DayOfWeek, bool> daysOfWeek;

  ScheduleList({
    String id,
    DocumentReference docRef,
    Schedule schedule,
    String scheduleTime,
    Map<DayOfWeek, bool> daysOfWeek,
  })  : this.id = id ?? '',
        this.docRef = docRef ?? null,
        this.schedule = schedule ?? null,
        this.scheduleTime = scheduleTime ?? null,
        this.daysOfWeek = daysOfWeek ??
            {
              DayOfWeek.SUN: false,
              DayOfWeek.MON: false,
              DayOfWeek.TUE: false,
              DayOfWeek.WED: false,
              DayOfWeek.TH: false,
              DayOfWeek.FRI: false,
              DayOfWeek.SAT: false,
            };

  ScheduleList copyWith({
    String id,
    DocumentReference docRef,
    Schedule schedule,
    String scheduleTime,
    Map<DayOfWeek, bool> daysOfWeek,
  }) {
    return ScheduleList(
      docRef: docRef ?? this.docRef,
      id: id ?? this.id,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      schedule: schedule ?? this.schedule,
      scheduleTime: scheduleTime ?? this.scheduleTime,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      docRef.hashCode ^
      schedule.hashCode ^
      scheduleTime.hashCode ^
      daysOfWeek.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleList &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef &&
          id == other.id &&
          daysOfWeek == other.daysOfWeek &&
          schedule == other.schedule &&
          scheduleTime == other.scheduleTime;

  @override
  String toString() {
    return 'ScheduleList | id: $id, schedule: $schedule, scheduleTime: $scheduleTime, dayOfWeek:$daysOfWeek';
  }

  ScheduleListEntity toEntity() {
    return ScheduleListEntity(
      docRef: docRef,
      id: id,
      daysOfWeek: daysOfWeek,
      schedule: schedule,
      scheduleTime: scheduleTime,
    );
  }

  static ScheduleList fromEntity(ScheduleListEntity entity) {
    return ScheduleList(
      docRef: entity.docRef,
      id: entity.id,
      daysOfWeek: entity.daysOfWeek,
      schedule: entity.schedule,
      scheduleTime: entity.scheduleTime,
    );
  }
}
