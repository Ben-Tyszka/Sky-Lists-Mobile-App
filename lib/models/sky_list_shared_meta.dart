import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a list's metadata that is shared with you
///
/// Used on home screen to view all the lists that are shared with you
class SkyListSharedMeta {
  /// The unique of the list
  final String listId;

  /// The doc reference to the firestore doc that this list represents
  final DocumentReference docRef;

  /// The owner of the list
  ///
  /// Note: This is a bit redundant, can be removed with a bit of work in the future
  final String owner;

  /// When the list was shared with you
  final Timestamp sharedAt;

  /// Constructor to be used by factory
  SkyListSharedMeta({
    this.listId,
    this.docRef,
    this.owner,
    this.sharedAt,
  });

  /// Converts [doc] to SkyListSharedMeta
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
