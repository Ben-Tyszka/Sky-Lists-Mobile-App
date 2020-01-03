import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListMeta {
  final String id;
  final DocumentReference docRef;
  final String name;
  final bool archived;
  final bool hidden;
  final Timestamp lastModified;

  SkyListMeta({
    this.id,
    this.docRef,
    this.name,
    this.archived,
    this.lastModified,
    this.hidden,
  });

  factory SkyListMeta.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListMeta(
      id: doc.documentID,
      docRef: doc.reference,
      name: data['name'] ?? '',
      archived: data['archived'] ?? true,
      lastModified: data['lastModified'] ?? Timestamp.now(),
      hidden: data['hidden'] ?? false,
    );
  }
}
