import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged | email :$email';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged | password: $password';
}

class NameChanged extends RegisterEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged | name: $name';
}

class AgreementsChanged extends RegisterEvent {
  final bool agreements;

  AgreementsChanged({@required this.agreements});

  @override
  List<Object> get props => [agreements];

  @override
  String toString() => 'AgreementsChanged | agreements: $agreements';
}

class HidePasswordChanged extends RegisterEvent {
  HidePasswordChanged();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'HidePasswordChanged toggled';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  Submitted({
    @required this.email,
    @required this.password,
    @required this.name,
  });

  @override
  List<Object> get props => [email, password, name];

  @override
  String toString() {
    return 'Submitted | email: $email, password: $password, name: $name ';
  }
}
