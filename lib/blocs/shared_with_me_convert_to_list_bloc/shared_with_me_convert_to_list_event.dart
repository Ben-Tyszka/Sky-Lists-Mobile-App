import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class SharedWithMeConvertToListEvent extends Equatable {
  SharedWithMeConvertToListEvent();

  @override
  List<Object> get props => [];
}

class LoadSharedWithMeConvertToList extends SharedWithMeConvertToListEvent {
  final SharedWithMe sharedWithMe;

  LoadSharedWithMeConvertToList({this.sharedWithMe});

  @override
  List<Object> get props => [sharedWithMe];
}

class SharedWithMeConvertToListUpdated extends SharedWithMeConvertToListEvent {
  final ListMetadata list;

  SharedWithMeConvertToListUpdated({
    this.list,
  });

  @override
  List<Object> get props => [
        list,
      ];
}
