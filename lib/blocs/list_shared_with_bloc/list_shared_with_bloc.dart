import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import './bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListSharedWithBloc
    extends Bloc<ListSharedWithEvent, ListSharedWithState> {
  final ListMetadataRepository _listRepository;
  StreamSubscription _listSharedWithSubscription;

  ListSharedWithBloc({@required ListMetadataRepository listRepository})
      : assert(listRepository != null),
        _listRepository = listRepository;

  @override
  ListSharedWithState get initialState => ListSharedWithLoading();

  @override
  Stream<ListSharedWithState> mapEventToState(
    ListSharedWithEvent event,
  ) async* {
    final currentState = state;
    if (event is LoadListSharedWith && !_hasReachedMax(currentState)) {
      try {
        _listSharedWithSubscription?.cancel();
        if (currentState is ListSharedWithLoading) {
          _listSharedWithSubscription =
              _listRepository.streamListSharedWith(event.list).listen(
                    (listSharedWith) => add(
                      ListSharedWithUpdated(
                        hasReachedMax: true,
                        listSharedWith: listSharedWith,
                      ),
                    ),
                  );
        }
        if (currentState is ListSharedWithLoaded) {
          _listSharedWithSubscription = _listRepository
              .streamListSharedWith(
            event.list,
            afterSharedAt: currentState.listSharedWith.last.sharedAt,
          )
              .listen(
            (listSharedWith) {
              if (listSharedWith.isEmpty) {
                add(ListSharedWithUpdated(
                  hasReachedMax: true,
                  listSharedWith: currentState.listSharedWith,
                ));
              } else if (listSharedWith.length <
                  currentState.listSharedWith.length + 10) {
                _listRepository.streamListSharedWith(event.list).listen(
                      (listSharedWith) => add(
                        ListSharedWithUpdated(
                          hasReachedMax: true,
                          listSharedWith:
                              currentState.listSharedWith + listSharedWith,
                        ),
                      ),
                    );
              } else {
                _listRepository.streamListSharedWith(event.list).listen(
                      (listSharedWith) => add(
                        ListSharedWithUpdated(
                          hasReachedMax: false,
                          listSharedWith:
                              currentState.listSharedWith + listSharedWith,
                        ),
                      ),
                    );
              }
            },
          );
        }
      } catch (_) {
        yield ListSharedWithNotLoaded();
      }
    } else if (event is ListSharedWithUpdated) {
      yield* _mapListSharedWithUpdatedToState(event);
    } else if (event is ListSharedWithUnshareUser) {
      yield* _mapListSharedWithUnshareUserToState(event);
    }
  }

  bool _hasReachedMax(ListSharedWithState state) =>
      state is ListSharedWithLoaded && state.hasReachedMax;

  Stream<ListSharedWithState> _mapListSharedWithUpdatedToState(
      ListSharedWithUpdated event) async* {
    yield ListSharedWithLoaded(event.hasReachedMax, event.listSharedWith);
  }

  Stream<ListSharedWithState> _mapListSharedWithUnshareUserToState(
      ListSharedWithUnshareUser event) async* {
    _listRepository.unshareList(event.profile, event.list);
  }

  @override
  Future<void> close() {
    _listSharedWithSubscription?.cancel();
    return super.close();
  }
}
