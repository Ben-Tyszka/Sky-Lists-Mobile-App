import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';
import 'package:sky_lists/utils/validation.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ShareListBloc extends Bloc<ShareListEvent, ShareListState> {
  ListMetadataRepository _listMetadataRepository;

  ShareListBloc({
    @required ListMetadataRepository listMetadataRepository,
  })  : assert(listMetadataRepository != null),
        _listMetadataRepository = listMetadataRepository;

  @override
  ShareListState get initialState => ShareListState.empty();

  @override
  Stream<ShareListState> transformEvents(
    Stream<ShareListEvent> events,
    Stream<ShareListState> Function(ShareListEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<ShareListState> mapEventToState(ShareListEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is Submitted) {
      yield* _mapSubmitShareListForm(
        event.email,
        event.list,
      );
    }
  }

  Stream<ShareListState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email) == null,
    );
  }

  Stream<ShareListState> _mapSubmitShareListForm(
    String email,
    ListMetadata list,
  ) async* {
    yield ShareListState.loading();
    try {
      final id = await _listMetadataRepository.getUserUidFromEmail(email);
      if (email == null) yield ShareListState.failure('Email not found');
      await _listMetadataRepository.shareListWith(
        list: list,
        toShareWith: id,
      );
      yield ShareListState.success();
    } catch (_) {
      yield ShareListState.failure('Something went wrong');
    }
  }
}
