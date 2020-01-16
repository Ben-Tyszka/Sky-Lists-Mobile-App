import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListMetadataBloc extends Bloc<ListMetadataEvent, ListMetadataState> {
  final ListMetadataRepository _listsRepository;
  StreamSubscription _listsSubscription;

  ListMetadataBloc({@required ListMetadataRepository listsRepository})
      : assert(listsRepository != null),
        _listsRepository = listsRepository;

  @override
  ListMetadataState get initialState => ListMetadataLoading();

  @override
  Stream<ListMetadataState> mapEventToState(
    ListMetadataEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadListsMetadata && !_hasReachedMax(currentState)) {
      _mapLoadListsToState(currentState);
    } else if (event is AddList) {
      yield* _mapAddListToState(event);
    } else if (event is UpdateListMetadata) {
      yield* _mapUpdateListToState(event);
    } else if (event is DeleteListMetadata) {
      yield* _mapDeleteListToState(event);
    } else if (event is ListsUpdated) {
      yield* _mapListsUpdateToState(event);
    }
  }

  bool _hasReachedMax(ListMetadataState state) =>
      state is ListMetadatasLoaded && state.hasReachedMax;

  Stream<ListMetadataState> _mapLoadListsToState(
      ListMetadataState state) async* {
    //_listsSubscription?.cancel();
    try {
      if (state is ListMetadataLoading) {
        _listsSubscription = _listsRepository.streamLists().listen(
              (lists) => add(ListsUpdated(lists, false)),
            );
      }
      if (state is ListMetadatasLoaded) {
        _listsSubscription = _listsRepository
            .streamLists(
          startAfterTimestamp: state.lists.last.lastModified,
        )
            .listen(
          (lists) {
            if (lists.isEmpty) {
              add(ListsUpdated(state.lists, true));
            } else if (lists.length < state.lists.length + 10) {
              add(
                ListsUpdated(state.lists + lists, true),
              );
            } else {
              add(ListsUpdated(state.lists + lists, false));
            }
          },
        );
      }
    } catch (_) {
      yield ListMetadataNotLoaded();
    }
  }

  Stream<ListMetadataState> _mapAddListToState(AddList event) async* {
    _listsRepository.addNewList(event.list);
  }

  Stream<ListMetadataState> _mapUpdateListToState(
      UpdateListMetadata event) async* {
    _listsRepository.updateList(event.updatedList);
  }

  Stream<ListMetadataState> _mapDeleteListToState(
      DeleteListMetadata event) async* {
    _listsRepository.deleteList(event.list);
  }

  Stream<ListMetadataState> _mapListsUpdateToState(ListsUpdated event) async* {
    yield ListMetadatasLoaded(
      event.lists,
      event.hasReachedMax,
    );
  }

  @override
  Future<void> close() {
    _listsSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ListMetadataState> transformEvents(
    Stream<ListMetadataEvent> events,
    Stream<ListMetadataState> Function(ListMetadataEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }
}
