import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/login_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/login.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginBloc _loginBloc;

  String emailVal;
  String passwordVal;
  String errorMessage = '';

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
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
      LoginWithEmailAndPasswordPressed(
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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess || state.isSubmitting) {
          setState(() {
            errorMessage = '';
          });
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        } else if (state.isFailure) {
          _emailController.text = '';
          _passwordController.text = '';
          setState(() {
            errorMessage = state.failureMessage;
          });
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Login(
            formKey: _formKey,
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            passwordController: _passwordController,
            onFormSubmitted: _onFormSubmitted,
            togglePasswordHide: togglePasswordHide,
            isFailure: errorMessage.isNotEmpty,
            isLoginButtonEnabled: isLoginButtonEnabled(state),
            failureMessage: errorMessage,
            hidePassword: state.hidePassword,
          );
        },
      ),
    );
  }
}
