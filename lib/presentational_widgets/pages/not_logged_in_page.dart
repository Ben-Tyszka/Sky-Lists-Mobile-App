import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/stateful_widgets/forms/login_form.dart';
import 'package:sky_lists/utils/authentication_service.dart';

/// Page user sees when not logged in
class NotLoggedInPage extends StatelessWidget {
  /// Name for page route
  static final String routeName = '/not_logged_in_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sky Lists',
                style: Theme.of(context).textTheme.display2.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
              ),
              Text(
                'simple and connected',
                style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
              ),
              SizedBox(height: 10.0),
              LoginForm(),
              SizedBox(height: 10.0),
              RaisedButton.icon(
                icon: Icon(Icons.email),
                label: Text('Sign up with Email'),
                onPressed: () {
                  // Pushes the CreateAccountPage for user to make account
                  Navigator.pushNamed(context, CreateAccountPage.routeName);
                },
              ),
              Divider(),
              GoogleSignInButton(
                onPressed: () {
                  // Starts google login flow
                  loginToGoogle(key);
                },
                // Sets dark mode
                darkMode: Theme.of(context).brightness == Brightness.dark,
              ),
              FacebookSignInButton(
                onPressed: () {
                  // Starts facebook login flow
                  loginToFacebook(key);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
