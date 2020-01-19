import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListMetadataRepository {
  Future<void> addNewList(ListMetadata list);

  Future<void> deleteList(ListMetadata list);

  Stream<List<ListMetadata>> streamLists({
    Timestamp startAfterTimestamp,
    int limit = 10,
  });

  Future<void> updateList(ListMetadata list);

  Stream<ListMetadata> streamListTitle(ListMetadata list);

  Future<void> shareListWith({
    ListMetadata list,
    String toShareWith,
  });

  Future<String> getUserUidFromEmail(String emailToSearchWith);

  Stream<List<UserProfile>> streamCommonSharedWith();

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
}
