import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListScheduledState extends Equatable {
  ListScheduledState();

  @override
  List<Object> get props => [];
}

class ListScheduledLoading extends ListScheduledState {}

class ListScheduledsLoaded extends ListScheduledState {
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  ListScheduledsLoaded(
    this.lists,
    this.hasReachedMax,
  );

  ListScheduledsLoaded copyWith({
    List<ListMetadata> lists,
    bool hasReachedMax,
  }) {
    return ListScheduledsLoaded(
      lists ?? this.lists,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [lists, hasReachedMax];

  @override
  String toString() =>
      'ListScheduledsLoaded | lists: $lists, hasReachedMax $hasReachedMax';
}

class ListScheduledNotLoaded extends ListScheduledState {}

class ListLoaded extends ListScheduledState {
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
  String toString() => 'ScheduledListLoaded | list: $list';
}
