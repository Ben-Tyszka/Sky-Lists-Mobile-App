import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/presentational_widgets/delete_account.dart';
import 'package:sky_lists/presentational_widgets/pages/change_password_page.dart';
import 'package:sky_lists/presentational_widgets/sign_out_button.dart';
import 'package:sky_lists/stateful_widgets/about_app.dart';
import 'package:sky_lists/stateful_widgets/forms/name_change_form.dart';

class AccountPage extends StatelessWidget {
  static final routeName = '/account_page';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(context: context, builder: (context) => AboutApp());
            },
          ),
        ],
      ),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                if (user.isEmailVerified) ...[
                  NameChangeForm(),
                  FlatButton.icon(
                    icon: Icon(Icons.lock_outline),
                    label: Text('Change Password'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ChangePasswordPage.routeName);
                    },
                  ),
                ] else ...[
                  Text(
                      'Your email address is not verified. Check your inbox and follow the instructions to verify your account.'),
                  FlatButton(
                    child: Text('Resend email'),
                    onPressed: () {
                      user.sendEmailVerification();
                    },
                  ),
                ],
                Divider(),
                SignOutButton(),
                Divider(),
                DeleteAccount(),
              ],
            ),
    );
  }
}
