import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents data for the person with whom a list is shared
///
/// This is a bit complicated, this is used when the share page of a list is opened.
/// It is used to get a stream of all the user id's that this list is shared with
class SkyListSharePageMeta {
  /// The unique user id that this list is shared with
  final String sharedWithId;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp sharedAt;

  /// Constructor to be used by factory
  SkyListSharePageMeta({
    this.sharedWithId,
    this.docRef,
    this.sharedAt,
  });

  /// Converts [doc] to SkyListSharePageMeta
  factory SkyListSharePageMeta.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListSharePageMeta(
      sharedWithId: doc.documentID,
      docRef: doc.reference,
      sharedAt: data['sharedAt'] ?? Timestamp.now(),
    );
  }
}
