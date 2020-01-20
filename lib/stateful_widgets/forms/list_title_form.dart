import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
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
  String previousValue = '';

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.list.name);

    _titleController.addListener(onChange);
    BlocProvider.of<ListMetadataBloc>(context).listen((state) {
      if (state is ListLoaded) {
        setState(() {
          previousValue = state.list.name;
          _titleController.value =
              _titleController.value.copyWith(text: state.list.name);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    BlocProvider.of<ListMetadataBloc>(context)?.close();
    BlocProvider.of<ListItemsBloc>(context)?.close();
    super.dispose();
  }

  void onChange() {
    if (previousValue == _titleController.text) return;
    BlocProvider.of<ListMetadataBloc>(context).add(
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
        if (state is ListLoaded) {
          return ListTitle(
            controller: _titleController,
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
