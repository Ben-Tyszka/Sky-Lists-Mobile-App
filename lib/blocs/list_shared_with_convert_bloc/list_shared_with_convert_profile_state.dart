import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListSharedWithConvertProfileState extends Equatable {
  ListSharedWithConvertProfileState();

  @override
  List<Object> get props => [];
}

class ListSharedWithConvertProfileLoading
    extends ListSharedWithConvertProfileState {}

class ListSharedWithConvertProfileLoaded
    extends ListSharedWithConvertProfileState {
  final UserProfile userProfile;

  ListSharedWithConvertProfileLoaded(
    this.userProfile,
  );

  ListSharedWithConvertProfileLoaded copyWith({
    UserProfile userProfiles,
  }) {
    return ListSharedWithConvertProfileLoaded(
      userProfiles ?? this.userProfile,
    );
  }

  @override
  List<Object> get props => [
        userProfile,
      ];

  @override
  String toString() =>
      'ListSharedWithConvertProfileLoaded | userProfiles: $userProfile';
}

class ListSharedWithConvertProfileNotLoaded
    extends ListSharedWithConvertProfileState {}
