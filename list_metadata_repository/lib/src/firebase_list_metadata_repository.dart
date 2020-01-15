import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/list_meta_data_repository.dart';
import 'entities/entities.dart';

class FirebaseListMetadataRepository implements ListMetadataRepository {
  FirebaseListMetadataRepository(String userId)
      : assert(userId != null),
        this._collection = Firestore.instance
            .collection('shopping lists')
            .document(userId)
            .collection('lists');

  final CollectionReference _collection;

  @override
  Future<void> addNewList(String name) {
    final list = ListMetadata(name);

    return _collection.add(
      list.toEntity().toDocument(),
    );
  }

  @override
  Future<void> deleteList(ListMetadata list) async {
    return _collection.document(list.id).delete();
  }

  @override
  Stream<List<ListMetadata>> streamLists() {
    return _collection.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map(
              (doc) => ListMetadata.fromEntity(
                ListMetadataEntity.fromSnapshot(doc),
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> updateList(ListMetadata update) {
    return _collection.document(update.id).updateData(
          update.toEntity().toDocument(),
        );
  }
}
