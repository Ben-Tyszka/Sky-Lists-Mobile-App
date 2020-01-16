import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final FirebaseUser user;

  Authenticated(this.user);

  @override
  List<Object> get props => [this.user];

  @override
  String toString() => 'Authenticated: ${user.displayName}';
}

class Unauthenticated extends AuthenticationState {}
