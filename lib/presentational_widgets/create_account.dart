import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:sky_lists/utils/validation.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({
    @required this.formKey,
    @required this.isLoading,
    @required this.errorMessage,
    @required this.showPassword,
    @required this.saveEmail,
    @required this.saveName,
    @required this.savePassword,
    @required this.saveConfirmPassword,
    @required this.onTogglePasswordHide,
    @required this.confirmPasswordValidation,
    @required this.checkboxValidator,
    @required this.aggrementsSaved,
    @required this.seePrivacy,
    @required this.seeTOS,
    @required this.formFieldStateChange,
    @required this.submit,
  });

  final GlobalKey<FormState> formKey;

  final bool isLoading;
  final String errorMessage;
  final bool showPassword;

  final Function(String) saveEmail;
  final Function(String) saveName;
  final Function(String) savePassword;
  final Function(String) saveConfirmPassword;
  final Function onTogglePasswordHide;
  final String Function(String) confirmPasswordValidation;
  final String Function(bool) checkboxValidator;
  final Function(bool) aggrementsSaved;
  final Function(BuildContext) seePrivacy;
  final Function(BuildContext) seeTOS;
  final Function(bool, FormFieldState<bool>) formFieldStateChange;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Form(
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
                  labelText: 'Email',
                  counterText: "",
                  hintText: 'you@example.com',
                  icon: Icon(Icons.email),
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                maxLength: 50,
                validator: validateEmail,
                enabled: !isLoading,
                onSaved: saveEmail,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  counterText: "",
                  icon: Icon(Icons.person),
                ),
                autocorrect: false,
                maxLength: 50,
                validator: validateFullName,
                enabled: !isLoading,
                onSaved: saveName,
              ),
              SizedBox(
                height: 10.0,
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
                height: 10.0,
              ),
              FormField(
                initialValue: false,
                onSaved: aggrementsSaved,
                validator: checkboxValidator,
                builder: (FormFieldState<bool> formFieldState) {
                  return Row(
                    children: <Widget>[
                      Checkbox(
                        value: formFieldState.value,
                        onChanged: (value) {
                          formFieldStateChange(value, formFieldState);
                        },
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'I accept the ',
                          style: Theme.of(context).textTheme.body1,
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  seeTOS(context);
                                },
                              text: 'Terms of Service',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                            ),
                            TextSpan(
                              text: ' and\nthe ',
                              style: Theme.of(context).textTheme.body1,
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  seePrivacy(context);
                                },
                              text: 'Privacy Policy',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                            ),
                          ],
                        ),
                        softWrap: true,
                      ),
                    ],
                  );
                },
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
                      child: Text('Create Account'),
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
