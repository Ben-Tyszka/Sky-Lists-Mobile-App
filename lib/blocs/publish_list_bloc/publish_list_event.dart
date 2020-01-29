import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class PublishListEvent extends Equatable {
  PublishListEvent();

  @override
  List<Object> get props => [];
}

class ListNameChanged extends PublishListEvent {
  final String name;

  ListNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'ListNameChanged: $name';
}

class DescriptionChanged extends PublishListEvent {
  final String description;

  DescriptionChanged({@required this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() => 'DescriptionChanged description: $description';
}

class Submit extends PublishListEvent {
  final String name;
  final String description;

  Submit({
    @required this.name,
    @required this.description,
  });

  @override
  List<Object> get props => [name, description];

  @override
  String toString() {
    return 'Submit name: $name, description: $description';
  }
}
