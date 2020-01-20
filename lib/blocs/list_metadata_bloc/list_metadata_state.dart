import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListMetadataState extends Equatable {
  ListMetadataState();

  @override
  List<Object> get props => [];
}

class ListMetadataLoading extends ListMetadataState {}

class ListMetadatasLoaded extends ListMetadataState {
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  ListMetadatasLoaded(
    this.lists,
    this.hasReachedMax,
  );

  ListMetadatasLoaded copyWith({
    List<ListMetadata> lists,
    bool hasReachedMax,
  }) {
    return ListMetadatasLoaded(
      lists ?? this.lists,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [lists, hasReachedMax];

  @override
  String toString() =>
      'ListMetadatasLoaded | lists: $lists, hasReachedMax $hasReachedMax';
}

class ListMetadataNotLoaded extends ListMetadataState {}

class ListLoaded extends ListMetadataState {
  final ListMetadata list;

  ListLoaded(this.list);

  ListLoaded copyWith({ListMetadata list}) {
    return ListLoaded(
      list ?? this.list,
    );
  }

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'ListLoaded | list: $list';
}
