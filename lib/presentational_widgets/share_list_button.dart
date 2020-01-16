import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareListButton extends StatelessWidget {
  ShareListButton({@required this.user}) : assert(user != null);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share,
      ),
      onPressed: () {
        if (user.isEmailVerified) {
          // Navigator.pushNamed(context, SkyListShareWithPage.routeName,
          //     arguments: args);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Please Verify Email'),
              content: Text(
                  'You must verify your email before you can share a list.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    user.sendEmailVerification();
                  },
                  child: Text('Resend Email'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
