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
      FlatButton(
        child: Text('Cancel'),
        onPressed: onCancel,
      ),
      MaterialButton(
        onPressed: onPressed,
        child: Text('Create'),
      ),
    ];
    final loadingActions = <Widget>[
      CircularProgressIndicator(),
    ];

    return AlertDialog(
      title: Text('New List'),
      content: TextField(
        controller: controller,
      ),
      actions: loading ? loadingActions : actions,
    );
  }
}
