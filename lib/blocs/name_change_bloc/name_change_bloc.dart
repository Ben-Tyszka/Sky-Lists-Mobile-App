import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
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
    // try {
    //   await _userRepository.signInWithEmailAndPassword(email, password);
    //   yield NameChangeState.success();
    // } on PlatformException catch (error) {
    //   if (error.code.contains('ERROR_INVALID_EMAIL') ||
    //       error.code.contains('ERROR_WRONG_PASSWORD')) {
    //     yield NameChangeState.failure('Wrong Email/Password');
    //   } else if (error.code.contains('ERROR_USER_NOT_FOUND') ||
    //       error.code.contains('ERROR_USER_DISABLED')) {
    //     yield NameChangeState.failure('User does not exist');
    //   } else if (error.code.contains('ERROR_TOO_MANY_REQUESTS')) {
    //     yield NameChangeState.failure('Too many login requests');
    //   } else {
    //     log(
    //       'Login error',
    //       name: 'NameChangeBloc _mapLoginWithEmailAndPasswordPressedToState',
    //       error: jsonEncode(error),
    //     );
    //     yield NameChangeState.failure('Internal error, try again later');
    //   }
    // }
  }
}
