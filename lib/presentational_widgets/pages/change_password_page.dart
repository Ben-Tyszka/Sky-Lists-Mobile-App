import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/stateful_widgets/change_password_flow.dart';

class ChangePasswordPage extends StatelessWidget {
  static final routeName = '/change_password';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ChangePasswordFlow(),
    );
  }
}
