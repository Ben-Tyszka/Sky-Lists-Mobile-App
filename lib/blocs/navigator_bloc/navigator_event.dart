import 'package:equatable/equatable.dart';

abstract class NavigatorEvent extends Equatable {
  @override
  List<Object> get props => [];

  NavigatorEvent();
}

class NavigatorPop extends NavigatorEvent {}

class NavigatorReplace extends NavigatorEvent {
  final String routeName;
  NavigatorReplace(this.routeName);

  @override
  List<Object> get props => [routeName];
}

class NavigatorPushTo extends NavigatorEvent {
  final String routeName;
  NavigatorPushTo(this.routeName);

  @override
  List<Object> get props => [routeName];
}

class NavigatorPopAndPushTo extends NavigatorEvent {
  final String routeName;
  NavigatorPopAndPushTo(this.routeName);

  @override
  List<Object> get props => [routeName];
}

class NavigatorPopAllAndPushTo extends NavigatorEvent {
  final String routeName;
  NavigatorPopAllAndPushTo(this.routeName);

  @override
  List<Object> get props => [routeName];
}
