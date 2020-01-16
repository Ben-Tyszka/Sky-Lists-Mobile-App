import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:list_items_repository/list_items_repository.dart';

abstract class ListItemsRepository {
  Future<void> addNewItem(ListItem item);

  Future<void> deleteItem(ListItem item);

  Stream<List<ListItem>> streamItemsFromList({
    Timestamp startAfterTimestamp,
    int limit = 10,
  });

  Future<void> updateItem(ListItem item);
}
