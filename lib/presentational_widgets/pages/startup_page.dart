import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

class StartupPage extends StatelessWidget {
  static final routeName = '/startup';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            Navigator.popAndPushNamed(context, NotLoggedInPage.routeName);
          } else {
            Navigator.popAndPushNamed(context, LoggedInHomePage.routeName);
          }
        }
        return Container(
          child: Center(
            child: Text(
              'Sky Lists',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        );
      },
    );
  }
}
