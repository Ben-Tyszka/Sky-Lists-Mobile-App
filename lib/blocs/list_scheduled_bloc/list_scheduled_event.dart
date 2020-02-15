import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListScheduledEvent extends Equatable {
  ListScheduledEvent();

  @override
  List<Object> get props => [];
}

class LoadListsMetadata extends ListScheduledEvent {}

class UpdateListScheduled extends ListScheduledEvent {
  final ListMetadata updatedList;

  UpdateListScheduled(this.updatedList);

  @override
  List<Object> get props => [updatedList];

  @override
  String toString() => 'UpdateListScheduled | updatedList: $updatedList }';
}

class DeleteListScheduled extends ListScheduledEvent {
  final ListMetadata list;

  DeleteListScheduled(this.list);

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'DeleteListScheduled | list: $list';
}

class ListsUpdated extends ListScheduledEvent {
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  ListsUpdated(this.lists, this.hasReachedMax);

  @override
  List<Object> get props => [lists, hasReachedMax];
}

class LoadListScheduled extends ListScheduledEvent {
  final ListMetadata list;

  LoadListScheduled(this.list);

  @override
  List<Object> get props => [list];
}

class ListUpdated extends ListScheduledEvent {
  final ListMetadata list;

  ListUpdated(this.list);

  @override
  List<Object> get props => [list];
}
