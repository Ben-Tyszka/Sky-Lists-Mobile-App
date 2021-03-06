import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/stateful_widgets/sky_lists_app.dart';
import 'package:sky_lists/repositories/user_repository.dart';
import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/utils/app_bloc_delagate.dart';

/// The Entry point for the application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = AppBlocDelegate();

  final UserRepository userRepository = UserRepository();
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) =>
          AuthenticationBloc(userRepository)..add(AppStarted()),
      child: MultiProvider(
        providers: [
          // The firebase analytics object to be used throughout the app
          Provider<FirebaseAnalytics>(
            create: (_) => firebaseAnalytics,
          ),
          Provider<UserRepository>(
            create: (_) => userRepository,
          ),
          Provider<FirebaseMessaging>(
            create: (_) => firebaseMessaging,
          ),
        ],
        child: SkyListsApp(),
      ),
    ),
  );
}
