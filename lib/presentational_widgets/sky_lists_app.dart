import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';

class SkyListsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;

    return MaterialApp(
      title: 'Sky Lists',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: loggedIn ? LoggedInHomePage.routeName : '/logged_out_home',
      routes: {
        LoggedInHomePage.routeName: (context) => LoggedInHomePage(),
        SkyListPage.routeName: (context) => SkyListPage(),
      },
    );
  }
}
