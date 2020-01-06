import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/login.dart';

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
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _data.email, password: _data.password);
        if (user != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      } catch (error) {
        var message = '';

        if (error.code == 'ERROR_INVALID_EMAIL' ||
            error.code == 'ERROR_WRONG_PASSWORD') {
          message = 'Wrong email/password';
        } else if (error.code == 'ERROR_USER_NOT_FOUND' ||
            error.code == 'ERROR_USER_DISABLED') {
          message = 'This account is either disabled or does not exist';
        } else {
          message = 'Something went wrong';
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
