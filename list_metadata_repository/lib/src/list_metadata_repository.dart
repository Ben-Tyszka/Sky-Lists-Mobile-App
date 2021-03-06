import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

enum ListPermission {
  OTHERS_CAN_DELETE_ITEMS,
  OTHERS_CAN_SHARE_LIST,
}

abstract class ListMetadataRepository {
  Future<ListMetadata> addNewList(ListMetadata list);

  Future<void> deleteList(ListMetadata list);

  Stream<List<ListMetadata>> streamLists({
    Timestamp startAfterTimestamp,
    int limit = 10,
    bool showArchived = false,
  });

  Future<void> updateList(ListMetadata list);

  Stream<ListMetadata> streamList(ListMetadata list);

  Future<void> shareListWith({
    ListMetadata list,
    String toShareWith,
  });

  Future<String> getUserUidFromEmail(String emailToSearchWith);

  Stream<List<CommonSharedWith>> streamCommonSharedWith();

  Stream<List<ListSharedWith>> streamListSharedWith(
    ListMetadata list, {
    Timestamp afterSharedAt,
    int limit = 10,
  });

  Future<void> unshareList(UserProfile profileToUnshareWith, ListMetadata list);

  Stream<List<SharedWithMe>> streamListsSharedWithMe({
    Timestamp afterSharedAt,
    int limit = 10,
  });

  Stream<UserProfile> streamUserProfileFromListSharedWith(
      ListSharedWith listSharedWith);

  Stream<UserProfile> streamUserProfileFromListCommonlySharedWith(
      CommonSharedWith listSharedWith);

  Stream<ListMetadata> streamListMetaFromSharedWithMe(
      SharedWithMe sharedWithMe);

  Stream<UserProfile> streamUserProfileFromSharedWithMe(
      SharedWithMe sharedWithMe);

  bool isOwner(ListMetadata list);

  Future<void> setListPermission(
      ListPermission permission, bool state, ListMetadata list);

  Stream<bool> streamListSharedWithYouIsAllowed(ListMetadata list);

  Stream<List<ListMetadata>> streamListsThatHaveSchedules({
    Timestamp startAfterTimestamp,
    int limit = 10,
  });

  Future<void> copyAndSaveScheduleList(ListMetadata list);
}
