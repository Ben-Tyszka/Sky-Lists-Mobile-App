import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:publish_list_repository/publish_list_repository.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

import 'entities/entities.dart';

class FirebasePublishListRepository implements PublishListRepository {
  FirebasePublishListRepository(String userId, ListMetadata listMetadata)
      : assert(userId != null),
        this._collection = Firestore.instance.collection('published'),
        this._userId = userId,
        this._listMetadata = listMetadata;

  final CollectionReference _collection;
  final ListMetadata _listMetadata;
  final String _userId;

  @override
  Future<DocumentReference> publishList(PublishList list) async {
    return _collection.add(
      list
          .copyWith(
            ownerId: _userId,
          )
          .toEntity()
          .toDocument(),
    );
  }

  Future<void> addListItems(PublishList list) async {
    final items = await _listMetadata.docRef.collection('items').getDocuments();
    final publishItems = items.documents
        .map(
          (snapshot) => PublishListItem.fromEntity(
            PublishListItemEntity.fromSnapshot(snapshot),
          ),
        )
        .toList();
    for (final item in publishItems) {
      await list.docRef.collection('items').add(item.toEntity().toDocument());
    }
  }
}
