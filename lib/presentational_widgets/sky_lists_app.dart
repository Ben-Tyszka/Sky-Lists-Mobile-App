import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/change_password_page.dart';
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
import 'package:sky_lists/utils/sky_lists_app_theme.dart';

/// Widget that encapsulates the entire application
class SkyListsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Lists',
      // Theme is set, for both light and dark modes, auto switches depending on user system settings
      theme: brightTheme,
      routes: {
        // All pages are registered
        StartupPage.routeName: (context) =>
            BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: StartupPage(),
            ),
        NotLoggedInPage.routeName: (context) =>
            BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: NotLoggedInPage(),
            ),
        LoggedInHomePage.routeName: (context) =>
            BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: LoggedInHomePage(),
            ),
        SkyListPage.routeName: (context) =>
            BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: SkyListPage(),
            ),
        SkyListShareWithPage.routeName: (context) => SkyListShareWithPage(),
        CreateAccountPage.routeName: (context) =>
            BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: CreateAccountPage(),
            ),
        TermsOfServicePage.routeName: (context) => TermsOfServicePage(),
        PrivacyPolicyPage.routeName: (context) => PrivacyPolicyPage(),
        SendPasswordResetPage.routeName: (context) => SendPasswordResetPage(),
        QRScannerPage.routeName: (context) => QRScannerPage(),
        AccountPage.routeName: (context) => AccountPage(),
        ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
      },
      initialRoute: StartupPage.routeName,
      //Track route transitions
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: Provider.of<FirebaseAnalytics>(context),
        ),
      ],
    );
  }
}
