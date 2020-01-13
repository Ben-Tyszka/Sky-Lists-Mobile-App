import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';
import 'package:sky_lists/utils/validation.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({
    @required this.isLoading,
    @required this.showPassword,
    @required this.submit,
    @required this.emailController,
    @required this.passwordController,
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.togglePasswordHide,
    @required this.loginFailed,
    @required this.nameController,
    @required this.isNameValid,
    @required this.isRegisterButtonEnabled,
    @required this.agreementsValue,
    @required this.onAgreementsChange,
  });

  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final bool agreementsValue;

  final bool isLoading;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool showPassword;
  final bool loginFailed;
  final bool isNameValid;
  final bool isRegisterButtonEnabled;

  final Function togglePasswordHide;
  final Function submit;
  final Function(bool) onAgreementsChange;

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
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              maxLength: 100,
              validator: (_) {
                return !isEmailValid ? 'Invalid Email' : null;
              },
            ),
            SizedBox(
              height: 16.0,
            ),
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
              enabled: !isLoading,
              maxLength: 100,
              validator: (_) {
                return !isNameValid ? 'Invalid Name' : null;
              },
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
              obscureText: !showPassword,
              autovalidate: true,
              maxLength: 50,
              enabled: !isLoading,
              keyboardType: showPassword
                  ? TextInputType.visiblePassword
                  : TextInputType.text,
              validator: (_) {
                return !isPasswordValid ? 'Invalid Password' : null;
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Checkbox(
                      value: agreementsValue,
                      onChanged: onAgreementsChange,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'I accept the ',
                        style: Theme.of(context).textTheme.body1,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, TermsOfServicePage.routeName);
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
                                Navigator.pushNamed(
                                    context, PrivacyPolicyPage.routeName);
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
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            if (loginFailed) ...[
              Text(
                'Could not create account',
                style: Theme.of(context).primaryTextTheme.body1.copyWith(
                      color: Theme.of(context).errorColor,
                    ),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
            !isLoading
                ? OutlineButton(
                    onPressed: isRegisterButtonEnabled ? submit : null,
                    child: Text('Create Account'),
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
