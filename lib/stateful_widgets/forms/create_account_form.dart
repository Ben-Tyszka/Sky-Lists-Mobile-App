import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/register_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/create_account.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/privacy_policy_page.dart';
import 'package:sky_lists/presentational_widgets/pages/terms_of_service_page.dart';
import 'package:sky_lists/database_service.dart';

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _showPassword = false;

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _nameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onNameChanged() {
    _registerBloc.add(
      NameChanged(name: _nameController.text),
    );
  }

  void _onAgreementsChanged(bool agree) {
    _registerBloc.add(
      AgreementsChanged(agreements: agree),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        agreements: null,
        name: _nameController.text,
      ),
    );
  }

  _onTogglePasswordHide() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return CreateAccount(
            emailController: _emailController,
            isEmailValid: state.isEmailValid,
            isLoading: state.isSubmitting,
            isNameValid: state.isNameValid,
            isPasswordValid: state.isPasswordValid,
            isRegisterButtonEnabled: isRegisterButtonEnabled(state),
            loginFailed: state.isFailure,
            nameController: _nameController,
            passwordController: _passwordController,
            showPassword: _showPassword,
            submit: _onFormSubmitted,
            togglePasswordHide: _onTogglePasswordHide,
            agreementsValue: state.isAgreementsValid,
            onAgreementsChange: _onAgreementsChanged,
          );
        },
      ),
    );
  }
}
