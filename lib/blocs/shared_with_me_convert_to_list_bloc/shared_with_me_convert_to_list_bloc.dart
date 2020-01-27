import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class SharedWithMeConvertToListBloc extends Bloc<SharedWithMeConvertToListEvent,
    SharedWithMeConvertToListState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _listSharedWithSubscription;

  SharedWithMeConvertToListBloc(
      {@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  SharedWithMeConvertToListState get initialState =>
      SharedWithMeConvertToListLoading();

  @override
  Stream<SharedWithMeConvertToListState> mapEventToState(
    SharedWithMeConvertToListEvent event,
  ) async* {
    if (event is LoadSharedWithMeConvertToList) {
      yield* _mapLoadSharedWithMeConvertToListToState(event);
    } else if (event is SharedWithMeConvertToListUpdated) {
      yield* _mapSharedWithMeConvertToListUpdatedToState(event);
    }
  }

  Stream<SharedWithMeConvertToListState>
      _mapLoadSharedWithMeConvertToListToState(
          LoadSharedWithMeConvertToList event) async* {
    _listRepository.streamListMetaFromSharedWithMe(event.sharedWithMe).listen(
          (list) => add(
            SharedWithMeConvertToListUpdated(
              list: list,
            ),
          ),
        );
  }

  Stream<SharedWithMeConvertToListState>
      _mapSharedWithMeConvertToListUpdatedToState(
          SharedWithMeConvertToListUpdated event) async* {
    yield SharedWithMeConvertToListLoaded(event.list);
  }

  @override
  Future<void> close() {
    _listSharedWithSubscription?.cancel();
    return super.close();
  }
}
