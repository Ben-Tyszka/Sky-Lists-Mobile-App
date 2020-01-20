import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class SharedWithMeBloc extends Bloc<SharedWithMeEvent, SharedWithMeState> {
  final ListMetadataRepository _listsRepository;
  StreamSubscription _sharedWithMeSubscription;

  SharedWithMeBloc({@required ListMetadataRepository listsRepository})
      : assert(listsRepository != null),
        _listsRepository = listsRepository;

  @override
  SharedWithMeState get initialState => SharedWithMeLoading();

  @override
  Stream<SharedWithMeState> mapEventToState(
    SharedWithMeEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadSharedWithMe && !_hasReachedMax(currentState)) {
      try {
        _sharedWithMeSubscription?.cancel();

        if (currentState is SharedWithMeLoading) {
          _sharedWithMeSubscription =
              _listsRepository.streamListsSharedWithMe().listen(
                    (sharedWithMe) => add(
                      SharedWithMeUpdated(
                        sharedWithMe: sharedWithMe,
                        hasReachedMax: true,
                      ),
                    ),
                  );
        }
        if (currentState is SharedWithMeLoaded) {
          _sharedWithMeSubscription = _listsRepository
              .streamListsSharedWithMe(
            afterSharedAt: currentState.sharedWithMe.last.sharedAt,
          )
              .listen(
            (sharedWithMe) {
              if (sharedWithMe.isEmpty) {
                add(
                  SharedWithMeUpdated(
                    sharedWithMe: currentState.sharedWithMe,
                    hasReachedMax: true,
                  ),
                );
              } else if (sharedWithMe.length <
                  currentState.sharedWithMe.length + 10) {
                add(
                  SharedWithMeUpdated(
                      sharedWithMe: currentState.sharedWithMe + sharedWithMe,
                      hasReachedMax: true),
                );
              } else {
                add(SharedWithMeUpdated(
                    sharedWithMe: currentState.sharedWithMe + sharedWithMe,
                    hasReachedMax: false));
              }
            },
          );
        }
      } catch (_) {
        yield SharedWithMeNotLoaded();
      }
    } else if (event is SharedWithMeUpdated) {
      yield* _mapSharedWithMeUpdateToState(event);
    }
  }

  bool _hasReachedMax(SharedWithMeState state) =>
      state is SharedWithMeLoaded && state.hasReachedMax;

  Stream<SharedWithMeState> _mapSharedWithMeUpdateToState(
      SharedWithMeUpdated event) async* {
    yield SharedWithMeLoaded(
      sharedWithMe: event.sharedWithMe,
      hasReachedMax: event.hasReachedMax,
    );
  }

  @override
  Future<void> close() {
    _sharedWithMeSubscription?.cancel();
    return super.close();
  }
}
