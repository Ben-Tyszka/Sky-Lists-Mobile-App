import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/database_service.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

enum ConfirmDelete { YES, NO }

final _db = DatabaseService();

class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      color: Colors.red,
      icon: Icon(Icons.delete_forever),
      label: Text('Delete Account'),
      onPressed: () {},
      onLongPress: () async {
        switch (await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text('Confirm Delete Account'),
            children: <Widget>[
              Text(
                'Deleting your account is permanent, all your data will be lost.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SimpleDialogOption(
                child: Text('Yes, delete my account'),
                onPressed: () {
                  Navigator.pop(context, ConfirmDelete.YES);
                },
              ),
              SimpleDialogOption(
                child: Text('No, do not delete my account'),
                onPressed: () {
                  Navigator.pop(context, ConfirmDelete.YES);
                },
              ),
            ],
          ),
        )) {
          case ConfirmDelete.YES:
            final user = Provider.of<FirebaseUser>(context);
            await _db.deleteUser(userId: user.uid);
            await user.delete();
            Navigator.of(context).pushNamedAndRemoveUntil(
              NotLoggedInPage.routeName,
              (Route<dynamic> route) => false,
            );
        }
      },
    );
  }
}
