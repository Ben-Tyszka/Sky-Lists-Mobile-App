import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/change_password_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/change_password.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  ChangePasswordBloc _changePasswordBloc;

  String emailVal;
  String newPasswordVal;
  String passwordVal;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty;

  bool isChangePasswordButtonEnabled(ChangePasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _newPasswordController.addListener(_onNewPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (emailVal == _emailController.text) return;

    setState(() {
      emailVal = _emailController.text;
    });

    _changePasswordBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    if (passwordVal == _passwordController.text) return;

    setState(() {
      passwordVal = _passwordController.text;
    });

    _changePasswordBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onNewPasswordChanged() {
    if (newPasswordVal == _newPasswordController.text) return;

    setState(() {
      newPasswordVal = _newPasswordController.text;
    });

    _changePasswordBloc.add(
      NewPasswordChanged(password: _newPasswordController.text),
    );
  }

  void _onFormSubmitted() {
    _changePasswordBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  void togglePasswordHide() {
    _changePasswordBloc.add(
      HidePasswordChanged(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _passwordController.text = '';
          _newPasswordController.text = '';
          _emailController.text = '';
          Future.delayed(
            Duration(seconds: 2),
          ).then((_) {
            Navigator.of(context).popAndPushNamed(
              AccountPage.routeName,
            );
          });
        } else if (state.isFailure) {
          _passwordController.text = '';
          _newPasswordController.text = '';
          _emailController.text = '';
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          if (state.isSuccess)
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Password Changed Sucessfully!'),
                  CircularProgressIndicator(),
                ],
              ),
            );

          return ChangePassword(
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            isChangePasswordButtonEnabled: isChangePasswordButtonEnabled(state),
            isFailure: state.isFailure,
            passwordController: _passwordController,
            newPasswordController: _newPasswordController,
            hidePassword: state.hidePassword,
            onFormSubmitted: _onFormSubmitted,
            togglePasswordHide: togglePasswordHide,
            failureMessage: state.failureMessage,
          );
        },
      ),
    );
  }
}
