import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListSharedMeta {
  final String listId;
  final DocumentReference docRef;
  final String owner;
  final Timestamp sharedAt;

  SkyListSharedMeta({
    this.listId,
    this.docRef,
    this.owner,
    this.sharedAt,
  });

  factory SkyListSharedMeta.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListSharedMeta(
      listId: doc.documentID,
      docRef: doc.reference,
      owner: data['owner'] ?? '',
      sharedAt: data['sharedAt'] ?? Timestamp.now(),
    );
  }
}
