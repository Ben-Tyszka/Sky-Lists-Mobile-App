import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sky_lists/presentational_widgets/pages/send_password_reset_page.dart';

class Login extends StatelessWidget {
  Login({
    @required this.isLoading,
    @required this.showPassword,
    @required this.submit,
    @required this.emailController,
    @required this.passwordController,
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.togglePasswordHide,
    @required this.loginFailed,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool isLoading;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool showPassword;
  final bool loginFailed;

  final Function togglePasswordHide;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Form(
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
                height: 8.0,
              ),
              !isLoading
                  ? OutlineButton.icon(
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                      label: Text('Login'),
                      onPressed: submit,
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: 8.0,
              ),
              if (loginFailed) ...[
                Text(
                  'Could not login',
                  style: Theme.of(context).primaryTextTheme.body1.copyWith(
                        color: Theme.of(context).errorColor,
                      ),
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
              Text.rich(
                TextSpan(
                  text: 'Forgot your password? ',
                  style: Theme.of(context).primaryTextTheme.body1,
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, SendPasswordResetPage.routeName);
                              },
                      text: 'Reset it here',
                      style:
                          Theme.of(context).primaryTextTheme.caption.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
