import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class NameChange extends StatelessWidget {
  NameChange({
    @required this.formKey,
    @required this.controller,
    @required this.isLoading,
    @required this.onSaved,
    @required this.submit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isLoading;
  final void Function(String) onSaved;
  final void Function() submit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Your name',
                counterText: '',
                icon: Icon(Icons.person),
              ),
              autocorrect: false,
              maxLength: 50,
              controller: controller,
              validator: validateFullName,
              enabled: !isLoading,
              onSaved: onSaved,
            ),
            SizedBox(
              height: 20.0,
            ),
            !isLoading
                ? OutlineButton.icon(
                    label: Text('Change Name'),
                    icon: Icon(Icons.update),
                    onPressed: submit,
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
