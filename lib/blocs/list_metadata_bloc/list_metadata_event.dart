import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ListMetadataEvent extends Equatable {
  ListMetadataEvent();

  @override
  List<Object> get props => [];
}

class LoadListsMetadata extends ListMetadataEvent {}

class AddList extends ListMetadataEvent {
  final BuildContext context;
  final ListMetadata list;

  AddList(this.list, this.context);

  @override
  List<Object> get props => [list, context];

  @override
  String toString() => 'AddList | list: $list, context: $context';
}

class UpdateListMetadata extends ListMetadataEvent {
  final ListMetadata updatedList;

  UpdateListMetadata(this.updatedList);

  @override
  List<Object> get props => [updatedList];

  @override
  String toString() => 'UpdateListMetadata | updatedList: $updatedList }';
}

class DeleteListMetadata extends ListMetadataEvent {
  final ListMetadata list;

  DeleteListMetadata(this.list);

  @override
  List<Object> get props => [list];

  @override
  String toString() => 'DeleteListMetadata | list: $list';
}

class ListsUpdated extends ListMetadataEvent {
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  ListsUpdated(this.lists, this.hasReachedMax);

  @override
  List<Object> get props => [lists, hasReachedMax];
}

// Title related
class LoadListMetadata extends ListMetadataEvent {
  final ListMetadata list;

  LoadListMetadata(this.list);

  @override
  List<Object> get props => [list];
}

class ListUpdated extends ListMetadataEvent {
  final ListMetadata list;

  ListUpdated(this.list);

  @override
  List<Object> get props => [list];
}
