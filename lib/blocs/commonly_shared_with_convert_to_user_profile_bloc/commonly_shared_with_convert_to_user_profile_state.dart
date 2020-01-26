// part of 'commonly_shared_with_convert_to_user_profile_bloc.dart';

// abstract class CommonlySharedWithConvertToUserProfileState extends Equatable {
//   const CommonlySharedWithConvertToUserProfileState();
// }

// class CommonlySharedWithConvertToUserProfileInitial extends CommonlySharedWithConvertToUserProfileState {
//   @override
//   List<Object> get props => [];
// }
import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithConvertToUserProfileState extends Equatable {
  CommonlySharedWithConvertToUserProfileState();

  @override
  List<Object> get props => [];
}

class CommonlySharedWithConvertToUserProfileLoading
    extends CommonlySharedWithConvertToUserProfileState {}

class CommonlySharedWithConvertToUserProfileLoaded
    extends CommonlySharedWithConvertToUserProfileState {
  final UserProfile userProfile;

  CommonlySharedWithConvertToUserProfileLoaded(
    this.userProfile,
  );

  CommonlySharedWithConvertToUserProfileLoaded copyWith({
    UserProfile userProfiles,
  }) {
    return CommonlySharedWithConvertToUserProfileLoaded(
      userProfiles ?? this.userProfile,
    );
  }

  @override
  List<Object> get props => [
        userProfile,
      ];

  @override
  String toString() =>
      'CommonlySharedWithConvertToUserProfileLoaded | userProfile: $userProfile';
}

class CommonlySharedWithConvertToUserProfileNotLoaded
    extends CommonlySharedWithConvertToUserProfileState {}
