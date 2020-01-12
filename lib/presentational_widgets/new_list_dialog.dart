import 'package:flutter/material.dart';

class NewListDialog extends StatelessWidget {
  NewListDialog({
    @required this.controller,
    @required this.onPressed,
    @required this.onCancel,
    @required this.loading,
  });

  final TextEditingController controller;
  final Function onPressed;
  final Function onCancel;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      FlatButton.icon(
        icon: Icon(Icons.cancel),
        label: Text('Cancel'),
        onPressed: onCancel,
      ),
      FlatButton.icon(
        onPressed: onPressed,
        label: Text('Create'),
        icon: Icon(Icons.create),
      ),
    ];
    final loadingActions = <Widget>[
      CircularProgressIndicator(),
    ];

    return AlertDialog(
      title: Text(
        'New List',
        style: Theme.of(context).primaryTextTheme.title,
        textAlign: TextAlign.center,
      ),
      content: TextField(
        controller: controller,
      ),
      actions: loading ? loadingActions : actions,
    );
  }
}
