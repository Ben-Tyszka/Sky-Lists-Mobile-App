import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/utils/validation.dart';

class SendPasswordResetForm extends StatefulWidget {
  @override
  _SendPasswordResetFormState createState() => _SendPasswordResetFormState();
}

class ResetData {
  String email = '';
}

class _SendPasswordResetFormState extends State<SendPasswordResetForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _errorMessage = '';

  final _data = ResetData();

  _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      _formKey.currentState.save();

      try {
        Timeline.startSync('send_password_reset_email');
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _data.email);
        Timeline.finishSync();

        log(
          'Password reset email was sent',
          name: 'SendPasswordResetForm',
        );
      } catch (error) {
        var message = '';

        if (error.code == 'ERROR_INVALID_EMAIL') {
          message = 'Bad email';
        } else if (error.code == 'ERROR_USER_NOT_FOUND') {
          message = 'This account is either disabled or does not exist';
        } else {
          message = 'Something went wrong';

          log(
            'Something went wrong while trying to reset the password',
            name: 'SendPasswordResetForm _submit',
            error: jsonEncode(error),
          );

          Provider.of<FirebaseAnalytics>(context).logEvent(
            name: 'send_password_reset_failed',
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
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
      _formKey.currentState.reset();

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset email sent. Please check your inbox',
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
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
                validator: (val) {
                  if (!validateEmail(val)) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                enabled: !_isLoading,
                onSaved: (String value) {
                  _data.email = value;
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              _errorMessage != null
                  ? Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 5.0,
              ),
              !_isLoading
                  ? OutlineButton.icon(
                      label: Text('Send'),
                      onPressed: _submit,
                      icon: Icon(Icons.send),
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
