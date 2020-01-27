import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_items_repository/list_items_repository.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'entities/entities.dart';

class FirebaseListItemsRepository implements ListItemsRepository {
  FirebaseListItemsRepository(ListMetadata list, String ownerId)
      : assert(list != null),
        assert(ownerId != null),
        this._collection = Firestore.instance
            .collection('shopping lists')
            .document(ownerId)
            .collection('lists')
            .document(list.id)
            .collection('items');

  final CollectionReference _collection;

  @override
  Future<void> addNewItem(ListItem item) async {
    final docRef = await _collection.add(
      item.toEntity().toDocument(),
    );
    return docRef.parent().parent().updateData(
      {
        'lastModified': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Future<void> deleteItem(ListItem item) async {
    item.docRef.parent().parent().updateData(
      {
        'lastModified': FieldValue.serverTimestamp(),
      },
    );
    return _collection.document(item.id).delete();
  }

  @override
  Stream<List<ListItem>> streamItemsFromList({
    Timestamp addedAtTimestamp,
    int limit = 10,
  }) {
    final baseQuery = _collection.limit(limit).orderBy('addedAt');

    final startAfterQuery = baseQuery.startAfter([addedAtTimestamp]);
    final query = addedAtTimestamp == null ? baseQuery : startAfterQuery;

    return query.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map(
              (doc) => ListItem.fromEntity(
                ListItemEntity.fromSnapshot(doc),
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> updateItem(ListItem item) {
    item.docRef.parent().parent().updateData(
      {
        'lastModified': FieldValue.serverTimestamp(),
      },
    );
    return item.docRef.updateData(
      item.toEntity().toDocument(),
    );
  }
}
