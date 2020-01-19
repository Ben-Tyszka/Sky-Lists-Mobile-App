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
    @required this.formKey,
  });

  final TextEditingController emailController;

  final bool isSubmitting;
  final bool isFailure;
  final bool isSubmitButtonEnabled;

  final Function onFormSubmitted;

  final String failureMessage;

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 20.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email to share with',
                  counterText: '',
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
              SizedBox(
                height: 8.0,
              ),
              isSubmitting
                  ? CircularProgressIndicator()
                  : OutlineButton.icon(
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
        ),
      ),
    );
  }
}
