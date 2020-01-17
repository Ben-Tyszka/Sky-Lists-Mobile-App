import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged $email';
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged password: $password';
}

class HidePasswordChanged extends LoginEvent {
  HidePasswordChanged();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'HidePasswordChanged toggled';
}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithEmailAndPasswordPressed { email: $email, password: $password }';
  }
}
