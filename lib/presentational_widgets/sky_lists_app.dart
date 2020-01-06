import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_share_with_page.dart';
import 'package:sky_lists/presentational_widgets/pages/startup_page.dart';

class SkyListsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Lists',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: StartupPage.routeName,
      routes: {
        StartupPage.routeName: (context) => StartupPage(),
        NotLoggedInPage.routeName: (context) => NotLoggedInPage(),
        LoggedInHomePage.routeName: (context) => LoggedInHomePage(),
        SkyListPage.routeName: (context) => SkyListPage(),
        SkyListShareWithPage.routeName: (context) => SkyListShareWithPage(),
        CreateAccountPage.routeName: (context) => CreateAccountPage(),
      },
    );
  }
}
