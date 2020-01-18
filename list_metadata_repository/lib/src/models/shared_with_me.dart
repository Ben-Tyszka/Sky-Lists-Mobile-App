import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class SharedWithMe {
  /// The unique user id of the owner
  final String owner;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp sharedAt;

  final String listId;

  SharedWithMe({
    String owner,
    DocumentReference docRef,
    Timestamp sharedAt,
    String listId,
  })  : this.owner = owner ?? '',
        this.docRef = docRef ?? '',
        this.sharedAt = sharedAt ?? null,
        this.listId = listId ?? '';

  SharedWithMe copyWith({
    String owner,
    DocumentReference docRef,
    Timestamp sharedAt,
    String listId,
  }) {
    return SharedWithMe(
      sharedAt: sharedAt ?? this.sharedAt,
      owner: owner ?? this.owner,
      docRef: docRef ?? this.docRef,
      listId: listId ?? this.listId,
    );
  }

  @override
  int get hashCode =>
      sharedAt.hashCode ^ owner.hashCode ^ docRef.hashCode ^ listId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedWithMe &&
          runtimeType == other.runtimeType &&
          owner == other.owner &&
          docRef == other.docRef &&
          sharedAt == other.sharedAt &&
          listId == other.listId;

  @override
  String toString() {
    return 'SharedWithMe | owner: $owner, listId: $listId, sharedAt: ${sharedAt.toDate().toString()}';
  }

  SharedWithMeEntity toEntity() {
    return SharedWithMeEntity(
      sharedAt: sharedAt,
      docRef: docRef,
      owner: owner,
      listId: listId,
    );
  }

  static SharedWithMe fromEntity(SharedWithMeEntity entity) {
    return SharedWithMe(
      sharedAt: entity.sharedAt,
      owner: entity.owner,
      docRef: entity.docRef,
      listId: entity.listId,
    );
  }
}
