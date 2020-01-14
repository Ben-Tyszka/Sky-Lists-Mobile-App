import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

/// Page the user sees on app startup
class StartupPage extends StatelessWidget {
  static final String routeName = '/startup';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      condition: (previousState, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, LoggedInHomePage.routeName);
        } else if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, NotLoggedInPage.routeName);
        }
        return true;
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sky Lists',
                  style: Theme.of(context).primaryTextTheme.display1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
