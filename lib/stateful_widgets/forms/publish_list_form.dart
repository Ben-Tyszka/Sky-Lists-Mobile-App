import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/blocs/publish_list_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/presentational_widgets/publish_list.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class PublishListForm extends StatefulWidget {
  final ListMetadata list;
  PublishListForm({@required this.list});

  @override
  _PublishListFormState createState() => _PublishListFormState();
}

class _PublishListFormState extends State<PublishListForm> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PublishListBloc _publishBloc;
  TextEditingController _nameController;
  String nameVal;
  String descriptionVal;
  String errorMessage = '';

  bool get isPopulated =>
      _nameController.text.isNotEmpty && _descriptionController.text.isNotEmpty;

  bool isSubmitButtonEnabled(PublishListState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.name);
    _publishBloc = BlocProvider.of<PublishListBloc>(context);
    _nameController.addListener(_onNameChanged);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  void _onNameChanged() {
    if (nameVal == _nameController.text) return;

    setState(() {
      nameVal = _nameController.text;
    });

    _publishBloc.add(
      ListNameChanged(name: _nameController.text),
    );
  }

  void _onDescriptionChanged() {
    if (descriptionVal == _descriptionController.text) return;

    setState(() {
      descriptionVal = _descriptionController.text;
    });

    _publishBloc.add(
      DescriptionChanged(description: _descriptionController.text),
    );
  }

  void _onFormSubmitted() {
    _publishBloc.add(
      Submit(
        name: _nameController.text,
        description: _descriptionController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PublishListBloc, PublishListState>(
      listener: (context, state) {
        if (state.isSuccess || state.isSubmitting) {
          setState(() {
            errorMessage = '';
          });
        }
        if (state.isSuccess) {
          Future.delayed(
            Duration(
              milliseconds: 800,
            ),
            () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPopAllAndPushTo(
                  LoggedInHomePage.routeName,
                ),
              );
            },
          );
        } else if (state.isFailure) {
          _nameController.text = '';
          _descriptionController.text = '';
          setState(() {
            errorMessage = state.failureMessage;
          });
        }
      },
      child: BlocBuilder<PublishListBloc, PublishListState>(
        builder: (context, state) {
          if (state.isSuccess)
            return Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.lightGreen[400],
                      size: 42,
                    ),
                  ),
                  Text(
                    'List Published!',
                    style: Theme.of(context).primaryTextTheme.headline4,
                  ),
                ],
              ),
            );
          return PublishList(
            formKey: _formKey,
            nameController: _nameController,
            isSubmitting: state.isSubmitting,
            descriptionController: _descriptionController,
            onFormSubmitted: _onFormSubmitted,
            isFailure: errorMessage.isNotEmpty,
            isSubmitButtonEnabled: isSubmitButtonEnabled(state),
            failureMessage: errorMessage,
          );
        },
      ),
    );
  }
}
