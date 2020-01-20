import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class SharedPermissionEvent extends Equatable {
  SharedPermissionEvent();

  @override
  List<Object> get props => [];
}

class LoadSharedPermission extends SharedPermissionEvent {
  final ListMetadata list;
  LoadSharedPermission({this.list});

  @override
  List<Object> get props => [];
}

class SharedPermissionUpdated extends SharedPermissionEvent {
  final bool isAllowed;

  SharedPermissionUpdated({
    this.isAllowed,
  });

  @override
  List<Object> get props => [isAllowed];
}
