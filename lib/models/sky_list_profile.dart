import 'package:cloud_firestore/cloud_firestore.dart';

class SkyListProfile {
  final String name;
  final DocumentReference docRef;
  final String email;

  SkyListProfile({
    this.name,
    this.docRef,
    this.email,
  });

  factory SkyListProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return SkyListProfile(
      name: data['name'] ?? '',
      docRef: doc.reference,
      email: data['email'] ?? '',
    );
  }
}
