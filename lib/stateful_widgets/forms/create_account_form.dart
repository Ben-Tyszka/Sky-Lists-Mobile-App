import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/register_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/create_account.dart';

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
  String errorMessage;

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSuccess || state.isSubmitting) {
          setState(() {
            errorMessage = '';
          });
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        } else if (state.isFailure) {
          _passwordController.text = '';
          setState(() {
            errorMessage = state.failureMessage;
          });
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return CreateAccount(
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            isRegisterButtonEnabled: isRegisterButtonEnabled(state),
            isFailure: errorMessage.isNotEmpty,
            nameController: _nameController,
            passwordController: _passwordController,
            hidePassword: state.hidePassword,
            onFormSubmitted: _onFormSubmitted,
            togglePasswordHide: togglePasswordHide,
            agreementsValue: state.isAgreementsValid,
            onAgreementsChange: _onAgreementsChanged,
            failureMessage: errorMessage,
          );
        },
      ),
    );
  }
}
