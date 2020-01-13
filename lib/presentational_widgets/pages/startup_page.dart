import 'package:flutter/material.dart';

/// Page the user sees on app startup
class StartupPage extends StatelessWidget {
  static final String routeName = '/startup';

  @override
  Widget build(BuildContext context) => Scaffold(
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
}
