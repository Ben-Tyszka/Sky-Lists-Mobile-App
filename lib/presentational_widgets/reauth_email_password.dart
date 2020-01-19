import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class ReauthEmailPassword extends StatelessWidget {
  ReauthEmailPassword({
    @required this.isSubmitting,
    @required this.hidePassword,
    @required this.onFormSubmitted,
    @required this.emailController,
    @required this.passwordController,
    @required this.togglePasswordHide,
    @required this.isFailure,
    @required this.isReauthenticateButtonEnabled,
    @required this.failureMessage,
    @required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool isSubmitting;
  final bool hidePassword;
  final bool isFailure;
  final bool isReauthenticateButtonEnabled;

  final Function togglePasswordHide;
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
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Email',
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
              height: 16.0,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
                counterText: '',
                icon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: togglePasswordHide,
                ),
              ),
              autocorrect: false,
              obscureText: hidePassword,
              autovalidate: true,
              maxLength: 50,
              enabled: !isSubmitting,
              keyboardType: TextInputType.visiblePassword,
              validator: (val) => val.isEmpty ? null : validatePassword(val),
            ),
            SizedBox(
              height: 8.0,
            ),
            !isSubmitting
                ? OutlineButton.icon(
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                    label: Text('Submit'),
                    onPressed:
                        isReauthenticateButtonEnabled ? onFormSubmitted : null,
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
