import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({
    @required this.isSubmitting,
    @required this.hidePassword,
    @required this.onFormSubmitted,
    @required this.emailController,
    @required this.passwordController,
    @required this.togglePasswordHide,
    @required this.isFailure,
    @required this.newPasswordController,
    @required this.isChangePasswordButtonEnabled,
    @required this.failureMessage,
  });

  final TextEditingController emailController;
  final TextEditingController newPasswordController;
  final TextEditingController passwordController;

  final bool isSubmitting;
  final bool hidePassword;
  final bool isFailure;
  final bool isChangePasswordButtonEnabled;

  final String failureMessage;

  final Function togglePasswordHide;
  final Function onFormSubmitted;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Email',
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
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
                counterText: "",
                icon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
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
              height: 16.0,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'New Password',
                counterText: "",
                icon: Icon(
                  Icons.lock_outline,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
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
              validator: (val) => val.isEmpty
                  ? null
                  : val == passwordController.text
                      ? 'New and old passwords must not match'
                      : validatePassword(val),
            ),
            SizedBox(
              height: 16.0,
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
                ? OutlineButton(
                    onPressed:
                        isChangePasswordButtonEnabled ? onFormSubmitted : null,
                    child: Text('Change Password'),
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
