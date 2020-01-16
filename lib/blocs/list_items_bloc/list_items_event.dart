import 'package:equatable/equatable.dart';

import 'package:list_items_repository/list_items_repository.dart';

abstract class ListItemsEvent extends Equatable {
  ListItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadListItems extends ListItemsEvent {}

class AddListItem extends ListItemsEvent {
  final ListItem item;

  AddListItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'AddListItem | item: $item';
}

class UpdateListItem extends ListItemsEvent {
  final ListItem updatedListItem;

  UpdateListItem(this.updatedListItem);

  @override
  List<Object> get props => [updatedListItem];

  @override
  String toString() => 'UpdateListItem | updatedListItem: $updatedListItem }';
}

class DeleteListItem extends ListItemsEvent {
  final ListItem item;

  DeleteListItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteListItem | item: $item';
}

class ListItemsUpdated extends ListItemsEvent {
  final List<ListItem> items;
  final bool hasReachedMax;

  ListItemsUpdated(this.items, this.hasReachedMax);

  @override
  List<Object> get props => [items, hasReachedMax];
}
