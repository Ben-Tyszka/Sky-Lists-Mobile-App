import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/src/scheduling.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class ListMetadata {
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

  final bool enableSchedule;

  ListMetadata(
    this.name, {
    bool archived,
    bool hidden,
    String id,
    dynamic lastModified,
    DocumentReference docRef,
    bool othersCanShareList,
    bool othersCanDeleteItems,
    Schedule schedule,
    String scheduleTime,
    Map<DayOfWeek, bool> daysOfWeek,
    bool enableSchedule,
  })  : this.archived = archived ?? false,
        this.hidden = hidden ?? false,
        this.lastModified = lastModified ?? FieldValue.serverTimestamp(),
        this.id = id ?? '',
        this.docRef = docRef ?? null,
        this.othersCanShareList = othersCanShareList ?? true,
        this.othersCanDeleteItems = othersCanDeleteItems ?? true,
        this.schedule = schedule ?? null,
        this.scheduleTime = scheduleTime ?? null,
        this.enableSchedule = enableSchedule ?? false,
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

  ListMetadata copyWith({
    String id,
    bool archived,
    bool hidden,
    dynamic lastModified,
    DocumentReference docRef,
    String name,
    bool othersCanShareList,
    bool othersCanDeleteItems,
    Schedule schedule,
    String scheduleTime,
    Map<DayOfWeek, bool> daysOfWeek,
    bool enableSchedule,
  }) {
    return ListMetadata(
      name ?? this.name,
      archived: archived ?? this.archived,
      docRef: docRef ?? this.docRef,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      lastModified: lastModified ?? this.lastModified,
      othersCanShareList: othersCanShareList ?? this.othersCanShareList,
      othersCanDeleteItems: othersCanDeleteItems ?? this.othersCanDeleteItems,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      schedule: schedule ?? this.schedule,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      enableSchedule: enableSchedule ?? this.enableSchedule,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      archived.hashCode ^
      hidden.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      lastModified.hashCode ^
      othersCanDeleteItems.hashCode ^
      othersCanShareList.hashCode ^
      schedule.hashCode ^
      scheduleTime.hashCode ^
      daysOfWeek.hashCode ^
      enableSchedule.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListMetadata &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          hidden == other.hidden &&
          id == other.id &&
          archived == other.archived &&
          lastModified == other.lastModified &&
          othersCanDeleteItems == other.othersCanDeleteItems &&
          othersCanShareList == other.othersCanShareList &&
          daysOfWeek == other.daysOfWeek &&
          schedule == other.schedule &&
          scheduleTime == other.scheduleTime &&
          enableSchedule == other.enableSchedule;

  @override
  String toString() {
    return 'ListMetadata | name: $name, id: $id, archived: $archived, modified: ${lastModified.toString()}, hidden: $hidden, othersCanShareList: $othersCanShareList, othersCanDeleteItems: $othersCanDeleteItems, schedule: $schedule, scheduleTime: $scheduleTime, dayOfWeek:$daysOfWeek, enableSchedule:$enableSchedule';
  }

  ListMetadataEntity toEntity() {
    return ListMetadataEntity(
      archived: archived,
      docRef: docRef,
      hidden: hidden,
      id: id,
      lastModified: lastModified,
      name: name,
      othersCanDeleteItems: othersCanDeleteItems,
      othersCanShareList: othersCanShareList,
      daysOfWeek: daysOfWeek,
      schedule: schedule,
      scheduleTime: scheduleTime,
      enableSchedule: enableSchedule,
    );
  }

  static ListMetadata fromEntity(ListMetadataEntity entity) {
    return ListMetadata(
      entity.name,
      archived: entity.archived,
      docRef: entity.docRef,
      hidden: entity.hidden,
      id: entity.id,
      lastModified: entity.lastModified,
      othersCanDeleteItems: entity.othersCanDeleteItems,
      othersCanShareList: entity.othersCanShareList,
      daysOfWeek: entity.daysOfWeek,
      schedule: entity.schedule,
      scheduleTime: entity.scheduleTime,
    );
  }
}
