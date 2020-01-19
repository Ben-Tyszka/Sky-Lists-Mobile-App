import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListSharedWithConvertProfileEvent extends Equatable {
  ListSharedWithConvertProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadListSharedWithConvertProfile
    extends ListSharedWithConvertProfileEvent {
  final ListSharedWith sharedWith;

  LoadListSharedWithConvertProfile({this.sharedWith});

  @override
  List<Object> get props => [sharedWith];
}

class ListSharedWithConvertProfileUpdated
    extends ListSharedWithConvertProfileEvent {
  final UserProfile userProfile;

  ListSharedWithConvertProfileUpdated({
    this.userProfile,
  });

  @override
  List<Object> get props => [
        userProfile,
      ];
}
