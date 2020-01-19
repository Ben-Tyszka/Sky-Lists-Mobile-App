import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ChangePasswordEvent extends Equatable {
  ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ChangePasswordEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged | email :$email';
}

class PasswordChanged extends ChangePasswordEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged | password: $password';
}

class NewPasswordChanged extends ChangePasswordEvent {
  final String password;

  NewPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'NewPasswordChanged | password: $password';
}

class HidePasswordChanged extends ChangePasswordEvent {
  HidePasswordChanged();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'HidePasswordChanged toggled';
}

class Submitted extends ChangePasswordEvent {
  final String email;
  final String password;
  final String newPassword;

  Submitted({
    @required this.email,
    @required this.password,
    @required this.newPassword,
  });

  @override
  List<Object> get props => [email, password, newPassword];

  @override
  String toString() {
    return 'Submitted | email: $email, password: $password, name: $newPassword';
  }
}
