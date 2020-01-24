import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListMetadataBloc extends Bloc<ListMetadataEvent, ListMetadataState> {
  final ListMetadataRepository _listsRepository;
  StreamSubscription _listsSubscription;
  StreamSubscription _listTitleSubscription;

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
      try {
        _listsSubscription?.cancel();

        if (currentState is ListMetadataLoading) {
          _listsSubscription = _listsRepository.streamLists().listen(
                (lists) => add(ListsUpdated(lists, true)),
              );
        }
        if (currentState is ListMetadatasLoaded) {
          _listsSubscription = _listsRepository
              .streamLists(
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
        yield ListMetadataNotLoaded();
      }
    } else if (event is AddList) {
      yield* _mapAddListToState(event);
    } else if (event is UpdateListMetadata) {
      yield* _mapUpdateListToState(event);
    } else if (event is DeleteListMetadata) {
      yield* _mapDeleteListToState(event);
    } else if (event is ListsUpdated) {
      yield* _mapListsUpdateToState(event);
    } else if (event is LoadListMetadata) {
      yield* _mapLoadListToState(event);
    } else if (event is ListUpdated) {
      yield* _mapListUpdateToState(event);
    }
  }

  bool _hasReachedMax(ListMetadataState state) =>
      state is ListMetadatasLoaded && state.hasReachedMax;

  Stream<ListMetadataState> _mapAddListToState(AddList event) async* {
    final list = await _listsRepository.addNewList(event.list);

    BlocProvider.of<NavigatorBloc>(event.context).add(
      NavigatorPushTo(
        SkyListPage.routeName,
        arguments: SkyListPageArguments(
          list,
        ),
      ),
    );
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

  //For list title

  Stream<ListMetadataState> _mapLoadListToState(LoadListMetadata event) async* {
    _listTitleSubscription = _listsRepository.streamList(event.list).listen(
          (newList) => add(ListUpdated(newList)),
        );
  }

  Stream<ListMetadataState> _mapListUpdateToState(ListUpdated event) async* {
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
