import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListSharedWithEvent extends Equatable {
  ListSharedWithEvent();

  @override
  List<Object> get props => [];
}

class LoadListSharedWith extends ListSharedWithEvent {
  final ListMetadata list;

  LoadListSharedWith({this.list});

  @override
  List<Object> get props => [list];
}

class ListSharedWithUpdated extends ListSharedWithEvent {
  final List<ListSharedWith> listSharedWith;
  final bool hasReachedMax;

  ListSharedWithUpdated({
    this.hasReachedMax,
    this.listSharedWith,
  });

  @override
  List<Object> get props => [
        hasReachedMax,
        listSharedWith,
      ];
}

class ListSharedWithUnshareUser extends ListSharedWithEvent {
  final UserProfile profile;
  final ListMetadata list;

  ListSharedWithUnshareUser({
    this.profile,
    this.list,
  });

  @override
  List<Object> get props => [
        profile,
        list,
      ];
}
