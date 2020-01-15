import 'dart:async';

import 'package:list_metadata_repository/list_meta_data_repository.dart';

abstract class ListMetadataRepository {
  Future<void> addNewList(String name);

  Future<void> deleteList(ListMetadata list);

  Stream<List<ListMetadata>> streamLists();

  Future<void> updateList(ListMetadata list);
}
