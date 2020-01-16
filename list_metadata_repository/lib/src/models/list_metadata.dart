import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class ListMetadata {
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

  ListMetadata(
    this.name, {
    bool archived,
    bool hidden,
    String id,
    dynamic lastModified,
    DocumentReference docRef,
  })  : this.archived = archived ?? false,
        this.hidden = hidden ?? false,
        this.lastModified = lastModified ?? FieldValue.serverTimestamp(),
        this.id = id ?? '',
        this.docRef = docRef ?? null;

  ListMetadata copyWith({
    String id,
    bool archived,
    bool hidden,
    dynamic lastModified,
    DocumentReference docRef,
    String name,
  }) {
    return ListMetadata(
      name,
      archived: archived ?? this.archived,
      docRef: docRef ?? this.docRef,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^
      archived.hashCode ^
      hidden.hashCode ^
      id.hashCode ^
      docRef.hashCode ^
      lastModified.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListMetadata &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          docRef == other.docRef &&
          hidden == other.hidden &&
          id == other.id &&
          archived == other.archived &&
          lastModified == other.lastModified;

  @override
  String toString() {
    return 'ListMetadata | name: $name, id: $id, archived: $archived, modified: ${lastModified.toString()}, hidden: $hidden';
  }

  ListMetadataEntity toEntity() {
    return ListMetadataEntity(
      archived: archived,
      docRef: docRef,
      hidden: hidden,
      id: id,
      lastModified: lastModified,
      name: name,
    );
  }

  static ListMetadata fromEntity(ListMetadataEntity entity) {
    return ListMetadata(
      entity.name,
      archived: entity.archived,
      docRef: entity.docRef,
      hidden: entity.hidden,
      id: entity.id,
      lastModified: entity.lastModified,
    );
  }
}
