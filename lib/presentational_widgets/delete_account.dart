import 'package:flutter/material.dart';

enum ConfirmDelete { YES, NO }

class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      color: Theme.of(context).errorColor,
      icon: Icon(Icons.delete_forever),
      label: Text('Hold to Delete Account'),
      onPressed: () {},
      onLongPress: () async {
        switch (await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(
              'Confirm Delete Account',
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Text(
                'Caution: All data will be lost.',
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.body2,
              ),
              SizedBox(
                height: 20.0,
              ),
              SimpleDialogOption(
                child: Text('Yes, delete my account'),
                onPressed: () {
                  Navigator.pop(context, ConfirmDelete.YES);
                },
              ),
              SizedBox(
                height: 20.0,
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
          //TODO: Delete account
        }
      },
    );
  }
}
