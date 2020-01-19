import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RequireReauthenticationEvent extends Equatable {
  RequireReauthenticationEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RequireReauthenticationEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged $email';
}

class PasswordChanged extends RequireReauthenticationEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged password: $password';
}

class HidePasswordChanged extends RequireReauthenticationEvent {
  HidePasswordChanged();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'HidePasswordChanged toggled';
}

class Submitted extends RequireReauthenticationEvent {
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

class ReauthenticateWithGooglePressed extends RequireReauthenticationEvent {}

class ReauthenticateWithEmailAndPasswordPressed
    extends RequireReauthenticationEvent {
  final String email;
  final String password;

  ReauthenticateWithEmailAndPasswordPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'ReauthenticateWithEmailAndPasswordPressed { email: $email, password: $password }';
  }
}
