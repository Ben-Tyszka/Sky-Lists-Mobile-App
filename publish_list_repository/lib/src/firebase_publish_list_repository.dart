import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:publish_list_repository/publish_list_repository.dart';

class FirebasePublishListRepository implements PublishListRepository {
  FirebasePublishListRepository(String userId)
      : assert(userId != null),
        this._collection = Firestore.instance.collection('published'),
        this._userId = userId;

  final CollectionReference _collection;
  final String _userId;

  @override
  Future<void> publishList(PublishList list) async {
    _collection.add(
      list
          .copyWith(
            ownerId: _userId,
          )
          .toEntity()
          .toDocument(),
    );
  }
}
