import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/sky_lists_app.dart';

/// The Entry point for the application
void main() => runApp(
      // MultiProvider is available if needed in the future
      MultiProvider(
        providers: [
          // A stream of the current user is provided to all widgets
          StreamProvider<FirebaseUser>(
            create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          ),
        ],

        // The core MaterialApp
        child: SkyListsApp(),
      ),
    );
