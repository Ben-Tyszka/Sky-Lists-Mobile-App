import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayName;

  Authenticated(this.displayName);

  @override
  List<Object> get props => [this.displayName];

  @override
  String toString() => 'Authenticated: $displayName';
}

class Unauthenticated extends AuthenticationState {}
