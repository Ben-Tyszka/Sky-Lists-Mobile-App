import 'dart:developer';

import 'package:bloc/bloc.dart';

class AppBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    log(event, name: 'AppBlocDelegate onEvent');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    log(error, name: 'AppBlocDelegate onError', error: stacktrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
    log(transition.toString(), name: 'AppBlocDelegate onTransition');
  }
}
