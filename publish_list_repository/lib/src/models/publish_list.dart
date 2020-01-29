import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class PublishList {
  /// List last modified time, used for ordering
  final dynamic addedAt;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  final String description;

  final String id;

  final String ownerId;

  PublishList(
    this.name,
    this.ownerId, {
    String id,
    String description,
    dynamic addedAt,
    DocumentReference docRef,
  })  : this.addedAt = addedAt ?? FieldValue.serverTimestamp(),
        this.id = id ?? '',
        this.docRef = docRef ?? null,
        this.description = description;

  PublishList copyWith({
    String name,
    String id,
    String description,
    dynamic addedAt,
    DocumentReference docRef,
    String ownerId,
  }) {
    return PublishList(
      name ?? this.name,
      ownerId ?? this.ownerId,
      docRef: docRef ?? this.docRef,
      id: id ?? this.id,
      addedAt: addedAt ?? this.addedAt,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      addedAt.hashCode ^
      ownerId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublishList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          id == other.id &&
          addedAt == other.addedAt &&
          description == other.description &&
          ownerId == other.ownerId;

  @override
  String toString() {
    return 'PublishList | name: $name, id: $id, description: $description, addedAt: ${addedAt.toString()}, owner:$ownerId,';
  }

  PublishListEntity toEntity() {
    return PublishListEntity(
      addedAt: addedAt,
      docRef: docRef,
      id: id,
      name: name,
      description: description,
      ownerId: ownerId,
    );
  }

  static PublishList fromEntity(PublishListEntity entity) {
    return PublishList(
      entity.name,
      entity.ownerId,
      docRef: entity.docRef,
      id: entity.id,
      addedAt: entity.addedAt,
      description: entity.description,
    );
  }
}
