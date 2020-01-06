import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sky_lists/presentational_widgets/pages/send_password_reset_page.dart';

import 'package:sky_lists/utils/validation.dart';

class Login extends StatelessWidget {
  Login({
    @required this.formKey,
    @required this.isLoading,
    @required this.errorMessage,
    @required this.showPassword,
    @required this.onEmailSaved,
    @required this.onHide,
    @required this.onPasswordSaved,
    @required this.submit,
  });

  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final String errorMessage;
  final bool showPassword;

  final Function onEmailSaved;
  final Function onPasswordSaved;
  final Function onHide;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  counterText: "",
                  hintText: 'you@example.com',
                  icon: Icon(Icons.email),
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                maxLength: 100,
                validator: validateEmail,
                enabled: !isLoading,
                onSaved: onEmailSaved,
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
                    onPressed: onHide,
                  ),
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                obscureText: !showPassword,
                maxLength: 50,
                validator: validatePassword,
                enabled: !isLoading,
                onSaved: onPasswordSaved,
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              !isLoading
                  ? FlatButton.icon(
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                      label: Text('Login'),
                      onPressed: submit,
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 10.0,
              ),
              Text.rich(
                TextSpan(
                  text: 'Forgot your password? ',
                  style: Theme.of(context).textTheme.button,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                              context, SendPasswordResetPage.routeName);
                        },
                      text: 'Reset it here',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
