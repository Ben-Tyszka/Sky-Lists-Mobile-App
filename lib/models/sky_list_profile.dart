import 'package:cloud_firestore/cloud_firestore.dart';

/// The data for a person that a sky list is shared with
class SkyListProfile {
  /// Name of the person
  final String name;

  /// Doc reference to the Firestore doc that holds all of the users info
  final DocumentReference docRef;

  /// The email of the person
  final String email;

  /// Constructor to be used by factory
  SkyListProfile({
    this.name,
    this.docRef,
    this.email,
  });

  /// Converts [doc] to SkyListProfile
  factory SkyListProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListProfile(
      name: data['name'] ?? '',
      docRef: doc.reference,
      email: data['email'] ?? '',
    );
  }
}
