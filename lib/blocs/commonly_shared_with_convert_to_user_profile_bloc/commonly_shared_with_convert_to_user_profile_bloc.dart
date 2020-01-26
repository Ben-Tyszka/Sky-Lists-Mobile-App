import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class CommonlySharedWithConvertToUserProfileBloc extends Bloc<
    CommonlySharedWithConvertToUserProfileEvent,
    CommonlySharedWithConvertToUserProfileState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _listConvertToUserProfileSubscription;

  CommonlySharedWithConvertToUserProfileBloc(
      {@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  CommonlySharedWithConvertToUserProfileState get initialState =>
      CommonlySharedWithConvertToUserProfileLoading();

  @override
  Stream<CommonlySharedWithConvertToUserProfileState> mapEventToState(
    CommonlySharedWithConvertToUserProfileEvent event,
  ) async* {
    if (event is LoadCommonlySharedWithConvertToUserProfile) {
      yield* _mapLoadCommonlySharedWithConvertToUserProfileToState(event);
    } else if (event is CommonlySharedWithConvertToUserProfileUpdated) {
      yield* _mapCommonlySharedWithConvertToUserProfileUpdatedToState(event);
    }
  }

  Stream<CommonlySharedWithConvertToUserProfileState>
      _mapLoadCommonlySharedWithConvertToUserProfileToState(
          LoadCommonlySharedWithConvertToUserProfile event) async* {
    _listRepository
        .streamUserProfileFromListCommonlySharedWith(event.commonSharedWith)
        .listen(
          (profile) => add(
            CommonlySharedWithConvertToUserProfileUpdated(
              userProfile: profile,
            ),
          ),
        );
  }

  Stream<CommonlySharedWithConvertToUserProfileState>
      _mapCommonlySharedWithConvertToUserProfileUpdatedToState(
          CommonlySharedWithConvertToUserProfileUpdated event) async* {
    yield CommonlySharedWithConvertToUserProfileLoaded(event.userProfile);
  }

  @override
  Future<void> close() {
    _listConvertToUserProfileSubscription?.cancel();
    return super.close();
  }
}
