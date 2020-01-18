import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListSharedWithState extends Equatable {
  ListSharedWithState();

  @override
  List<Object> get props => [];
}

class ListSharedWithLoading extends ListSharedWithState {}

class ListSharedWithLoaded extends ListSharedWithState {
  final List<UserProfile> profiles;
  final List<ListSharedWith> listSharedWith;
  final bool hasReachedMax;

  ListSharedWithLoaded(
    this.profiles,
    this.hasReachedMax,
    this.listSharedWith,
  );

  ListSharedWithLoaded copyWith({
    List<UserProfile> profiles,
    bool hasReachedMax,
    List<ListSharedWith> listSharedWith,
  }) {
    return ListSharedWithLoaded(
      profiles ?? this.profiles,
      hasReachedMax ?? this.hasReachedMax,
      listSharedWith ?? this.listSharedWith,
    );
  }

  @override
  List<Object> get props => [
        profiles,
        hasReachedMax,
        listSharedWith,
      ];

  @override
  String toString() =>
      'ListSharedWithLoaded | profiles: $profiles, hasReachedMax: $hasReachedMax, listSharedWith: $listSharedWith';
}

class ListSharedWithNotLoaded extends ListSharedWithState {}
