import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

/// Page the user sees on app startup, determines if user is logged in and sends them to appropriate page
class StartupPage extends StatefulWidget {
  static final String routeName = '/startup';

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    switcher();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tell analytics that the app is open
    Provider.of<FirebaseAnalytics>(context).logAppOpen();
  }

  ///  Determines if user is logged in or not, and then sends user to appropriate screen
  switcher() async {
    // Future is needed here as value from provider may be null due to the stream still loading, not because user is logged out
    final user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      Navigator.popAndPushNamed(context, NotLoggedInPage.routeName);
    } else {
      Navigator.popAndPushNamed(context, LoggedInHomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sky Lists',
              style: Theme.of(context).textTheme.display1,
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
  }
}
