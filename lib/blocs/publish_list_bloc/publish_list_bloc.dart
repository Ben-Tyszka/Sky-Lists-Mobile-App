import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/publish_list_bloc/bloc.dart';

import 'package:sky_lists/utils/validation.dart';

import 'package:publish_list_repository/publish_list_repository.dart';

class PublishListBloc extends Bloc<PublishListEvent, PublishListState> {
  PublishListRepository _publishListRepository;

  PublishListBloc({
    @required PublishListRepository publishListRepository,
  })  : assert(publishListRepository != null),
        _publishListRepository = publishListRepository;

  @override
  PublishListState get initialState => PublishListState.empty();

  @override
  Stream<PublishListState> transformEvents(
    Stream<PublishListEvent> events,
    Stream<PublishListState> Function(PublishListEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! ListNameChanged && event is! DescriptionChanged);
    });
    final debounceStream = events.where((event) {
      return (event is ListNameChanged || event is DescriptionChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<PublishListState> mapEventToState(PublishListEvent event) async* {
    if (event is ListNameChanged) {
      yield* _mapListNameChangedToState(event.name);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.description);
    } else if (event is Submit) {
      yield* _mapSubmitToState(
        description: event.description,
        name: event.name,
      );
    }
  }

  Stream<PublishListState> _mapListNameChangedToState(String name) async* {
    yield state.update(
      isListNameValid: validateListName(name) == null,
    );
  }

  Stream<PublishListState> _mapDescriptionChangedToState(
      String description) async* {
    yield state.update(
      isDescriptionValid: validateDescription(description) == null,
    );
  }

  Stream<PublishListState> _mapSubmitToState({
    String name,
    String description,
  }) async* {
    yield PublishListState.loading();
    try {
      final list = PublishList(
        name,
        null,
        description: description,
      );
      await _publishListRepository.publishList(list);
      yield PublishListState.success();
    } on PlatformException catch (error) {
      log(
        'Publish error',
        name: 'PublishListBloc _mapSubmitToState',
        error: jsonEncode(error),
      );
      yield PublishListState.failure('Error, try again later');
    }
  }
}
