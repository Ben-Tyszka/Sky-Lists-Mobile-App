import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListItem {
  final String id;
  final DocumentReference docRef;
  final String name;
  final bool hidden;
  final bool checked;
  final Timestamp addedAt;
  final int quantity;
  final String descriptor;

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
