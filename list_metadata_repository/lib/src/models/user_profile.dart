import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class UserProfile {
  /// User email
  final String email;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the user
  final String name;

  UserProfile({
    String name,
    String email,
    DocumentReference docRef,
  })  : this.name = name ?? '',
        this.email = email ?? '',
        this.docRef = docRef ?? null;

  UserProfile copyWith({
    String email,
    DocumentReference docRef,
    String name,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      docRef: docRef ?? this.docRef,
    );
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ docRef.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          email == other.email;

  @override
  String toString() {
    return 'ListProfile | name: $name, email: $email';
  }

  UserProfile toEntity() {
    return UserProfile(
      email: email,
      docRef: docRef,
      name: name,
    );
  }

  static UserProfile fromEntity(UserProfileEntity entity) {
    return UserProfile(
      name: entity.name,
      email: entity.email,
      docRef: entity.docRef,
    );
  }
}
