import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class ListSharedWith {
  /// The unique user id that this list is shared with
  final String sharedWithId;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp sharedAt;

  ListSharedWith({
    String sharedWithId,
    DocumentReference docRef,
    Timestamp sharedAt,
  })  : this.sharedWithId = sharedWithId ?? '',
        this.docRef = docRef ?? '',
        this.sharedAt = sharedAt ?? null;

  ListSharedWith copyWith({
    String sharedWithId,
    DocumentReference docRef,
    Timestamp sharedAt,
  }) {
    return ListSharedWith(
      sharedAt: sharedAt ?? this.sharedAt,
      sharedWithId: sharedWithId ?? this.sharedWithId,
      docRef: docRef ?? this.docRef,
    );
  }

  @override
  int get hashCode =>
      sharedAt.hashCode ^ sharedWithId.hashCode ^ docRef.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListSharedWith &&
          runtimeType == other.runtimeType &&
          sharedWithId == other.sharedWithId &&
          docRef == other.docRef &&
          sharedAt == other.sharedAt;

  @override
  String toString() {
    return 'ListSharedWith | sharedWithId: $sharedWithId, sharedAt: ${sharedAt.toDate().toString()}';
  }

  ListSharedWithEntity toEntity() {
    return ListSharedWithEntity(
      sharedAt: sharedAt,
      docRef: docRef,
      sharedWithId: sharedWithId,
    );
  }

  static ListSharedWith fromEntity(ListSharedWithEntity entity) {
    return ListSharedWith(
      sharedAt: entity.sharedAt,
      sharedWithId: entity.sharedWithId,
      docRef: entity.docRef,
    );
  }
}
