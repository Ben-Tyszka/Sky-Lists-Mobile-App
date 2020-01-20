import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SharedPermissionBloc
    extends Bloc<SharedPermissionEvent, SharedPermissionState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _sharedPermissionSubscription;

  SharedPermissionBloc({@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  SharedPermissionState get initialState => SharedPermissionLoading();

  @override
  Stream<SharedPermissionState> mapEventToState(
    SharedPermissionEvent event,
  ) async* {
    if (event is LoadSharedPermission) {
      yield* _mapLoadCommonlySharedWithToState(event);
    } else if (event is SharedPermissionUpdated) {
      yield* _mapCommonlySharedWithUpdatedToState(event);
    }
  }

  Stream<SharedPermissionState> _mapLoadCommonlySharedWithToState(
      LoadSharedPermission event) async* {
    _sharedPermissionSubscription?.cancel();
    _sharedPermissionSubscription =
        _listRepository.streamListSharedWithYouIsAllowed(event.list).listen(
              (value) => add(
                SharedPermissionUpdated(isAllowed: value),
              ),
            );
  }

  Stream<SharedPermissionState> _mapCommonlySharedWithUpdatedToState(
      SharedPermissionUpdated event) async* {
    yield event.isAllowed
        ? SharedPermissionAllowed()
        : SharedPermissionNotAllowed();
  }

  @override
  Future<void> close() {
    _sharedPermissionSubscription?.cancel();
    return super.close();
  }
}
