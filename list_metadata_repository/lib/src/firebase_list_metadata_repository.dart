import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'entities/entities.dart';

class FirebaseListMetadataRepository implements ListMetadataRepository {
  FirebaseListMetadataRepository(String userId)
      : assert(userId != null),
        this._collection = Firestore.instance
            .collection('shopping lists')
            .document(userId)
            .collection('lists'),
        this._userId = userId;

  final CollectionReference _collection;
  final String _userId;

  @override
  Future<void> addNewList(ListMetadata list) {
    return _collection.add(
      list.toEntity().toDocument(),
    );
  }

  @override
  Future<void> deleteList(ListMetadata list) async {
    return _collection.document(list.id).delete();
  }

  @override
  Stream<List<ListMetadata>> streamLists({
    Timestamp startAfterTimestamp,
    int limit = 10,
  }) {
    final baseQuery = _collection.limit(limit).orderBy(
          "lastModified",
          descending: true,
        );
    final startAfterQuery = baseQuery.startAfter([startAfterTimestamp]);
    final query = startAfterTimestamp == null ? baseQuery : startAfterQuery;

    return query.snapshots().map(
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
    return Firestore().runTransaction(
      (Transaction transaction) => update.docRef.updateData(
        update.toEntity().toDocument(),
      ),
    );
  }

  @override
  Stream<ListMetadata> streamListTitle(ListMetadata list) {
    return list.docRef.snapshots().map((snapshot) =>
        ListMetadata.fromEntity(ListMetadataEntity.fromSnapshot(snapshot)));
  }

  @override
  Future<void> shareListWith({
    ListMetadata list,
    String toShareWith,
  }) async {
    await list.docRef.collection('sharedwith').document(toShareWith).updateData(
      {
        'sharedAt': FieldValue.serverTimestamp(),
      },
    );
    await Firestore.instance
        .collection("users")
        .document(toShareWith)
        .collection("sharedwithme")
        .document(list.id)
        .updateData(
      {
        "owner": list.docRef.parent().parent().documentID,
        "sharedAt": FieldValue.serverTimestamp(),
      },
    );
    await Firestore.instance
        .collection("users")
        .document(list.docRef.parent().parent().documentID)
        .collection("sharehistory")
        .document(toShareWith)
        .updateData(
      {
        "count": FieldValue.increment(1),
        "lastShared": FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Future<String> getUserUidFromEmail(String emailToSearchWith) async {
    final query = await Firestore.instance
        .collection("users")
        .where(
          "email",
          isEqualTo: emailToSearchWith,
        )
        .getDocuments();
    if (query.documents.isEmpty) return null;
    return query.documents.first.documentID;
  }

  Stream<List<UserProfile>> streamCommonSharedWith() {
    return Firestore.instance
        .collection('users')
        .document(_userId)
        .collection('sharehistory')
        .orderBy('count', descending: true)
        .limit(4)
        .snapshots()
        .map((query) => query.documents
            .map(
              (doc) => UserProfile.fromEntity(
                UserProfileEntity.fromSnapshot(doc),
              ),
            )
            .toList());
  }
}
