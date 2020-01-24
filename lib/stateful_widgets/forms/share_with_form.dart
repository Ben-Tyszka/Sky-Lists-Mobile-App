import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/share_with.dart';

class ShareWithForm extends StatefulWidget {
  @override
  _ShareWithFormState createState() => _ShareWithFormState();
}

class _ShareWithFormState extends State<ShareWithForm> {
  final TextEditingController _emailController = TextEditingController();

  ShareListBloc _shareBloc;

  String emailVal;
  String passwordVal;
  String errorMessage = '';

  final _formKey = GlobalKey<FormState>();

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isShareButtonEnabled(ShareListState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _shareBloc = BlocProvider.of<ShareListBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
  }

  void _onEmailChanged() {
    if (emailVal == _emailController.text) return;

    setState(() {
      emailVal = _emailController.text;
    });
    _shareBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _shareBloc.add(
      Submitted(
        email: _emailController.text,
        list: (BlocProvider.of<ListMetadataBloc>(context).state as ListLoaded)
            .list,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareListBloc, ShareListState>(
      listener: (context, state) {
        if (state.isFailure) {
          setState(() {
            errorMessage = state.failureMessage;
          });
        } else if (state.isSubmitting || state.isSuccess) {
          setState(() {
            errorMessage = '';
          });
        }
      },
      child: BlocBuilder<ShareListBloc, ShareListState>(
        builder: (context, state) {
          return ShareWith(
            formKey: _formKey,
            emailController: _emailController,
            isSubmitting: state.isSubmitting,
            onFormSubmitted: _onFormSubmitted,
            isFailure: errorMessage.isNotEmpty,
            isSubmitButtonEnabled: isShareButtonEnabled(state),
            failureMessage: errorMessage,
          );
        },
      ),
    );
  }
}
