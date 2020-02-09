import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';
import 'package:sky_lists/utils/validation.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({
    @required this.isSubmitting,
    @required this.hidePassword,
    @required this.onFormSubmitted,
    @required this.emailController,
    @required this.passwordController,
    @required this.togglePasswordHide,
    @required this.isFailure,
    @required this.nameController,
    @required this.isRegisterButtonEnabled,
    @required this.agreementsValue,
    @required this.onAgreementsChange,
    @required this.failureMessage,
  });

  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;

  final bool agreementsValue;
  final bool isSubmitting;
  final bool hidePassword;
  final bool isFailure;
  final bool isRegisterButtonEnabled;

  final String failureMessage;

  final Function togglePasswordHide;
  final Function onFormSubmitted;
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
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Name',
                counterText: '',
                icon: Icon(Icons.person),
              ),
              autocorrect: false,
              autovalidate: true,
              enabled: !isSubmitting,
              maxLength: 100,
              validator: (val) => val.isEmpty ? null : validateFullName(val),
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
                        style: Theme.of(context).textTheme.bodyText2,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                BlocProvider.of<NavigatorBloc>(context).add(
                                  NavigatorPushTo(
                                    TermsOfServicePage.routeName,
                                  ),
                                );
                              },
                            text: 'Terms of Service',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                          ),
                          TextSpan(
                            text: ' and\n',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                BlocProvider.of<NavigatorBloc>(context).add(
                                  NavigatorPushTo(
                                    PrivacyPolicyPage.routeName,
                                  ),
                                );
                              },
                            text: 'Privacy Policy',
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
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
            if (isFailure) ...[
              Text(
                failureMessage,
                style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                      color: Theme.of(context).errorColor,
                    ),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
            !isSubmitting
                ? OutlineButton(
                    onPressed: isRegisterButtonEnabled ? onFormSubmitted : null,
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
