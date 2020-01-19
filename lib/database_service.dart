/*import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_profile.dart';
import 'package:sky_lists/models/sky_list_share_page_meta.dart';
import 'package:sky_lists/models/sky_list_shared_meta.dart';

/// The database abstraction used throughout the app
class DatabaseService {
  // Firestore instance
  final Firestore _db = Firestore.instance;

  /// Streams the metadata, Stream<List<SkyListMeta>>, for the lists belonging to [userId]
  ///
  /// Optional [limit] sets how many documents to stream, and [afterLastModified] determines at which point in the collection do we start streaming documents
  Stream<List<SkyListMeta>> streamLists({
    @required String userId,
    int limit = 10,
    Timestamp afterLastModified,
  }) {
    // Grabs the collection, limits and orders it
    final baseQuery = _db
        .collection('shopping lists')
        .document(userId)
        .collection('lists')
        .limit(limit)
        .orderBy(
          "lastModified",
          descending: true,
        );
    // If afterLastModified is null, just grab the first 10 snapshots
    final snapshots = afterLastModified == null
        ? baseQuery.snapshots()
        : baseQuery.startAfter([
            afterLastModified,
          ]).snapshots();

    // Turn snapshot into a list of parsed SkyListMeta objects
    return snapshots.map((query) =>
        query.documents.map((doc) => SkyListMeta.fromFirestore(doc)).toList());
  }

  /// Streams the metadata for a [list]
  ///
  /// Returns Stream<SkyListMeta>
  Stream<SkyListMeta> streamListMeta({
    @required SkyListMeta list,
  }) {
    // Selects the list doc reference and maps data to SkyListMeta
    return list.docRef.snapshots().map((doc) => SkyListMeta.fromFirestore(doc));
  }

  /// Streams the metadata for a list given [list], the metadata of a list that is shared with the user
  ///
  /// Returns Stream<SkyListMeta>
  Stream<SkyListMeta> streamListMetaFromSharedMeta({
    @required SkyListSharedMeta list,
  }) {
    // Selects list from shared list meta's owner and lsitId, maps to regular list meta
    return _db
        .collection('shopping lists')
        .document(list.owner)
        .collection('lists')
        .document(list.listId)
        .snapshots()
        .map((doc) => SkyListMeta.fromFirestore(doc));
  }

  /// Creates a list, given a [name] and the [userId] that created it
  ///
  /// Returns Future<DocumentReference> pointing to the list
  Future<DocumentReference> createList(
      {@required String name, @required String userId}) {
    // Selects collection, adds list and enumerates fields
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

  /// Deletes a [list]
  void deleteList({@required SkyListMeta list}) async {
    // Gets each person the lsit is shared with
    final querySnapshot =
        await list.docRef.collection("sharedwith").getDocuments();
    // Goes into each shared with users sharedwithme collection and removes the reference to this list
    querySnapshot.documents.forEach((doc) async {
      _db
          .collection("users")
          .document(doc.documentID)
          .collection("sharedwithme")
          .document(list.id)
          .delete();
    });
    // Finally, deletes the actual list
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
    list.docRef.updateData(
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
        ? baseQuery.snapshots().map((query) => query.documents
            .map((doc) => SkyListItem.fromFirestore(doc))
            .toList())
        : baseQuery
            .startAfter([
              afterAddedAt,
            ])
            .snapshots()
            .map((query) => query.documents
                .map((doc) => SkyListItem.fromFirestore(doc))
                .toList());
  }

  /// Changes a list items hidden state
  void setItemHidden({@required SkyListItem item, @required bool status}) {
    item.docRef.updateData({
      'hidden': status,
    });
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  /// Changes a list items checked state
  void setItemChecked({@required SkyListItem item, @required bool status}) {
    item.docRef.updateData({
      'checked': status,
    });
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  /// Changes a list items checked state
  void setItemTitle({@required SkyListItem item, @required String title}) {
    item.docRef.updateData({
      'name': title,
    });
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes a list item
  void deleteItem({@required SkyListItem item}) {
    item.docRef.delete();
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
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
      'descriptor': '',
      'quantity': 0,
    });
    list.docRef.updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  /// Sets a list items quantity descriptor
  void setItemDescriptor(
      {@required SkyListItem item, @required String descriptor}) {
    item.docRef.updateData({
      'descriptor': descriptor,
    });
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  /// Sets a list items quantity descriptor
  void setItemQuantity({@required SkyListItem item, @required int quantity}) {
    item.docRef.updateData({
      'quantity': quantity,
    });
    item.docRef.parent().parent().updateData({
      'lastModified': FieldValue.serverTimestamp(),
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
      {@required SkyListMeta list, @required shareWithId}) async {
    final String ownerId = list.docRef.parent().parent().documentID;
    await list.docRef.collection("sharedwith").document(shareWithId).setData(
      {
        "sharedAt": FieldValue.serverTimestamp(),
      },
    );

    await _db
        .collection("users")
        .document(shareWithId)
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
        .document(shareWithId)
        .setData(
      {
        "count": FieldValue.increment(1),
        "lastShared": FieldValue.serverTimestamp(),
      },
      merge: true,
    );
  }

  /// Get a stream of everyone that a list is shared with
  Stream<List<SkyListSharePageMeta>> streamListSharedWith({
    @required SkyListMeta list,
    int limit = 10,
    Timestamp afterSharedAt,
  }) {
    final baseQuery = list.docRef.collection('sharedwith').limit(limit).orderBy(
          "sharedAt",
          descending: true,
        );
    return afterSharedAt == null
        ? baseQuery.snapshots().map((query) => query.documents
            .map((doc) => SkyListSharePageMeta.fromFirestore(doc))
            .toList())
        : baseQuery
            .startAfter([
              afterSharedAt,
            ])
            .snapshots()
            .map((query) => query.documents
                .map((doc) => SkyListSharePageMeta.fromFirestore(doc))
                .toList());
  }

  Future<SkyListProfile> getUsersProfile({@required String userId}) async {
    final userDoc = await _db.collection("users").document(userId).get();
    return SkyListProfile.fromFirestore(userDoc);
  }

  ///Shares a list to some user
  Future<void> removeFromSharedList(
      {@required SkyListMeta list,
      @required String ownerId,
      @required String sharedWithId}) async {
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
        .map((query) => query.documents
            .map((doc) => SkyListProfile.fromFirestore(doc))
            .toList());
  }

  /// Get a stream of a dart list objects that contain the metadata for each SkyList
  Stream<List<SkyListSharedMeta>> streamListsSharedWithMe({
    @required String userId,
    int limit = 10,
    Timestamp afterSharedAt,
  }) {
    final baseQuery = _db
        .collection("users")
        .document(userId)
        .collection("sharedwithme")
        .limit(limit)
        .orderBy(
          "sharedAt",
          descending: true,
        );

    return afterSharedAt == null
        ? baseQuery.snapshots().map((query) => query.documents
            .map((doc) => SkyListSharedMeta.fromFirestore(doc))
            .toList())
        : baseQuery
            .startAfter([
              afterSharedAt,
            ])
            .snapshots()
            .map((query) => query.documents
                .map((doc) => SkyListSharedMeta.fromFirestore(doc))
                .toList());
  }

  ///Sets a users profile data
  Future<String> getUserDisplayName({@required String userId}) async {
    final query = await _db.collection("users").document(userId).get();

    if (!query.exists) return null;
    return query.data['name'];
  }

  void updateUserProfile({
    @required String userId,
    @required String name,
    @required String email,
  }) {
    _db.collection('users').document(userId).setData({
      "name": name,
      "email": email,
    });
  }

  String getOwnerFromListMeta({@required SkyListMeta list}) {
    return list.docRef.parent().parent().documentID;
  }

  Future<SkyListMeta> getListMetaFromIds(
      {@required String ownerId, @required String listId}) async {
    final snapshot = await _db
        .collection('shopping lists')
        .document(ownerId)
        .collection('lists')
        .document(listId)
        .get();

    return SkyListMeta.fromFirestore(snapshot);
  }

  Future<void> deleteUser({@required String userId}) async {
    //deleteList
    final docs = await _db
        .collection('shopping lists')
        .document(userId)
        .collection('lists')
        .getDocuments();

    docs.documents.forEach((doc) {
      final list = SkyListMeta.fromFirestore(doc);
      deleteList(list: list);
    });

    await _db.collection('shopping lists').document(userId).delete();
    await _db.collection('users').document(userId).delete();
  }

  Future<void> updateDisplayName(
      {@required String userId, @required String newName}) async {
    await _db.collection('users').document(userId).updateData({
      'name': newName,
    });
  }
}
*/
