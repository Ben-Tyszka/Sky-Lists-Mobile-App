import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import './bloc.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(
    NavigatorEvent event,
  ) async* {
    if (event is NavigatorPop) {
      navigatorKey.currentState.pop();
    } else if (event is NavigatorReplace) {
      navigatorKey.currentState.pushReplacementNamed(event.routeName);
    } else if (event is NavigatorPushTo) {
      event.arguments == null
          ? navigatorKey.currentState.pushNamed(
              event.routeName,
            )
          : navigatorKey.currentState.pushNamed(
              event.routeName,
              arguments: event.arguments,
            );
    } else if (event is NavigatorPopAndPushTo) {
      navigatorKey.currentState.pushNamed(event.routeName);
    } else if (event is NavigatorPopAllAndPushTo) {
      navigatorKey.currentState.pushNamedAndRemoveUntil(
        event.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }
}
