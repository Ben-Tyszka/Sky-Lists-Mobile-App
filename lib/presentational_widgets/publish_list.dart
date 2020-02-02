import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class PublishList extends StatelessWidget {
  PublishList({
    @required this.isSubmitting,
    @required this.onFormSubmitted,
    @required this.nameController,
    @required this.descriptionController,
    @required this.isFailure,
    @required this.isSubmitButtonEnabled,
    @required this.failureMessage,
    @required this.formKey,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;

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
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'List Name',
                counterText: '',
                icon: Icon(Icons.title),
              ),
              autocorrect: false,
              autovalidate: true,
              enabled: !isSubmitting,
              maxLength: 100,
              validator: (val) => val.isEmpty ? null : validateListName(val),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: 10,
              decoration: InputDecoration(
                filled: true,
                labelText: 'List Description',
                hintText: 'Please describe your list for others',
                counterText: '',
                icon: Icon(
                  Icons.description,
                ),
              ),
              autocorrect: false,
              autovalidate: true,
              maxLength: 2000,
              enabled: !isSubmitting,
              validator: (val) => val.isEmpty ? null : validateDescription(val),
            ),
            SizedBox(
              height: 8.0,
            ),
            !isSubmitting
                ? OutlineButton.icon(
                    icon: Icon(
                      Icons.send,
                    ),
                    label: Text('Publish'),
                    onPressed: isSubmitButtonEnabled ? onFormSubmitted : null,
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 8.0,
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
          ],
        ),
      ),
    );
  }
}
