import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SharedWithMeEntity extends Equatable {
  /// The unique user id of the onwer
  final String owner;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp sharedAt;

  final String listId;

  SharedWithMeEntity({
    this.owner,
    this.docRef,
    this.sharedAt,
    this.listId,
  });

  @override
  List<Object> get props => [
        owner,
        docRef,
        sharedAt,
        listId,
      ];

  @override
  String toString() {
    return 'SharedWithMeEntity | owner: $owner, listId: $listId, sharedAt: ${sharedAt.toDate().toString()}';
  }

  static SharedWithMeEntity fromSnapshot(DocumentSnapshot snapshot) {
    return SharedWithMeEntity(
      docRef: snapshot.reference,
      owner: snapshot['owner'] ?? '',
      sharedAt: snapshot['sharedAt'] ?? Timestamp.now(),
      listId: snapshot.documentID ?? '',
    );
  }
}
