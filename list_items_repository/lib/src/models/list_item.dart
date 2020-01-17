import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class ListItem {
  /// The unique id for the item
  final String id;

  /// The reference to the document in firestore that class represents
  final DocumentReference docRef;

  /// The actual name the user assigns to this item
  final String name;

  /// The hidden state of the item, not currently used
  final bool hidden;

  /// The checked state of the item
  final bool checked;

  /// When the item was added at, used for ordering
  final dynamic addedAt;

  /// How much of the item there is
  final int quantity;

  /// Container descriptor (cup, bag, etc.)
  final String descriptor;

  ListItem(
    this.name, {
    bool checked,
    bool hidden,
    String id,
    dynamic addedAt,
    DocumentReference docRef,
    int quantity,
    String descriptor,
  })  : this.checked = checked ?? false,
        this.hidden = hidden ?? false,
        this.addedAt = addedAt ?? FieldValue.serverTimestamp(),
        this.id = id ?? '',
        this.docRef = docRef ?? null,
        this.quantity = quantity ?? 0,
        this.descriptor = descriptor ?? '';

  ListItem copyWith({
    String name,
    bool checked,
    bool hidden,
    String id,
    dynamic addedAt,
    DocumentReference docRef,
    int quantity,
    String descriptor,
  }) {
    return ListItem(
      name ?? this.name,
      checked: checked ?? this.checked,
      docRef: docRef ?? this.docRef,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      addedAt: addedAt ?? this.addedAt,
      descriptor: descriptor ?? this.descriptor,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      checked.hashCode ^
      hidden.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      addedAt.hashCode ^
      descriptor.hashCode ^
      quantity.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          hidden == other.hidden &&
          id == other.id &&
          checked == other.checked &&
          addedAt == other.addedAt &&
          descriptor == other.descriptor &&
          quantity == other.quantity;

  @override
  String toString() {
    return 'ListItem | name: $name, id: $id, checked: $checked, addedAt: ${addedAt.toString()}, hidden: $hidden, descriptor: $descriptor, quantity: $quantity';
  }

  ListItemEntity toEntity() {
    return ListItemEntity(
      checked: checked,
      docRef: docRef,
      hidden: hidden,
      id: id,
      addedAt: addedAt,
      name: name,
      descriptor: descriptor,
      quantity: quantity,
    );
  }

  static ListItem fromEntity(ListItemEntity entity) {
    return ListItem(
      entity.name,
      checked: entity.checked,
      docRef: entity.docRef,
      hidden: entity.hidden,
      id: entity.id,
      addedAt: entity.addedAt,
      descriptor: entity.descriptor,
      quantity: entity.quantity,
    );
  }
}
