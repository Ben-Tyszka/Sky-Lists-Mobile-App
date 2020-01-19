import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListSharedWithConvertProfileBloc extends Bloc<
    ListSharedWithConvertProfileEvent, ListSharedWithConvertProfileState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _listSharedWithSubscription;

  ListSharedWithConvertProfileBloc(
      {@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  ListSharedWithConvertProfileState get initialState =>
      ListSharedWithConvertProfileLoading();

  @override
  Stream<ListSharedWithConvertProfileState> mapEventToState(
    ListSharedWithConvertProfileEvent event,
  ) async* {
    if (event is LoadListSharedWithConvertProfile) {
      _mapLoadListSharedWithConvertProfileToState(event);
    } else if (event is ListSharedWithConvertProfileUpdated) {
      yield* _mapListSharedWithConvertProfileUpdatedToState(event);
    }
  }

  Stream<ListSharedWithConvertProfileState>
      _mapLoadListSharedWithConvertProfileToState(
          LoadListSharedWithConvertProfile event) async* {
    _listRepository
        .streamUserProfileFromListSharedWith(event.sharedWith)
        .listen(
          (profile) => add(
            ListSharedWithConvertProfileUpdated(
              userProfile: profile,
            ),
          ),
        );
  }

  Stream<ListSharedWithConvertProfileState>
      _mapListSharedWithConvertProfileUpdatedToState(
          ListSharedWithConvertProfileUpdated event) async* {
    yield ListSharedWithConvertProfileLoaded(event.userProfile);
  }

  @override
  Future<void> close() {
    _listSharedWithSubscription?.cancel();
    return super.close();
  }
}
