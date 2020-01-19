import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/change_password_bloc/bloc.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/utils/validation.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository _userRepository;

  ChangePasswordBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ChangePasswordState get initialState => ChangePasswordState.empty();

  @override
  Stream<ChangePasswordState> transformEvents(
    Stream<ChangePasswordEvent> events,
    Stream<ChangePasswordState> Function(ChangePasswordEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! NewPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is PasswordChanged ||
          event is NewPasswordChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is NewPasswordChanged) {
      yield* _mapNewPasswordChangedChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapPasswordChangeFormSubmittedToState(
        event.email,
        event.password,
        event.newPassword,
      );
    } else if (event is HidePasswordChanged) {
      yield* _mapHidePasswordChangedToState();
    }
  }

  Stream<ChangePasswordState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email) == null,
    );
  }

  Stream<ChangePasswordState> _mapPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password) == null,
    );
  }

  Stream<ChangePasswordState> _mapNewPasswordChangedChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password) == null,
    );
  }

  Stream<ChangePasswordState> _mapHidePasswordChangedToState() async* {
    yield state.update(
      hidePassword: !state.hidePassword,
    );
  }

  Stream<ChangePasswordState> _mapPasswordChangeFormSubmittedToState(
    String email,
    String password,
    String newPassword,
  ) async* {
    yield ChangePasswordState.loading();
    try {
      await _userRepository.reauthenticateWithEmailAndPassword(email, password);
      await _userRepository.changePassword(newPassword);
      yield ChangePasswordState.success();
    } on PlatformException catch (error) {
      if (error.code.contains('ERROR_WRONG_PASSWORD')) {
        yield ChangePasswordState.failure('Wrong Email/Password');
      } else if (error.code.contains('ERROR_INVALID_CREDENTIAL') ||
          error.code.contains('ERROR_OPERATION_NOT_ALLOWED')) {
        yield ChangePasswordState.failure('User does not exist');
      } else if (error.code.contains('ERROR_USER_NOT_FOUND') ||
          error.code.contains('ERROR_USER_DISABLED')) {
        yield ChangePasswordState.failure(
            'User not found or has been disabled');
      } else {
        yield ChangePasswordState.failure('Error, try again later');
      }
    }
  }
}
