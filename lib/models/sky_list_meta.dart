import 'package:cloud_firestore/cloud_firestore.dart';

/// The metadata for a sky list
class SkyListMeta {
  /// The unique firestore generated id for this list
  final String id;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  /// List archive state
  final bool archived;

  /// List hidden state
  final bool hidden;

  /// List last modified time, used for ordering
  final Timestamp lastModified;

  /// Constructor to be used by factory
  SkyListMeta({
    this.id,
    this.docRef,
    this.name,
    this.archived,
    this.lastModified,
    this.hidden,
  });

  /// Converts [doc] to SkyListMeta object
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
