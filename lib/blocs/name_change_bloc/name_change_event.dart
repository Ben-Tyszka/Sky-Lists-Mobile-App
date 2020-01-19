import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NameChangeEvent extends Equatable {
  NameChangeEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends NameChangeEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged $name';
}

class Submitted extends NameChangeEvent {
  final String name;

  Submitted({
    @required this.name,
  });

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'Submitted | name: $name';
  }
}
