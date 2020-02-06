import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:list_metadata_repository/src/scheduling.dart';

class ListMetadataEntity extends Equatable {
  /// Unqiue identifier for this list
  final String id;

  /// List archive state
  final bool archived;

  /// List hidden state
  final bool hidden;

  /// List last modified time, used for ordering
  final dynamic lastModified;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  final bool othersCanShareList;

  final bool othersCanDeleteItems;

  final Schedule schedule;

  final String scheduleTime;

  final Map<DayOfWeek, bool> daysOfWeek;

  ListMetadataEntity({
    this.id,
    this.name,
    this.docRef,
    this.hidden,
    this.archived,
    this.lastModified,
    this.othersCanDeleteItems,
    this.othersCanShareList,
    this.schedule,
    this.scheduleTime,
    this.daysOfWeek,
  });

  @override
  List<Object> get props => [
        name,
        id,
        archived,
        docRef,
        lastModified,
        hidden,
        othersCanDeleteItems,
        othersCanShareList,
        daysOfWeek,
        schedule,
        scheduleTime,
      ];

  @override
  String toString() {
    return 'ListMetadataEntity | name: $name, id: $id, archived: $archived, modified: ${lastModified.toString()}, hidden: $hidden, othersCanShareList: $othersCanShareList, othersCanDeleteItems: $othersCanDeleteItems, schedule: $schedule, scheduleTime: $scheduleTime, dayOfWeek:$daysOfWeek';
  }

  static ListMetadataEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ListMetadataEntity(
      id: snapshot.documentID,
      docRef: snapshot.reference,
      name: snapshot['name'] ?? 'List',
      archived: snapshot['archived'] ?? false,
      lastModified: snapshot['lastModified'] ?? FieldValue.serverTimestamp(),
      hidden: snapshot['hidden'] ?? false,
      othersCanDeleteItems: snapshot['othersCanDeleteItems'] ?? true,
      othersCanShareList: snapshot['othersCanShareList'] ?? true,
      daysOfWeek:
          (snapshot['dayOfWeek'] as Map<int, bool>).map<DayOfWeek, bool>(
                (dayIndex, flag) => MapEntry(
                  DayOfWeek.values[dayIndex],
                  flag,
                ),
              ) ??
              null,
      schedule: Schedule.values[snapshot['schedule'] ?? 0],
      scheduleTime: snapshot['scheduleTime'] ?? '',
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'archived': archived,
      'lastModified': FieldValue.serverTimestamp(),
      'hidden': hidden,
      'othersCanShareList': othersCanShareList,
      'othersCanDeleteItems': othersCanDeleteItems,
      'daysOfWeek': daysOfWeek.map<int, bool>(
        (day, flag) => MapEntry(
          day.index,
          flag,
        ),
      ),
      'schedule': schedule.index,
      'scheduleTime': scheduleTime,
    };
  }
}
