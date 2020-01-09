import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      icon: Icon(Icons.exit_to_app),
      label: Text('Sign out'),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          NotLoggedInPage.routeName,
          (Route<dynamic> route) => false,
        );
        FirebaseAuth.instance.signOut();
        try {
          GoogleSignIn().signOut();
          FacebookLogin().logOut();
        } catch (e) {}
      },
    );
  }
}
