import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_meta_data_repository.dart';

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
    if (event is LoadListsMetadata) {
      yield* _mapLoadListsToState();
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

  Stream<ListMetadataState> _mapLoadListsToState() async* {
    _listsSubscription?.cancel();
    _listsSubscription = _listsRepository.streamLists().listen(
          (lists) => add(ListsUpdated(lists)),
        );
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
    yield ListMetadatasLoaded(event.lists);
  }

  @override
  Future<void> close() {
    _listsSubscription?.cancel();
    return super.close();
  }
}
