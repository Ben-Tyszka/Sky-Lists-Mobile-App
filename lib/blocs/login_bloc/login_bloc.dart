import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/login_bloc/bloc.dart';
import 'package:sky_lists/repositories/user_repository.dart';
import 'package:sky_lists/utils/validation.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithEmailAndPasswordPressed) {
      yield* _mapLoginWithEmailAndPasswordPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is HidePasswordChanged) {
      yield* _mapHidePasswordChangedToState();
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password),
    );
  }

  Stream<LoginState> _mapHidePasswordChangedToState() async* {
    yield state.update(
      hidePassword: !state.hidePassword,
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure('');
    }
  }

  Stream<LoginState> _mapLoginWithEmailAndPasswordPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithEmailAndPassword(email, password);
      yield LoginState.success();
    } on PlatformException catch (error) {
      if (error.code.contains('ERROR_INVALID_EMAIL') ||
          error.code.contains('ERROR_WRONG_PASSWORD')) {
        yield LoginState.failure('Wrong Email/Password');
      } else if (error.code.contains('ERROR_USER_NOT_FOUND') ||
          error.code.contains('ERROR_USER_DISABLED')) {
        yield LoginState.failure('User does not exist');
      } else if (error.code.contains('ERROR_TOO_MANY_REQUESTS')) {
        yield LoginState.failure('Too many login requests');
      } else {
        log(
          'Login error',
          name: 'LoginBloc _mapLoginWithEmailAndPasswordPressedToState',
          error: jsonEncode(error),
        );
        yield LoginState.failure('Internal error, try again later');
      }
    }
  }
}
