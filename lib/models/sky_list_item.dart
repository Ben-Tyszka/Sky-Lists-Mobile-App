import 'package:cloud_firestore/cloud_firestore.dart';

/// The data for an item inside a sky list
class SkyListItem {
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
  final Timestamp addedAt;

  /// How much of the item there is
  final int quantity;

  /// Container descriptor (cup, bag, etc.)
  final String descriptor;

  /// Constructor to be used by factory
  SkyListItem({
    this.id,
    this.docRef,
    this.name,
    this.addedAt,
    this.hidden,
    this.checked,
    this.quantity,
    this.descriptor,
  });

  /// Converts [doc] to SkyListItem
  factory SkyListItem.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListItem(
      id: doc.documentID,
      docRef: doc.reference,
      name: data['name'] ?? '',
      addedAt: data['addedAt'] ?? Timestamp.now(),
      hidden: data['hidden'] ?? false,
      checked: data['checked'] ?? false,
      descriptor: data['descriptor'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}
