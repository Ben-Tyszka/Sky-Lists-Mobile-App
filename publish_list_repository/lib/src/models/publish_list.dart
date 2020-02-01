import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class PublishList {
  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  final String description;

  final String id;

  final String ownerId;

  final int likes;

  /// List last modified time, used for ordering
  final dynamic addedAt;

  PublishList(
    this.name,
    this.ownerId, {
    String id,
    String description,
    int likes,
    DocumentReference docRef,
    dynamic addedAt,
  })  : this.id = id ?? '',
        this.docRef = docRef ?? null,
        this.description = description ?? '',
        this.likes = likes ?? 0,
        this.addedAt = addedAt ?? FieldValue.serverTimestamp();

  PublishList copyWith({
    String name,
    String id,
    String description,
    dynamic addedAt,
    DocumentReference docRef,
    String ownerId,
    int likes,
  }) {
    return PublishList(
      name ?? this.name,
      ownerId ?? this.ownerId,
      docRef: docRef ?? this.docRef,
      id: id ?? this.id,
      likes: likes ?? this.likes,
      description: description ?? this.description,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      likes.hashCode ^
      ownerId.hashCode ^
      addedAt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublishList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          id == other.id &&
          description == other.description &&
          ownerId == other.ownerId &&
          likes == other.likes;

  @override
  String toString() {
    return 'PublishList | name: $name, id: $id, description: $description, owner:$ownerId, likes: $likes, addedAt:${addedAt.toString()}';
  }

  PublishListEntity toEntity() {
    return PublishListEntity(
      docRef: docRef,
      id: id,
      name: name,
      description: description,
      ownerId: ownerId,
      likes: likes,
      addedAt: addedAt,
    );
  }

  static PublishList fromEntity(PublishListEntity entity) {
    return PublishList(
      entity.name,
      entity.ownerId,
      docRef: entity.docRef,
      id: entity.id,
      likes: entity.likes,
      description: entity.description,
      addedAt: entity.addedAt,
    );
  }
}
