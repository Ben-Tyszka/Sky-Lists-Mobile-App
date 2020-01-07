import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';
import 'package:sky_lists/presentational_widgets/pages/send_password_reset_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_share_with_page.dart';
import 'package:sky_lists/presentational_widgets/pages/startup_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class SkyListsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Lists',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      initialRoute: StartupPage.routeName,
      routes: {
        StartupPage.routeName: (context) => StartupPage(),
        NotLoggedInPage.routeName: (context) => NotLoggedInPage(),
        LoggedInHomePage.routeName: (context) => LoggedInHomePage(),
        SkyListPage.routeName: (context) => SkyListPage(),
        SkyListShareWithPage.routeName: (context) => SkyListShareWithPage(),
        CreateAccountPage.routeName: (context) => CreateAccountPage(),
        TermsOfServicePage.routeName: (context) => TermsOfServicePage(),
        PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),
        SendPasswordResetPage.routeName: (context) => SendPasswordResetPage(),
        QRScannerPage.routeName: (context) => QRScannerPage(),
        AccountPage.routeName: (context) => AccountPage(),
      },
    );
  }
}
