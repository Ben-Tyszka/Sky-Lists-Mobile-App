import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:list_metadata_repository/src/scheduling.dart';

class ScheduleListEntity extends Equatable {
  /// Unqiue identifier for this list
  final String id;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  final Schedule schedule;

  final String scheduleTime;

  final Map<DayOfWeek, bool> daysOfWeek;

  ScheduleListEntity({
    this.id,
    this.docRef,
    this.schedule,
    this.scheduleTime,
    this.daysOfWeek,
  });

  @override
  List<Object> get props => [
        id,
        docRef,
        daysOfWeek,
        schedule,
        scheduleTime,
      ];

  @override
  String toString() {
    return 'ScheduleListEntity | id: $id, schedule: $schedule, scheduleTime: $scheduleTime, dayOfWeek:$daysOfWeek';
  }

  static ScheduleListEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ScheduleListEntity(
      id: snapshot.documentID,
      docRef: snapshot.reference,
      daysOfWeek:
          Map<String, bool>.from(snapshot['daysOfWeek'])?.map<DayOfWeek, bool>(
                (dayIndex, flag) => MapEntry(
                  DayOfWeek.values[int.parse(dayIndex)],
                  flag,
                ),
              ) ??
              {
                DayOfWeek.SUN: false,
                DayOfWeek.MON: false,
                DayOfWeek.TUE: false,
                DayOfWeek.WED: false,
                DayOfWeek.TH: false,
                DayOfWeek.FRI: false,
                DayOfWeek.SAT: false,
              },
      schedule: Schedule.values[snapshot['schedule'] ?? 0],
      scheduleTime: snapshot['scheduleTime'] ?? '',
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'daysOfWeek': daysOfWeek.map<String, bool>(
        (day, flag) => MapEntry(
          day.index.toString(),
          flag,
        ),
      ),
      'schedule': schedule.index,
      'scheduleTime': scheduleTime,
    };
  }
}
