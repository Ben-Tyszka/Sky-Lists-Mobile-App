import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/sky_lists_app.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>(
            create: (_) => FirebaseAuth.instance.onAuthStateChanged,
          ),
        ],
        child: SkyListsApp(),
      ),
    );
