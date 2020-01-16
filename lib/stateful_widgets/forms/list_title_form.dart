import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/list_title.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListTitleForm extends StatefulWidget {
  ListTitleForm({
    @required this.list,
  });

  final ListMetadata list;

  @override
  _ListTitleFormState createState() => _ListTitleFormState();
}

class _ListTitleFormState extends State<ListTitleForm> {
  TextEditingController _titleController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.list.name);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void onChange(String value, BuildContext blocContext) {
    BlocProvider.of<ListMetadataBloc>(blocContext).add(
      UpdateListMetadata(
        widget.list.copyWith(
          name: _titleController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMetadataBloc, ListMetadataState>(
      builder: (_, state) {
        if (state is ListMetadatasLoaded) {
          return ListTitle(
            controller: _titleController,
            onChanged: (String val) {
              onChange(val, _);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
