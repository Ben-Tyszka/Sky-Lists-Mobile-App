import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class NameChange extends StatelessWidget {
  NameChange({
    @required this.isSubmitting,
    @required this.onFormSubmitted,
    @required this.nameController,
    @required this.isFailure,
    @required this.isSubmitButtonEnabled,
    @required this.failureMessage,
    @required this.formKey,
  });

  final TextEditingController nameController;

  final bool isSubmitting;
  final bool isFailure;
  final bool isSubmitButtonEnabled;

  final Function onFormSubmitted;

  final String failureMessage;

  final GlobalKey<FormState> formKey;

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
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Name',
                counterText: "",
                icon: Icon(Icons.person),
              ),
              autocorrect: false,
              autovalidate: true,
              enabled: !isSubmitting,
              maxLength: 100,
              validator: (val) => val.isEmpty ? null : validateFullName(val),
            ),
            SizedBox(
              height: 20.0,
            ),
            if (isFailure) ...[
              Text(
                failureMessage,
                style: Theme.of(context).primaryTextTheme.body1.copyWith(
                      color: Theme.of(context).errorColor,
                    ),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
            !isSubmitting
                ? OutlineButton.icon(
                    label: Text('Change Name'),
                    icon: Icon(Icons.update),
                    onPressed: isSubmitButtonEnabled ? onFormSubmitted : null,
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
