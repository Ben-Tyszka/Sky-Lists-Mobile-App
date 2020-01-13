import 'dart:async';
import 'package:bloc/bloc.dart';
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
          event is! NameChanged &&
          event is! AgreementsChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged ||
          event is PasswordChanged ||
          event is NameChanged ||
          event is AgreementsChanged);
    }).debounceTime(Duration(milliseconds: 300));
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
      yield* _mapFormSubmittedToState(
        event.email,
        event.password,
        event.name,
        event.agreements,
      );
    } else if (event is AgreementsChanged) {
      yield* _mapAgreementsChangedToState(event.agreements);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validateEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: validatePassword(password),
    );
  }

  Stream<RegisterState> _mapNameChangedToState(String password) async* {
    yield state.update(
      isNameValid: validateName(password),
    );
  }

  Stream<RegisterState> _mapAgreementsChangedToState(bool agreements) async* {
    yield state.update(
      isAgreementsValid: agreements,
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
    String name,
    bool agreements,
  ) async* {
    yield RegisterState.loading();
    try {
      if (!agreements) yield RegisterState.failure();

      await _userRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
