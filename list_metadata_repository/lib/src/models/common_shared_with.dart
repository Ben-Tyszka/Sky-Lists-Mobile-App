import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class CommonSharedWith {
  /// The unique user id of the owner
  final String id;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp lastShared;

  final int count;

  CommonSharedWith({
    String id,
    DocumentReference docRef,
    Timestamp lastShared,
    int count,
  })  : this.id = id ?? '',
        this.docRef = docRef ?? '',
        this.lastShared = lastShared ?? null,
        this.count = count ?? 0;

  CommonSharedWith copyWith({
    String id,
    DocumentReference docRef,
    Timestamp lastShared,
    int count,
  }) {
    return CommonSharedWith(
      lastShared: lastShared ?? this.lastShared,
      id: id ?? this.id,
      docRef: docRef ?? this.docRef,
      count: count ?? this.count,
    );
  }

  @override
  int get hashCode =>
      lastShared.hashCode ^ id.hashCode ^ docRef.hashCode ^ count.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonSharedWith &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          docRef == other.docRef &&
          lastShared == other.lastShared &&
          count == other.count;

  @override
  String toString() {
    return 'CommonSharedWith | id: $id, listId: $count, lastShared: ${lastShared.toDate().toString()}';
  }

  CommonSharedWithEntity toEntity() {
    return CommonSharedWithEntity(
      lastShared: lastShared,
      docRef: docRef,
      id: id,
      count: count,
    );
  }

  static CommonSharedWith fromEntity(CommonSharedWithEntity entity) {
    return CommonSharedWith(
      lastShared: entity.lastShared,
      id: entity.id,
      docRef: entity.docRef,
      count: entity.count,
    );
  }
}
