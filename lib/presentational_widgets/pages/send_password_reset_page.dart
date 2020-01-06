import 'package:flutter/material.dart';

import 'package:sky_lists/stateful_widgets/forms/send_password_reset_form.dart';

class SendPasswordResetPage extends StatelessWidget {
  static final String routeName = '/password_reset';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Password Reset Email'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: SendPasswordResetForm(),
        ),
      ),
    );
  }
}
