import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/presentational_widgets/login.dart';
import 'package:sky_lists/stateful_widgets/forms/change_password_form.dart';
import 'package:sky_lists/utils/authentication_service.dart';

class VerifyData {
  String email = '';
  String password = '';
}

class ChangePasswordFlow extends StatefulWidget {
  @override
  _ChangePasswordFlowState createState() => _ChangePasswordFlowState();
}

class _ChangePasswordFlowState extends State<ChangePasswordFlow> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _showPassword = false;
  bool _verified = false;

  final _data = VerifyData();

  void _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      _formKey.currentState.save();

      _reauthorizeUser(EmailAuthProvider.getCredential(
          email: _data.email, password: _data.password));

      _formKey.currentState.reset();
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

  void _reauthorizeUser(AuthCredential authCredential) async {
    try {
      final user = Provider.of<FirebaseUser>(context);

      Timeline.startSync('reauth');

      await user.reauthenticateWithCredential(authCredential);
      Timeline.finishSync();

      Provider.of<FirebaseAnalytics>(context).logEvent(
        name: 'reauth',
        parameters: {
          'method': authCredential.providerId,
        },
      );

      setState(() {
        _verified = true;
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      var message = '';
      if (error.code == 'ERROR_USER_NOT_FOUND' ||
          error.code == 'ERROR_USER_DISABLED') {
        message = 'This account is either disabled or does not exist';
      } else if (error.code == 'ERROR_WRONG_PASSWORD') {
        message = 'Wrong password';
      } else {
        message = 'Something went wrong';
        log(
          'Something went wrong while trying to reatuh the user',
          name: 'Login Error',
          error: jsonEncode(error),
        );

        Provider.of<FirebaseAnalytics>(context).logEvent(
          name: 'reauth_with_email_and_password_failed',
          parameters: {
            'code': error.code,
            'message': error.message,
            'details': error.details,
          },
        );
      }
      setState(() {
        _errorMessage = message;
      });
    }
  }

  void _google() async {
    setState(() {
      _isLoading = true;
    });
    // Starts google login flow
    final authResult = await loginToGoogleAuthCredential();
    if (authResult == null) return;
    _reauthorizeUser(authResult);
  }

  _facebook() async {
// Starts facebook login flow
    setState(() {
      _isLoading = true;
    });
    final authResult = await loginToFacebookAuthCredential(context);
    if (authResult == null) return;
    _reauthorizeUser(authResult);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          _verified ? 'Step 2: Enter new password' : 'Step 1: Verify identity',
        ),
        if (_isLoading) ...[
          CircularProgressIndicator(),
        ],
        if (!_verified) ...[
          Login(
            errorMessage: _errorMessage,
            formKey: _formKey,
            isLoading: false,
            onEmailSaved: _emailSaved,
            onHide: _hidePassword,
            onPasswordSaved: _passwordSaved,
            showPassword: _showPassword,
            submit: _submit,
          ),
          GoogleSignInButton(
            onPressed: _google,
            // Sets dark mode
            darkMode: Theme.of(context).brightness == Brightness.dark,
          ),
          FacebookSignInButton(
            onPressed: _facebook,
          ),
        ] else ...[
          ChangePasswordForm(),
        ],
      ],
    );
  }
}
