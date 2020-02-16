import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static final String routeName = '/privacy_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'We are always looking for user feedback and/or suggestions!',
              style: Theme.of(context).primaryTextTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Please use the form below',
              style: Theme.of(context).primaryTextTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
