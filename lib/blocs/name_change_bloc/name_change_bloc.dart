import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/name_change_bloc/bloc.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/utils/validation.dart';

class NameChangeBloc extends Bloc<NameChangeEvent, NameChangeState> {
  UserRepository _userRepository;

  NameChangeBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  NameChangeState get initialState => NameChangeState.empty();

  @override
  Stream<NameChangeState> transformEvents(
    Stream<NameChangeEvent> events,
    Stream<NameChangeState> Function(NameChangeEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! NameChanged);
    });
    final debounceStream = events.where((event) {
      return (event is NameChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<NameChangeState> mapEventToState(NameChangeEvent event) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event.name);
    }
  }

  Stream<NameChangeState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameValid: validateFullName(name) == null,
    );
  }

  Stream<NameChangeState> _mapSubmittedToState(String name) async* {
    yield NameChangeState.loading();
    try {
      _userRepository.changeName(name: name);
      yield NameChangeState.success();
    } catch (_) {
      yield NameChangeState.failure('Error, try again later');
    }
  }
}
