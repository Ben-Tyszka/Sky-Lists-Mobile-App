import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/register_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/create_account.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  RegisterBloc _registerBloc;

  String emailVal;
  String nameVal;
  String passwordVal;

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
    if (emailVal == _emailController.text) return;

    setState(() {
      emailVal = _emailController.text;
    });

    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    if (passwordVal == _passwordController.text) return;

    setState(() {
      passwordVal = _passwordController.text;
    });

    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onNameChanged() {
    if (nameVal == _nameController.text) return;

    setState(() {
      nameVal = _nameController.text;
    });

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
        name: _nameController.text,
      ),
    );
  }

  void togglePasswordHide() {
    _registerBloc.add(
      HidePasswordChanged(),
    );
  }

  _routeToHomePage() async {
    final FirebaseMessaging _fcm = Provider.of<FirebaseMessaging>(context);

    String fcmToken = await _fcm.getToken();
    final user = await FirebaseAuth.instance.currentUser();

    if (fcmToken != null) {
      final tokens = Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoggedInHomePage.routeName,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          _routeToHomePage();
        } else if (state.isFailure) {
          _passwordController.text = '';
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return CreateAccount(
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            isRegisterButtonEnabled: isRegisterButtonEnabled(state),
            isFailure: state.isFailure,
            nameController: _nameController,
            passwordController: _passwordController,
            hidePassword: state.hidePassword,
            onFormSubmitted: _onFormSubmitted,
            togglePasswordHide: togglePasswordHide,
            agreementsValue: state.isAgreementsValid,
            onAgreementsChange: _onAgreementsChanged,
            failureMessage: state.failureMessage,
          );
        },
      ),
    );
  }
}
