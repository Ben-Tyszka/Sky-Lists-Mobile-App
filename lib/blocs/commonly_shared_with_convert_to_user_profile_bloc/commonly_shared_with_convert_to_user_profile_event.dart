import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithConvertToUserProfileEvent extends Equatable {
  CommonlySharedWithConvertToUserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadCommonlySharedWithConvertToUserProfile
    extends CommonlySharedWithConvertToUserProfileEvent {
  final CommonSharedWith commonSharedWith;

  LoadCommonlySharedWithConvertToUserProfile({this.commonSharedWith});

  @override
  List<Object> get props => [commonSharedWith];
}

class CommonlySharedWithConvertToUserProfileUpdated
    extends CommonlySharedWithConvertToUserProfileEvent {
  final UserProfile userProfile;

  CommonlySharedWithConvertToUserProfileUpdated({
    this.userProfile,
  });

  @override
  List<Object> get props => [
        userProfile,
      ];
}
