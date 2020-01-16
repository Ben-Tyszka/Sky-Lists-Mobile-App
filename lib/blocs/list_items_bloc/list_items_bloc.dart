import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';
import 'package:list_items_repository/list_items_repository.dart';

class ListItemsBloc extends Bloc<ListItemsEvent, ListItemsState> {
  final ListItemsRepository _itemsRepository;
  StreamSubscription _listItemsSubscription;

  ListItemsBloc({@required ListItemsRepository itemsRepository})
      : assert(itemsRepository != null),
        _itemsRepository = itemsRepository;

  @override
  ListItemsState get initialState => ListItemsLoading();

  @override
  Stream<ListItemsState> mapEventToState(
    ListItemsEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadListItems && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ListItemsLoading) {
          _listItemsSubscription =
              _itemsRepository.streamItemsFromList().listen(
                    (items) => add(ListItemsUpdated(items, false)),
                  );
        }
        if (currentState is ListItemsLoaded) {
          _listItemsSubscription = _itemsRepository
              .streamItemsFromList(
            addedAtTimestamp: currentState.items.last.addedAt,
          )
              .listen(
            (items) {
              if (items.isEmpty) {
                add(ListItemsUpdated(currentState.items, true));
              } else if (items.length < currentState.items.length + 10) {
                add(
                  ListItemsUpdated(currentState.items + items, true),
                );
              } else {
                add(ListItemsUpdated(currentState.items + items, false));
              }
            },
          );
        }
      } catch (_) {
        yield ListItemsNotLoaded();
      }
    } else if (event is AddListItem) {
      yield* _mapAddListItemsToState(event);
    } else if (event is UpdateListItem) {
      yield* _mapUpdateListItemsToState(event);
    } else if (event is DeleteListItem) {
      yield* _mapDeleteListItemsToState(event);
    } else if (event is ListItemsUpdated) {
      yield* _mapListItemsUpdateToState(event);
    }
  }

  bool _hasReachedMax(ListItemsState state) =>
      state is ListItemsLoaded && state.hasReachedMax;

  Stream<ListItemsState> _mapAddListItemsToState(AddListItem event) async* {
    _itemsRepository.addNewItem(event.item);
  }

  Stream<ListItemsState> _mapUpdateListItemsToState(
      UpdateListItem event) async* {
    _itemsRepository.updateItem(event.updatedListItem);
  }

  Stream<ListItemsState> _mapDeleteListItemsToState(
      DeleteListItem event) async* {
    _itemsRepository.deleteItem(event.item);
  }

  Stream<ListItemsState> _mapListItemsUpdateToState(
      ListItemsUpdated event) async* {
    yield ListItemsLoaded(
      event.items,
      event.hasReachedMax,
    );
  }

  @override
  Future<void> close() {
    _listItemsSubscription?.cancel();
    return super.close();
  }
}
