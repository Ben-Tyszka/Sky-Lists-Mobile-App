import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/presentational_widgets/create_account.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';
import 'package:sky_lists/database_service.dart';

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class CreateAccountData {
  String email = '';
  String name = '';
  String password = '';
  String confirmPassword = '';
  bool confirmTOS = false;
  bool confirmPP = false;
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _showPassword = false;

  final _data = CreateAccountData();

  _submit() async {
    _formKey.currentState.save();

    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _data.email, password: _data.password);

        final user = await FirebaseAuth.instance.currentUser();
        assert(user != null);

        user.sendEmailVerification();

        final info = UserUpdateInfo();
        info.displayName = _data.name;

        user.updateProfile(info);

        _db.updateUserProfile(
          userId: user.uid,
          email: _data.email,
          name: _data.name,
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
            LoggedInHomePage.routeName, (Route<dynamic> route) => false);
      } catch (error) {
        var message = '';

        if (error.code == 'ERROR_INVALID_EMAIL' ||
            error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          message = 'Account already exists';
        } else if (error.code == 'ERROR_WEAK_PASSWORD') {
          message = 'Password is too weak';
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

  _saveEmail(String value) {
    _data.email = value;
  }

  _saveName(String value) {
    _data.name = value;
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

  String _checkboxValidator(bool value) {
    if (!value) {
      return 'Please accept';
    }
    return null;
  }

  _tosSaved(bool value) {
    _data.confirmTOS = value;
  }

  _ppSaved(bool value) {
    _data.confirmPP = value;
  }

  _seePrivacy(BuildContext context) {
    Navigator.pushNamed(context, PrivacyPolicyPage.routeName);
  }

  _seeTOS(BuildContext context) {
    Navigator.pushNamed(context, TermsOfServicePage.routeName);
  }

  _formFieldStateChange(bool value, FormFieldState<bool> formFieldState) {
    formFieldState.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return CreateAccount(
      checkboxValidator: _checkboxValidator,
      confirmPasswordValidation: _confirmPasswordValidation,
      errorMessage: _errorMessage,
      formFieldStateChange: _formFieldStateChange,
      formKey: _formKey,
      isLoading: _isLoading,
      onTogglePasswordHide: _onTogglePasswordHide,
      ppSaved: _ppSaved,
      saveConfirmPassword: _saveConfirmPassword,
      saveEmail: _saveEmail,
      saveName: _saveName,
      savePassword: _savePassword,
      seePrivacy: _seePrivacy,
      seeTOS: _seeTOS,
      showPassword: _showPassword,
      submit: _submit,
      tosSaved: _tosSaved,
    );
  }
}
