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
  Future<ListMetadata> addNewList(ListMetadata list) async {
    final doc = await _collection.add(
      list.toEntity().toDocument(),
    );
    final snap = await doc.get();
    return ListMetadata.fromEntity(ListMetadataEntity.fromSnapshot(snap));
  }

  @override
  Future<void> deleteList(ListMetadata list) async {
    return _collection.document(list.id).delete();
  }

  @override
  Stream<List<ListMetadata>> streamLists({
    Timestamp startAfterTimestamp,
    int limit = 10,
    bool showArchived = false,
  }) {
    final baseQuery = _collection
        .limit(limit)
        .where('hidden', isEqualTo: false)
        .where('archived', isEqualTo: showArchived);

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
  Stream<ListMetadata> streamList(ListMetadata list) {
    return list.docRef.snapshots().map((snapshot) =>
        ListMetadata.fromEntity(ListMetadataEntity.fromSnapshot(snapshot)));
  }

  @override
  Future<void> shareListWith({
    ListMetadata list,
    String toShareWith,
  }) async {
    await list.docRef.collection('sharedwith').document(toShareWith).setData(
      {
        'sharedAt': FieldValue.serverTimestamp(),
      },
    );
    await Firestore.instance
        .collection('users')
        .document(toShareWith)
        .collection('sharedwithme')
        .document(list.id)
        .setData(
      {
        'owner': list.docRef.parent().parent().documentID,
        'sharedAt': FieldValue.serverTimestamp(),
      },
    );
    await Firestore.instance
        .collection('users')
        .document(list.docRef.parent().parent().documentID)
        .collection('sharehistory')
        .document(toShareWith)
        .setData(
      {
        'count': FieldValue.increment(1),
        'lastShared': FieldValue.serverTimestamp(),
      },
    );
  }

  @override
  Future<String> getUserUidFromEmail(String emailToSearchWith) async {
    final query = await Firestore.instance
        .collection('users')
        .where(
          'email',
          isEqualTo: emailToSearchWith,
        )
        .getDocuments();
    if (query.documents.isEmpty) return null;
    if (_userId == query.documents.first.documentID) return 'SELF';

    return query.documents.first.documentID;
  }

  Stream<List<CommonSharedWith>> streamCommonSharedWith() {
    return Firestore.instance
        .collection('users')
        .document(_userId)
        .collection('sharehistory')
        .orderBy('count', descending: true)
        .limit(4)
        .snapshots()
        .map(
          (query) => query.documents.map(
            (doc) {
              return CommonSharedWith.fromEntity(
                  CommonSharedWithEntity.fromSnapshot(doc));
            },
          ).toList(),
        );
  }

  @override
  Stream<List<ListSharedWith>> streamListSharedWith(
    ListMetadata list, {
    Timestamp afterSharedAt,
    int limit = 10,
  }) {
    final baseQuery = list.docRef.collection('sharedwith').limit(limit).orderBy(
          'sharedAt',
          descending: true,
        );
    final startAfterQuery = baseQuery.startAfter([afterSharedAt]);
    final query = afterSharedAt == null ? baseQuery : startAfterQuery;

    return query.snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => ListSharedWith.fromEntity(
                  ListSharedWithEntity.fromSnapshot(doc),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<void> unshareList(
      UserProfile profileToUnshareWith, ListMetadata list) async {
    await list.docRef
        .collection('sharedwith')
        .document(profileToUnshareWith.docRef.documentID)
        .delete();

    await Firestore.instance
        .collection('users')
        .document(profileToUnshareWith.docRef.documentID)
        .collection('sharedwithme')
        .document(list.id)
        .delete();
  }

  @override
  Stream<List<SharedWithMe>> streamListsSharedWithMe({
    Timestamp afterSharedAt,
    int limit = 10,
  }) {
    final baseQuery = Firestore.instance
        .collection('users')
        .document(_userId)
        .collection('sharedwithme')
        .limit(limit)
        .orderBy(
          'sharedAt',
          descending: true,
        );

    final startAfterQuery = baseQuery.startAfter([afterSharedAt]);
    final query = afterSharedAt == null ? baseQuery : startAfterQuery;

    return query.snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => SharedWithMe.fromEntity(
                  SharedWithMeEntity.fromSnapshot(doc),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<UserProfile> streamUserProfileFromListSharedWith(
      ListSharedWith listSharedWith) {
    return Firestore.instance
        .collection('users')
        .document(listSharedWith.sharedWithId)
        .snapshots()
        .map(
          (docSnapshot) => UserProfile.fromEntity(
            UserProfileEntity.fromSnapshot(docSnapshot),
          ),
        );
  }

  @override
  Stream<ListMetadata> streamListMetaFromSharedWithMe(
      SharedWithMe sharedWithMe) {
    return Firestore.instance
        .collection('shopping lists')
        .document(sharedWithMe.owner)
        .collection('lists')
        .document(sharedWithMe.listId)
        .snapshots()
        .map(
          (docSnapshot) => ListMetadata.fromEntity(
            ListMetadataEntity.fromSnapshot(docSnapshot),
          ),
        );
  }

  @override
  Stream<UserProfile> streamUserProfileFromSharedWithMe(
      SharedWithMe sharedWithMe) {
    return Firestore.instance
        .collection('users')
        .document(sharedWithMe.owner)
        .snapshots()
        .map(
          (docSnapshot) => UserProfile.fromEntity(
            UserProfileEntity.fromSnapshot(docSnapshot),
          ),
        );
  }

  bool isOwner(ListMetadata list) {
    return list.docRef.parent().parent().documentID == _userId;
  }

  Future<void> setListPermission(
      ListPermission permission, bool state, ListMetadata list) {
    if (!isOwner(list)) return null;
    if (permission == ListPermission.OTHERS_CAN_DELETE_ITEMS)
      return list.docRef.updateData({
        'othersCanDeleteItems': state,
      });
    if (permission == ListPermission.OTHERS_CAN_SHARE_LIST)
      return list.docRef.updateData({
        'othersCanShareList': state,
      });
    return null;
  }

  @override
  Stream<bool> streamListSharedWithYouIsAllowed(ListMetadata list) {
    return list.docRef.collection('sharedwith').snapshots().map(
          (query) => query.documents
              .where((doc) => doc.documentID == _userId)
              .isNotEmpty,
        );
  }

  @override
  Stream<UserProfile> streamUserProfileFromListCommonlySharedWith(
      CommonSharedWith listSharedWith) {
    return Firestore.instance
        .collection('users')
        .document(listSharedWith.id)
        .snapshots()
        .map(
          (docSnapshot) => UserProfile.fromEntity(
            UserProfileEntity.fromSnapshot(docSnapshot),
          ),
        );
  }
}
