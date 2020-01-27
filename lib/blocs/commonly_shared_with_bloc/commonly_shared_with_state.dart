import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithState extends Equatable {
  CommonlySharedWithState();

  @override
  List<Object> get props => [];
}

class CommonlySharedWithLoading extends CommonlySharedWithState {}

class CommonlySharedWithLoaded extends CommonlySharedWithState {
  final List<CommonSharedWith> commonSharedWith;

  CommonlySharedWithLoaded(
    this.commonSharedWith,
  );

  CommonlySharedWithLoaded copyWith({
    List<UserProfile> commonSharedWith,
  }) {
    return CommonlySharedWithLoaded(
      commonSharedWith ?? this.commonSharedWith,
    );
  }

  @override
  List<Object> get props => [commonSharedWith];

  @override
  String toString() =>
      'CommonlySharedWithLoaded | commonSharedWith: $commonSharedWith';
}

class CommonlySharedWithNotLoaded extends CommonlySharedWithState {}
