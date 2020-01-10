import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/presentational_widgets/login.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class LoginData {
  String email = '';
  String password = '';
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _showPassword = false;

  final _data = LoginData();

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      _formKey.currentState.save();

      try {
        Timeline.startSync('email_and_password_login');
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _data.email, password: _data.password);
        Timeline.finishSync();

        if (user != null) {
          Provider.of<FirebaseAnalytics>(context).logLogin(
            loginMethod: 'email_and_password',
          );

          Navigator.of(context).pushNamedAndRemoveUntil(
              LoggedInHomePage.routeName, (Route<dynamic> route) => false);
        }
      } on PlatformException catch (error) {
        var message = '';
        if (error.code == 'ERROR_INVALID_EMAIL' ||
            error.code == 'ERROR_WRONG_PASSWORD') {
          message = 'Wrong email or password';
        } else if (error.code == 'ERROR_USER_NOT_FOUND' ||
            error.code == 'ERROR_USER_DISABLED') {
          message = 'This account is either disabled or does not exist';
        } else {
          message = 'Something went wrong';
          log(
            'Something went wrong while trying to log the user in',
            name: 'Login Error',
            error: jsonEncode(error),
          );

          Provider.of<FirebaseAnalytics>(context).logEvent(
            name: 'login_with_email_and_password_failed',
            parameters: {
              'code': error.code,
              'message': error.message,
              'details': error.details,
            },
          );
        }

        _formKey.currentState.reset();

        setState(() {
          _isLoading = false;
          _errorMessage = message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
    }
  }

  void _passwordSaved(String value) {
    _data.password = value;
  }

  void _emailSaved(String value) {
    _data.email = value;
  }

  void _hidePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Login(
      errorMessage: _errorMessage,
      formKey: _formKey,
      isLoading: _isLoading,
      onEmailSaved: _emailSaved,
      onHide: _hidePassword,
      onPasswordSaved: _passwordSaved,
      showPassword: _showPassword,
      submit: _submit,
    );
  }
}
