import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListItem {
  final String id;
  final DocumentReference docRef;
  final String name;
  final bool hidden;
  final bool checked;
  final Timestamp addedAt;

  SkyListItem({
    this.id,
    this.docRef,
    this.name,
    this.addedAt,
    this.hidden,
    this.checked,
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
    );
  }
}
