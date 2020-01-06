import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:sky_lists/stateful_widgets/forms/login_form.dart';
import 'package:sky_lists/utils/authentication_service.dart';

class NotLoggedInPage extends StatelessWidget {
  static final String routeName = '/not_logged_in_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sky Lists',
            ),
            Text(
              'simple, connected lists',
            ),
            LoginForm(),
            SignInButtonBuilder(
              backgroundColor: Theme.of(context).buttonColor,
              icon: Icons.email,
              text: 'Sign up with Email',
              onPressed: () {},
            ),
            Divider(),
            SignInButton(
              Buttons.Google,
              text: "Login with Google",
              onPressed: loginToGoogle,
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Login with Facebook",
              onPressed: loginToFacebook,
            ),
          ],
        ),
      ),
    );
  }
}
