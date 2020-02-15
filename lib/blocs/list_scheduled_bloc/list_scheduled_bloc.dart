import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListScheduledBloc extends Bloc<ListScheduledEvent, ListScheduledState> {
  final ListMetadataRepository _listsRepository;
  StreamSubscription _listsSubscription;
  StreamSubscription _listTitleSubscription;

  ListScheduledBloc({@required ListMetadataRepository listsRepository})
      : assert(listsRepository != null),
        _listsRepository = listsRepository;

  @override
  ListScheduledState get initialState => ListScheduledLoading();

  @override
  Stream<ListScheduledState> mapEventToState(
    ListScheduledEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadListsMetadata && !_hasReachedMax(currentState)) {
      try {
        _listsSubscription?.cancel();

        if (currentState is ListScheduledLoading) {
          _listsSubscription =
              _listsRepository.streamListsThatHaveSchedules().listen(
                    (lists) => add(ListsUpdated(lists, true)),
                  );
        }
        if (currentState is ListScheduledsLoaded) {
          _listsSubscription = _listsRepository
              .streamListsThatHaveSchedules(
            startAfterTimestamp: currentState.lists.last.lastModified,
          )
              .listen(
            (lists) {
              if (lists.isEmpty) {
                add(ListsUpdated(currentState.lists, true));
              } else if (lists.length < currentState.lists.length + 10) {
                add(
                  ListsUpdated(currentState.lists + lists, true),
                );
              } else {
                add(ListsUpdated(currentState.lists + lists, false));
              }
            },
          );
        }
      } catch (_) {
        yield ListScheduledNotLoaded();
      }
    } else if (event is UpdateListScheduled) {
      yield* _mapUpdateListToState(event);
    } else if (event is DeleteListScheduled) {
      yield* _mapDeleteListToState(event);
    } else if (event is ListsUpdated) {
      yield* _mapListsUpdateToState(event);
    } else if (event is LoadListScheduled) {
      yield* _mapLoadListToState(event);
    } else if (event is ListUpdated) {
      yield* _mapListUpdateToState(event);
    }
  }

  bool _hasReachedMax(ListScheduledState state) =>
      state is ListScheduledsLoaded && state.hasReachedMax;

  Stream<ListScheduledState> _mapUpdateListToState(
      UpdateListScheduled event) async* {
    _listsRepository.updateList(event.updatedList);
  }

  Stream<ListScheduledState> _mapDeleteListToState(
      DeleteListScheduled event) async* {
    _listsRepository.deleteList(event.list);
  }

  Stream<ListScheduledState> _mapListsUpdateToState(ListsUpdated event) async* {
    yield ListScheduledsLoaded(
      event.lists,
      event.hasReachedMax,
    );
  }

  Stream<ListScheduledState> _mapLoadListToState(
      LoadListScheduled event) async* {
    _listTitleSubscription = _listsRepository.streamList(event.list).listen(
          (newList) => add(ListUpdated(newList)),
        );
  }

  Stream<ListScheduledState> _mapListUpdateToState(ListUpdated event) async* {
    yield ListLoaded(
      event.list,
    );
  }

  @override
  Future<void> close() {
    _listsSubscription?.cancel();
    _listTitleSubscription?.cancel();
    return super.close();
  }
}
