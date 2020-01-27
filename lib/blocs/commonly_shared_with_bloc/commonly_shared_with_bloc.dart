import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class CommonlySharedWithBloc
    extends Bloc<CommonlySharedWithEvent, CommonlySharedWithState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _commonlySharedWithSubscription;

  CommonlySharedWithBloc({@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  CommonlySharedWithState get initialState => CommonlySharedWithLoading();

  @override
  Stream<CommonlySharedWithState> mapEventToState(
    CommonlySharedWithEvent event,
  ) async* {
    if (event is LoadCommonlySharedWith) {
      yield* _mapLoadCommonlySharedWithToState(event);
    } else if (event is CommonlySharedWithUpdated) {
      yield* _mapCommonlySharedWithUpdatedToState(event);
    } else if (event is CommonlySharedWithShareWithUser) {
      yield* _mapCommonlySharedWithShareWithUserToState(event);
    }
  }

  Stream<CommonlySharedWithState> _mapLoadCommonlySharedWithToState(
      LoadCommonlySharedWith event) async* {
    _commonlySharedWithSubscription?.cancel();
    _commonlySharedWithSubscription =
        _listRepository.streamCommonSharedWith().listen(
              (commonSharedWith) => add(
                CommonlySharedWithUpdated(commonSharedWith),
              ),
            );
  }

  Stream<CommonlySharedWithState> _mapCommonlySharedWithUpdatedToState(
      CommonlySharedWithUpdated event) async* {
    yield CommonlySharedWithLoaded(
      event.commonSharedWith,
    );
  }

  Stream<CommonlySharedWithState> _mapCommonlySharedWithShareWithUserToState(
      CommonlySharedWithShareWithUser event) async* {
    _listRepository.shareListWith(
      list: event.list,
      toShareWith: event.user.docRef.documentID,
    );
  }

  @override
  Future<void> close() {
    _commonlySharedWithSubscription?.cancel();
    return super.close();
  }
}
