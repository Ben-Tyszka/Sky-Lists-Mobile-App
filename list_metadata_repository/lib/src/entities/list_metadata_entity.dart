import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListMetadataEntity extends Equatable {
  /// Unqiue identifier for this list
  final String id;

  /// List archive state
  final bool archived;

  /// List hidden state
  final bool hidden;

  /// List last modified time, used for ordering
  final dynamic lastModified;

  /// The doc reference for the firestore document this class represents
  final DocumentReference docRef;

  /// Name of the list
  final String name;

  ListMetadataEntity({
    this.id,
    this.name,
    this.docRef,
    this.hidden,
    this.archived,
    this.lastModified,
  });

  @override
  List<Object> get props => [
        name,
        id,
        archived,
        docRef,
        lastModified,
        hidden,
      ];

  @override
  String toString() {
    return 'ListMetadataEntity | name: $name, id: $id, archived: $archived, modified: ${lastModified.toString()}, hidden: $hidden';
  }

  static ListMetadataEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ListMetadataEntity(
      id: snapshot.documentID,
      docRef: snapshot.reference,
      name: snapshot['name'] ?? 'List',
      archived: snapshot['archived'] ?? false,
      lastModified: snapshot['lastModified'] ?? FieldValue.serverTimestamp(),
      hidden: snapshot['hidden'] ?? false,
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "archived": archived,
      "lastModified": lastModified,
      "hidden": hidden,
    };
  }
}
