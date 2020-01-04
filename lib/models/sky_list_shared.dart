import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListShared {
  final String sharedWithId;
  final DocumentReference docRef;
  final Timestamp sharedAt;

  SkyListShared({
    this.sharedWithId,
    this.docRef,
    this.sharedAt,
  });

  factory SkyListShared.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListShared(
      sharedWithId: doc.documentID,
      docRef: doc.reference,
      sharedAt: data['sharedAt'] ?? Timestamp.now(),
    );
  }
}
