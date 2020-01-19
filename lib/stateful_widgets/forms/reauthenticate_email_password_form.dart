import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/require_reauthentication/bloc.dart';

import 'package:sky_lists/presentational_widgets/reauth_email_password.dart';

class ReauthenticateEmailAndPasswordForm extends StatefulWidget {
  @override
  _ReauthenticateEmailAndPasswordFormState createState() =>
      _ReauthenticateEmailAndPasswordFormState();
}

class _ReauthenticateEmailAndPasswordFormState
    extends State<ReauthenticateEmailAndPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RequireReauthenticationBloc _loginBloc;

  String emailVal;
  String passwordVal;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isReauthenticateButtonEnabled(RequireReauthenticationState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<RequireReauthenticationBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _onEmailChanged() {
    if (emailVal == _emailController.text) return;

    setState(() {
      emailVal = _emailController.text;
    });
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    if (passwordVal == _passwordController.text) return;

    setState(() {
      passwordVal = _passwordController.text;
    });

    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      ReauthenticateWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void togglePasswordHide() {
    _loginBloc.add(
      HidePasswordChanged(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequireReauthenticationBloc,
        RequireReauthenticationState>(
      listener: (context, state) {
        if (state.isFailure) {
          _emailController.text = '';
          _passwordController.text = '';
        }
      },
      child: BlocBuilder<RequireReauthenticationBloc,
          RequireReauthenticationState>(
        builder: (context, state) {
          if (state.isSuccess) {
            return Container();
          }
          return ReauthEmailPassword(
            formKey: _formKey,
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            passwordController: _passwordController,
            onFormSubmitted: _onFormSubmitted,
            togglePasswordHide: togglePasswordHide,
            isFailure: state.isFailure,
            isReauthenticateButtonEnabled: isReauthenticateButtonEnabled(state),
            failureMessage: state.failureMessage,
            hidePassword: state.hidePassword,
          );
        },
      ),
    );
  }
}
