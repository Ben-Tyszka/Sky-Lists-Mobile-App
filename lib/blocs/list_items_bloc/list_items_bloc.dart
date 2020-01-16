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
      : assert(_itemsRepository != null),
        _itemsRepository = itemsRepository;

  @override
  ListItemsState get initialState => ListItemsLoading();

  @override
  Stream<ListItemsState> mapEventToState(
    ListItemsEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadListItems && !_hasReachedMax(currentState)) {
      _mapLoadListItemsToState(currentState);
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

  Stream<ListItemsState> _mapLoadListItemsToState(ListItemsState state) async* {
    //_listsSubscription?.cancel();
    try {
      if (state is ListItemsLoading) {
        _listItemsSubscription = _itemsRepository.streamItemsFromList().listen(
              (items) => add(ListItemsUpdated(items, false)),
            );
      }
      if (state is ListItemsLoaded) {
        _listItemsSubscription = _itemsRepository
            .streamItemsFromList(
          addedAtTimestamp: state.items.last.addedAt,
        )
            .listen(
          (items) {
            if (items.isEmpty) {
              add(ListItemsUpdated(state.items, true));
            } else if (items.length < state.items.length + 10) {
              add(
                ListItemsUpdated(state.items + items, true),
              );
            } else {
              add(ListItemsUpdated(state.items + items, false));
            }
          },
        );
      }
    } catch (_) {
      yield ListItemsNotLoaded();
    }
  }

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

  @override
  Stream<ListItemsState> transformEvents(
    Stream<ListItemsEvent> events,
    Stream<ListItemsState> Function(ListItemsEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }
}
