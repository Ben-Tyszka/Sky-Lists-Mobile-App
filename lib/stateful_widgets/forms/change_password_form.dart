import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/presentational_widgets/change_password.dart';

import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class ChangePasswordData {
  String password = '';
  String confirmPassword = '';
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _showPassword = false;

  final _data = ChangePasswordData();

  _submit() async {
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final user = Provider.of<FirebaseUser>(context);
        Timeline.startSync('change_password');
        await user.updatePassword(_data.password);
        Timeline.finishSync();

        Provider.of<FirebaseAnalytics>(context)
            .logEvent(name: 'password_change');

        Navigator.of(context).pushNamedAndRemoveUntil(
            AccountPage.routeName, (Route<dynamic> route) => false);
      } catch (error) {
        var message = '';

        if (error.code == 'ERROR_USER_DISABLED ' ||
            error.code == 'ERROR_USER_NOT_FOUND ') {
          message = 'User error';
        } else if (error.code == 'ERROR_WEAK_PASSWORD') {
          message = 'Password is too weak';
        } else {
          message = 'Something went wrong';

          log(
            'Something went wrong while trying to create a new password',
            name: 'Change Password Error',
            error: jsonEncode(error),
          );

          Provider.of<FirebaseAnalytics>(context).logEvent(
            name: 'change_password_failed',
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

  _onTogglePasswordHide() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  _savePassword(String value) {
    _data.password = value;
  }

  _saveConfirmPassword(String value) {
    _data.confirmPassword = value;
  }

  String _confirmPasswordValidation(String val) {
    if (val != _data.password) {
      return 'Passwords must match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangePassword(
      confirmPasswordValidation: _confirmPasswordValidation,
      errorMessage: _errorMessage,
      formKey: _formKey,
      isLoading: _isLoading,
      onTogglePasswordHide: _onTogglePasswordHide,
      saveConfirmPassword: _saveConfirmPassword,
      savePassword: _savePassword,
      showPassword: _showPassword,
      submit: _submit,
    );
  }
}
