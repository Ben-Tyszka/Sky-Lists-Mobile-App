import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListSharedWithState extends Equatable {
  ListSharedWithState();

  @override
  List<Object> get props => [];
}

class ListSharedWithLoading extends ListSharedWithState {}

class ListSharedWithLoaded extends ListSharedWithState {
  final List<ListSharedWith> listSharedWith;
  final bool hasReachedMax;

  ListSharedWithLoaded(
    this.hasReachedMax,
    this.listSharedWith,
  );

  ListSharedWithLoaded copyWith({
    bool hasReachedMax,
    List<ListSharedWith> listSharedWith,
  }) {
    return ListSharedWithLoaded(
      hasReachedMax ?? this.hasReachedMax,
      listSharedWith ?? this.listSharedWith,
    );
  }

  @override
  List<Object> get props => [
        hasReachedMax,
        listSharedWith,
      ];

  @override
  String toString() =>
      'ListSharedWithLoaded | hasReachedMax: $hasReachedMax, listSharedWith: $listSharedWith';
}

class ListSharedWithNotLoaded extends ListSharedWithState {}
