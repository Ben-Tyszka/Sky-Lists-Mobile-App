import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PublishListEntity extends Equatable {
  /// List last modified time, used for ordering
  final dynamic addedAt;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  final String description;

  final String id;

  final String ownerId;

  final int likes;

  PublishListEntity({
    this.name,
    this.docRef,
    this.description,
    this.addedAt,
    this.id,
    this.ownerId,
    this.likes,
  });

  @override
  List<Object> get props =>
      [name, docRef, addedAt, description, id, ownerId, likes];

  @override
  String toString() {
    return 'PublishList | id: $id, name: $name, addedAt ${addedAt.toString()}, description: $description, owner:$ownerId, likes:$likes';
  }

  static PublishListEntity fromSnapshot(DocumentSnapshot snapshot) {
    return PublishListEntity(
      docRef: snapshot.reference,
      id: snapshot.documentID,
      name: snapshot['name'] ?? 'List',
      description: snapshot['description'] ?? '',
      addedAt: snapshot['addedAt'] ?? Timestamp.now(),
      ownerId: snapshot['owner'] ?? '',
      likes: snapshot['likes'] ?? '',
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'addedAt': FieldValue.serverTimestamp(),
      'description': description,
      'owner': ownerId,
      'likes': likes,
    };
  }
}
