import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListItemEntity extends Equatable {
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

  ListItemEntity({
    this.id,
    this.name,
    this.docRef,
    this.hidden,
    this.checked,
    this.addedAt,
    this.descriptor,
    this.quantity,
  });

  @override
  List<Object> get props => [
        name,
        id,
        addedAt,
        docRef,
        checked,
        hidden,
        quantity,
        descriptor,
      ];

  @override
  String toString() {
    return 'ListMetadataEntity | name: $name, id: $id, checked: $checked, added at: ${addedAt.toString()}, hidden: $hidden, quantity: $quantity, descriptor: $descriptor';
  }

  static ListItemEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ListItemEntity(
      id: snapshot.documentID,
      docRef: snapshot.reference,
      name: snapshot['name'] ?? '',
      addedAt: snapshot['addedAt'] ?? FieldValue.serverTimestamp(),
      hidden: snapshot['hidden'] ?? false,
      checked: snapshot['checked'] ?? false,
      descriptor: snapshot['descriptor'] ?? '',
      quantity: snapshot['quantity'] ?? 0,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'checked': checked,
      'addedAt': addedAt,
      'hidden': hidden,
      'descriptor': descriptor,
      'quantity': quantity,
    };
  }
}
