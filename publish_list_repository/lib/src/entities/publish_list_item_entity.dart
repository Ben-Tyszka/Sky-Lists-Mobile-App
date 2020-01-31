import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PublishListItemEntity extends Equatable {
  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  final String description;

  final String id;

  final String descriptor;

  final int quantity;

  PublishListItemEntity({
    this.name,
    this.docRef,
    this.description,
    this.descriptor,
    this.id,
    this.quantity,
  });

  @override
  List<Object> get props => [
        name,
        docRef,
        quantity,
        description,
        id,
        descriptor,
      ];

  @override
  String toString() {
    return 'PublishList | id: $id, name: $name, quantity ${quantity.toString()}, description: $description, descriptor:$descriptor';
  }

  static PublishListItemEntity fromSnapshot(DocumentSnapshot snapshot) {
    return PublishListItemEntity(
      docRef: snapshot.reference,
      id: snapshot.documentID,
      name: snapshot['name'] ?? 'List',
      description: snapshot['description'] ?? '',
      descriptor: snapshot['descriptor'] ?? '',
      quantity: snapshot['quantity'] ?? 0,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'descriptor': descriptor,
      'description': description,
      'quantity': quantity,
    };
  }
}
