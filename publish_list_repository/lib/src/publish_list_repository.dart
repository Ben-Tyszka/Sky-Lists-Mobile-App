import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:publish_list_repository/publish_list_repository.dart';

abstract class PublishListRepository {
  Future<void> publishList(PublishList list);
}
