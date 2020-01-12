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
                SizedBox(
                  height: 20,
                ),
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
                  Card(
                    elevation: 2,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Your email is not verified, some account features have been restricted',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.title,
                              ),
                            ],
                          ),
                        ),
                        OutlineButton.icon(
                          label: Text('Resend Email'),
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: () {
                            user.sendEmailVerification();
                          },
                        ),
                      ],
                    ),
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
