import 'package:equatable/equatable.dart';

import 'package:list_items_repository/list_items_repository.dart';

abstract class ListItemsState extends Equatable {
  ListItemsState();

  @override
  List<Object> get props => [];
}

class ListItemsLoading extends ListItemsState {}

class ListItemsLoaded extends ListItemsState {
  final List<ListItem> items;
  final bool hasReachedMax;

  ListItemsLoaded(
    this.items,
    this.hasReachedMax,
  );

  ListItemsLoaded copyWith({
    List<ListItem> items,
    bool hasReachedMax,
  }) {
    return ListItemsLoaded(
      items ?? this.items,
      hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [items, hasReachedMax];

  @override
  String toString() =>
      'ListItemsLoaded | items: $items, hasReachedMax $hasReachedMax';
}

class ListItemsNotLoaded extends ListItemsState {}
