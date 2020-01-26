import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListSharedWithEntity extends Equatable {
  /// The unique user id that this list is shared with
  final String sharedWithId;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp sharedAt;

  ListSharedWithEntity({
    this.sharedWithId,
    this.docRef,
    this.sharedAt,
  });

  @override
  List<Object> get props => [
        sharedWithId,
        docRef,
        sharedAt,
      ];

  @override
  String toString() {
    return 'ListSharedWithEntity | sharedWithId: $sharedWithId, sharedAt: ${sharedAt.toDate().toString()}';
  }

  static ListSharedWithEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ListSharedWithEntity(
      docRef: snapshot.reference,
      sharedWithId: snapshot.documentID ?? '',
      sharedAt: snapshot['sharedAt'] ?? Timestamp.now(),
    );
  }
}
