import 'package:flutter/material.dart';
import 'package:sky_lists/utils/validation.dart';

class ShareWith extends StatelessWidget {
  ShareWith({
    @required this.isSubmitting,
    @required this.onFormSubmitted,
    @required this.emailController,
    @required this.isFailure,
    @required this.isSubmitButtonEnabled,
    @required this.failureMessage,
  });

  final TextEditingController emailController;

  final bool isSubmitting;
  final bool isFailure;
  final bool isSubmitButtonEnabled;

  final Function onFormSubmitted;

  final String failureMessage;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Email to share with',
              counterText: "",
              hintText: 'you@example.com',
              icon: Icon(Icons.email),
            ),
            autocorrect: false,
            autovalidate: true,
            enabled: !isSubmitting,
            keyboardType: TextInputType.emailAddress,
            maxLength: 100,
            validator: (val) => val.isEmpty ? null : validateEmail(val),
          ),
          isSubmitting
              ? CircularProgressIndicator()
              : FlatButton.icon(
                  icon: Icon(
                    Icons.send,
                  ),
                  label: Text('Share'),
                  onPressed: onFormSubmitted,
                ),
          if (failureMessage.isNotEmpty && isFailure) ...[
            Text(
              failureMessage,
              style: Theme.of(context).primaryTextTheme.body1.copyWith(
                    color: Theme.of(context).errorColor,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
