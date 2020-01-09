import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/stateful_widgets/forms/login_form.dart';
import 'package:sky_lists/utils/authentication_service.dart';

class NotLoggedInPage extends StatelessWidget {
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
                  Navigator.pushNamed(context, CreateAccountPage.routeName);
                },
              ),
              Divider(),
              SignInButton(
                Theme.of(context).brightness == Brightness.light
                    ? Buttons.Google
                    : Buttons.GoogleDark,
                text: "Login with Google",
                onPressed: () {
                  loginToGoogle(key);
                },
              ),
              SignInButton(
                Buttons.Facebook,
                text: "Login with Facebook",
                onPressed: () {
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
