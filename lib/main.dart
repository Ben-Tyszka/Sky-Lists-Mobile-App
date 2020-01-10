import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/sky_lists_app.dart';

/// The Entry point for the application
void main() => runApp(
      MultiProvider(
        providers: [
          // The firebase analytics object to be used throughout the app
          Provider<FirebaseAnalytics>(
            create: (_) => FirebaseAnalytics(),
          ),
          // A stream of the current user is provided to all widgets
          StreamProvider<FirebaseUser>(
            create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          ),
        ],

        // The core MaterialApp
        child: SkyListsApp(),
      ),
    );
