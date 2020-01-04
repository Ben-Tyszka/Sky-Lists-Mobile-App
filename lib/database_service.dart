import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_profile.dart';
import 'package:sky_lists/models/sky_list_shared.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Get a stream of a dart list objects that contain the metadata for each SkyList
  Stream<List<SkyListMeta>> streamLists({
    @required String userId,
    int limit = 10,
    Timestamp afterLastModified,
  }) {
    final baseQuery = _db
        .collection('shopping lists')
        .document(userId)
        .collection('lists')
        .limit(limit)
        .orderBy(
          "lastModified",
          descending: true,
        );
    return afterLastModified == null
        ? baseQuery.snapshots().map((query) =>
            query.documents.map((doc) => SkyListMeta.fromFirestore(doc)))
        : baseQuery
            .startAfter([
              afterLastModified,
            ])
            .snapshots()
            .map((query) =>
                query.documents.map((doc) => SkyListMeta.fromFirestore(doc)));
  }

  /// Get a stream of the metadata for one skylist
  Stream<SkyListMeta> streamListMeta({
    @required SkyListMeta list,
  }) {
    return list.docRef.snapshots().map((doc) => SkyListMeta.fromFirestore(doc));
  }

  /// Create a list
  Future<DocumentReference> createList(
      {@required String name, @required String userId}) {
    return _db
        .collection('shopping lists')
        .document(userId)
        .collection('lists')
        .add(
      {
        'name': name,
        'archived': false,
        'lastModified': FieldValue.serverTimestamp(),
        'hidden': false,
      },
    );
  }

  /// Delete a list
  void deleteList({@required SkyListMeta list}) {
    list.docRef.delete();
  }

  /// Changes a lists archive state
  void setListArchive({@required SkyListMeta list, @required bool status}) {
    list.docRef.setData({
      'archived': status,
    });
  }

  /// Changes a lists hidden state
  void setListHidden({@required SkyListMeta list, @required bool status}) {
    list.docRef.setData({
      'hidden': status,
    });
  }

  /// Changes a lists title
  void setListTitle({@required SkyListMeta list, @required String name}) {
    list.docRef.setData(
      {
        'name': name,
        'lastModified': FieldValue.serverTimestamp(),
      },
    );
  }

  /// Get a stream of one SkyList's items
  Stream<List<SkyListItem>> streamListItems({
    @required SkyListMeta list,
    int limit = 10,
    Timestamp afterAddedAt,
  }) {
    final baseQuery = list.docRef.collection('items').limit(limit).orderBy(
          "addedAt",
          descending: true,
        );
    return afterAddedAt == null
        ? baseQuery.snapshots().map((query) =>
            query.documents.map((doc) => SkyListItem.fromFirestore(doc)))
        : baseQuery
            .startAfter([
              afterAddedAt,
            ])
            .snapshots()
            .map((query) =>
                query.documents.map((doc) => SkyListItem.fromFirestore(doc)));
  }

  /// Changes a list items hidden state
  void setItemHidden({@required SkyListItem item, @required bool status}) {
    item.docRef.setData({
      'hidden': status,
    });
  }

  /// Changes a list items checked state
  void setItemChecked({@required SkyListItem item, @required bool status}) {
    item.docRef.setData({
      'checked': status,
    });
  }

  /// Changes a list items checked state
  void setItemTitle({@required SkyListItem item, @required String title}) {
    item.docRef.setData({
      'name': title,
    });
  }

  /// Deletes a list item
  void deleteItem({@required SkyListItem item}) {
    item.docRef.delete();
  }

  /// Get a stream of one SkyList's items
  void addListItem({
    @required SkyListMeta list,
  }) {
    list.docRef.collection('items').add({
      'name': '',
      'checked': false,
      'addedAt': FieldValue.serverTimestamp(),
      'hidden': false,
    });
  }

  ///Searches for an email to a registered user, if match returns users uid
  Future<String> searchForEmail({@required String emailToSearchFor}) async {
    final query = await _db
        .collection("users")
        .where(
          "email",
          isEqualTo: emailToSearchFor,
        )
        .getDocuments();
    if (query.documents.isEmpty) return null;
    return query.documents.first.documentID;
  }

  ///Searches for an phone to a registered user, if match returns users uid
  Future<String> searchForPhoneNumber(
      {@required String phoneToSearchFor}) async {
    final query = await _db
        .collection("users")
        .where(
          "phoneNumber",
          isEqualTo: phoneToSearchFor,
        )
        .getDocuments();
    if (query.documents.isEmpty) return null;

    return query.documents.first.documentID;
  }

  ///Shares a list to some user
  Future<void> shareList(
      {@required SkyListMeta list,
      @required ownerId,
      @required sharedWithId}) async {
    await list.docRef.collection("sharedwith").document(sharedWithId).setData(
      {
        "sharedAt": FieldValue.serverTimestamp(),
      },
    );

    await _db
        .collection("users")
        .document(sharedWithId)
        .collection("sharedwithme")
        .document(list.id)
        .setData(
      {
        "owner": ownerId,
        "sharedAt": FieldValue.serverTimestamp(),
      },
    );

    await _db
        .collection("users")
        .document(ownerId)
        .collection("sharehistory")
        .document(sharedWithId)
        .setData(
      {
        "count": FieldValue.increment(1),
        "lastShared": FieldValue.serverTimestamp(),
      },
      merge: true,
    );
  }

  /// Get a stream of everyone that a list is shared with
  Stream<List<SkyListShared>> streamListSharedWith({
    @required SkyListMeta list,
    int limit = 10,
    Timestamp afterSharedAt,
  }) {
    final baseQuery = list.docRef.collection('sharedwith').limit(limit).orderBy(
          "sharedAt",
          descending: true,
        );
    return afterSharedAt == null
        ? baseQuery.snapshots().map((query) =>
            query.documents.map((doc) => SkyListShared.fromFirestore(doc)))
        : baseQuery
            .startAfter([
              afterSharedAt,
            ])
            .snapshots()
            .map((query) =>
                query.documents.map((doc) => SkyListShared.fromFirestore(doc)));
  }

  Future<SkyListProfile> getUsersProfile({@required String userId}) async {
    final userDoc = await _db.collection("users").document(userId).get();
    return SkyListProfile.fromFirestore(userDoc);
  }

  ///Shares a list to some user
  Future<void> removeFromSharedList(
      {@required SkyListMeta list,
      @required ownerId,
      @required sharedWithId}) async {
    await list.docRef.collection("sharedwith").document(sharedWithId).delete();

    await _db
        .collection("users")
        .document(sharedWithId)
        .collection("sharedwithme")
        .document(list.id)
        .delete();
  }

  Stream<List<SkyListProfile>> getCommonSharedWith({@required String userId}) {
    return _db
        .collection('users')
        .document(userId)
        .collection('sharehistory')
        .orderBy('count', descending: true)
        .limit(4)
        .snapshots()
        .map((query) =>
            query.documents.map((doc) => SkyListProfile.fromFirestore(doc)));
  }
}
