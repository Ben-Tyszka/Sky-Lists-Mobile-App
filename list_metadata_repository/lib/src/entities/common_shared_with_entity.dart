import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommonSharedWithEntity extends Equatable {
  /// The unique user id of the onwer
  final String id;

  /// Doc reference to this doc in firestore
  final DocumentReference docRef;

  /// When this list was shared with the other user at
  final Timestamp lastShared;

  final int count;

  CommonSharedWithEntity({
    this.id,
    this.docRef,
    this.lastShared,
    this.count,
  });

  @override
  List<Object> get props => [
        id,
        docRef,
        lastShared,
        count,
      ];

  @override
  String toString() {
    return 'CommonSharedWithEntity | id: $id, count: $count, lastShared: ${lastShared.toDate().toString()}';
  }

  static CommonSharedWithEntity fromSnapshot(DocumentSnapshot snapshot) {
    return CommonSharedWithEntity(
      docRef: snapshot.reference,
      id: snapshot.documentID ?? '',
      lastShared: snapshot['lastShared'] ?? Timestamp.now(),
      count: snapshot['count'] ?? 0,
    );
  }
}
