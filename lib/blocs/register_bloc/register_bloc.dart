import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sky_lists/blocs/register_bloc/bloc.dart';
import 'package:sky_lists/repositories/user_repository.dart';
import 'package:sky_lists/utils/validation.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! NameChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is PasswordChanged ||
          event is NameChanged);
    }).debounceTime(Duration(milliseconds: 200));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is Submitted) {
      yield* _mapRegisterFormSubmittedToState(
        event.email,
        event.password,
        event.name,
      );
    } else if (event is AgreementsChanged) {
      yield* _mapAgreementsChangedToState(event.agreements);
    } else if (event is HidePasswordChanged) {
      yield* _mapHidePasswordChangedToState();
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email) == null,
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password) == null,
    );
  }

  Stream<RegisterState> _mapNameChangedToState(String password) async* {
    yield state.update(
      isNameValid: validateFullName(password) == null,
    );
  }

  Stream<RegisterState> _mapAgreementsChangedToState(bool agreements) async* {
    yield state.update(
      isAgreementsValid: agreements,
    );
  }

  Stream<RegisterState> _mapHidePasswordChangedToState() async* {
    yield state.update(
      hidePassword: !state.hidePassword,
    );
  }

  Stream<RegisterState> _mapRegisterFormSubmittedToState(
    String email,
    String password,
    String name,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      yield RegisterState.success();
    } on PlatformException catch (error) {
      if (error.code.contains('ERROR_WEAK_PASSWORD')) {
        yield RegisterState.failure(
            'Your password is too weak, please change it and try again');
      } else if (error.code.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        yield RegisterState.failure(
            'That email is already registered to an account');
      } else if (error.code.contains('ERROR_INVALID_EMAIL')) {
        yield RegisterState.failure('Invalid email');
      } else {
        log(
          'Register error',
          name: 'Register _mapRegisterFormSubmittedToState',
          error: jsonEncode(error),
        );
        yield RegisterState.failure('Internal error, try again later');
      }
    }
  }
}
