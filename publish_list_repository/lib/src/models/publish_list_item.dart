import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class PublishListItem {
  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the item
  final String name;

  final String description;

  final String id;

  final String descriptor;

  final int quantity;

  PublishListItem(
    this.name, {
    String id,
    String description,
    String descriptor,
    int quantity,
    DocumentReference docRef,
  })  : this.quantity = quantity ?? 0,
        this.id = id ?? '',
        this.descriptor = descriptor ?? '',
        this.description = description ?? '',
        this.docRef = docRef ?? null;

  PublishListItem copyWith({
    String name,
    String id,
    String description,
    String descriptor,
    int quantity,
    DocumentReference docRef,
  }) {
    return PublishListItem(
      name ?? this.name,
      descriptor: descriptor ?? this.descriptor,
      docRef: docRef ?? this.docRef,
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      quantity.hashCode ^
      descriptor.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublishListItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          id == other.id &&
          descriptor == other.descriptor &&
          description == other.description &&
          quantity == other.quantity;

  @override
  String toString() {
    return 'PublishListItem | name: $name, id: $id, description: $description, addedAt: ${quantity.toString()}, descriptor:$descriptor,';
  }

  PublishListItemEntity toEntity() {
    return PublishListItemEntity(
      descriptor: descriptor,
      docRef: docRef,
      id: id,
      name: name,
      description: description,
      quantity: quantity,
    );
  }

  static PublishListItem fromEntity(PublishListItemEntity entity) {
    return PublishListItem(
      entity.name,
      quantity: entity.quantity,
      docRef: entity.docRef,
      id: entity.id,
      descriptor: entity.descriptor,
      description: entity.description,
    );
  }
}
