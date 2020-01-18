import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  /// User email
  final String email;

  /// User display name
  final String name;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  UserProfileEntity({
    this.name,
    this.docRef,
    this.email,
  });

  @override
  List<Object> get props => [
        name,
        docRef,
        email,
      ];

  @override
  String toString() {
    return 'UserProfileEntity | name: $name, email: $email';
  }

  static UserProfileEntity fromSnapshot(DocumentSnapshot snapshot) {
    return UserProfileEntity(
      docRef: snapshot.reference,
      name: snapshot['name'] ?? '',
      email: snapshot['email'] ?? '',
    );
  }
}
