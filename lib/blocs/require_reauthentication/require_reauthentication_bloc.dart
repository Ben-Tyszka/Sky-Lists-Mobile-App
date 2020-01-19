import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/require_reauthentication/bloc.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/utils/validation.dart';

class RequireReauthenticationBloc
    extends Bloc<RequireReauthenticationEvent, RequireReauthenticationState> {
  UserRepository _userRepository;

  RequireReauthenticationBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RequireReauthenticationState get initialState =>
      RequireReauthenticationState.empty();

  @override
  Stream<RequireReauthenticationState> transformEvents(
    Stream<RequireReauthenticationEvent> events,
    Stream<RequireReauthenticationState> Function(
            RequireReauthenticationEvent event)
        next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<RequireReauthenticationState> mapEventToState(
      RequireReauthenticationEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is ReauthenticateWithGooglePressed) {
      yield* _mapReauthenticateWithGooglePressedToState();
    } else if (event is ReauthenticateWithEmailAndPasswordPressed) {
      yield* _mapReauthenticateWithEmailAndPasswordPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is HidePasswordChanged) {
      yield* _mapHidePasswordChangedToState();
    }
  }

  Stream<RequireReauthenticationState> _mapEmailChangedToState(
      String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email) == null,
    );
  }

  Stream<RequireReauthenticationState> _mapPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password) == null,
    );
  }

  Stream<RequireReauthenticationState> _mapHidePasswordChangedToState() async* {
    yield state.update(
      hidePassword: !state.hidePassword,
    );
  }

  Stream<RequireReauthenticationState>
      _mapReauthenticateWithGooglePressedToState() async* {
    try {
      await _userRepository.reauthenticateWithGoogle();
      yield RequireReauthenticationState.success();
    } catch (_) {
      yield RequireReauthenticationState.failure('');
    }
  }

  Stream<RequireReauthenticationState>
      _mapReauthenticateWithEmailAndPasswordPressedToState({
    String email,
    String password,
  }) async* {
    yield RequireReauthenticationState.loading();
    try {
      await _userRepository.reauthenticateWithEmailAndPassword(email, password);
      yield RequireReauthenticationState.success();
    } on PlatformException catch (error) {
      if (error.code.contains('ERROR_WRONG_PASSWORD')) {
        yield RequireReauthenticationState.failure('Wrong Email/Password');
      } else if (error.code.contains('ERROR_INVALID_CREDENTIAL') ||
          error.code.contains('ERROR_OPERATION_NOT_ALLOWED')) {
        yield RequireReauthenticationState.failure('User does not exist');
      } else if (error.code.contains('ERROR_USER_NOT_FOUND') ||
          error.code.contains('ERROR_USER_DISABLED')) {
        yield RequireReauthenticationState.failure(
            'User not found or has been disabled');
      } else {
        yield RequireReauthenticationState.failure('Error, try again later');
      }
    }
  }
}
