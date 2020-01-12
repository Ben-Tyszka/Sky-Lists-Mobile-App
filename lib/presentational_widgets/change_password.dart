import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({
    @required this.formKey,
    @required this.isLoading,
    @required this.errorMessage,
    @required this.showPassword,
    @required this.savePassword,
    @required this.saveConfirmPassword,
    @required this.onTogglePasswordHide,
    @required this.confirmPasswordValidation,
    @required this.submit,
  });

  final GlobalKey<FormState> formKey;

  final bool isLoading;
  final String errorMessage;
  final bool showPassword;

  final Function(String) savePassword;
  final Function(String) saveConfirmPassword;
  final Function onTogglePasswordHide;
  final String Function(String) confirmPasswordValidation;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
              decoration: InputDecoration(
                labelText: 'Password',
                counterText: "",
                icon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                  ),
                  onPressed: onTogglePasswordHide,
                ),
              ),
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: !showPassword,
              maxLength: 50,
              validator: validatePassword,
              enabled: !isLoading,
              onSaved: savePassword,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                counterText: "",
                icon: Icon(
                  Icons.lock,
                ),
              ),
              autocorrect: false,
              keyboardType: TextInputType.text,
              obscureText: !showPassword,
              maxLength: 50,
              validator: confirmPasswordValidation,
              enabled: !isLoading,
              onSaved: saveConfirmPassword,
            ),
            SizedBox(
              height: 5.0,
            ),
            errorMessage != ''
                ? Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : Container(),
            SizedBox(
              height: 5.0,
            ),
            !isLoading
                ? OutlineButton(
                    onPressed: submit,
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
