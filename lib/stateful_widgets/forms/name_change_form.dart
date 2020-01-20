import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/authentication_bloc/authentication_state.dart';
import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';

import 'package:sky_lists/blocs/name_change_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/name_change.dart';

class NameChangeForm extends StatefulWidget {
  @override
  _NameChangeFormState createState() => _NameChangeFormState();
}

class _NameChangeFormState extends State<NameChangeForm> {
  final _formKey = GlobalKey<FormState>();

  NameChangeBloc _nameBloc;

  TextEditingController _nameController;

  String nameVal;

  bool get isPopulated => _nameController.text.isNotEmpty;

  bool isSubmitButtonEnabled(NameChangeState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _nameBloc = BlocProvider.of<NameChangeBloc>(context);
    _nameController = TextEditingController(
      text:
          (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
              .user
              .displayName,
    );
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (nameVal == _nameController.text) return;

    setState(() {
      nameVal = _nameController.text;
    });
    _nameBloc.add(
      NameChanged(name: _nameController.text),
    );
  }

  void _onFormSubmitted() {
    _nameBloc.add(
      Submitted(name: _nameController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NameChangeBloc, NameChangeState>(
      builder: (context, state) {
        return NameChange(
          formKey: _formKey,
          nameController: _nameController,
          isSubmitting: state.isSubmitting,
          onFormSubmitted: _onFormSubmitted,
          isFailure: state.isFailure,
          isSubmitButtonEnabled: isSubmitButtonEnabled(state),
          failureMessage: state.failureMessage,
        );
      },
    );
  }
}
