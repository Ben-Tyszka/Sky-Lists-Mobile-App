import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListSharePageMeta {
  final String sharedWithId;
  final DocumentReference docRef;
  final Timestamp sharedAt;

  SkyListSharePageMeta({
    this.sharedWithId,
    this.docRef,
    this.sharedAt,
  });

  factory SkyListSharePageMeta.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListSharePageMeta(
      sharedWithId: doc.documentID,
      docRef: doc.reference,
      sharedAt: data['sharedAt'] ?? Timestamp.now(),
    );
  }
}
