import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithState extends Equatable {
  CommonlySharedWithState();

  @override
  List<Object> get props => [];
}

class CommonlySharedWithLoading extends CommonlySharedWithState {}

class CommonlySharedWithLoaded extends CommonlySharedWithState {
  final List<UserProfile> profiles;

  CommonlySharedWithLoaded(
    this.profiles,
  );

  CommonlySharedWithLoaded copyWith({
    List<UserProfile> profiles,
  }) {
    return CommonlySharedWithLoaded(
      profiles ?? this.profiles,
    );
  }

  @override
  List<Object> get props => [profiles];

  @override
  String toString() => 'CommonlySharedWithLoaded | profiles: $profiles';
}

class CommonlySharedWithNotLoaded extends CommonlySharedWithState {}
