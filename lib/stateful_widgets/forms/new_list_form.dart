import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/new_list_dialog.dart';

class NewListForm extends StatefulWidget {
  @override
  _NewListFormState createState() => _NewListFormState();
}

class _NewListFormState extends State<NewListForm> {
  TextEditingController _controller;
  bool loading;

  @override
  void initState() {
    _controller = TextEditingController(
      text: 'List - ${DateFormat.yMMMd().add_jm().format(DateTime.now())}',
    );
    loading = false;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPressed() async {
    setState(() {
      loading = true;
    });
    final list = ListMetadata(_controller.text);
    BlocProvider.of<ListMetadataBloc>(context).add(AddList(list, context));
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return NewListDialog(
      controller: _controller,
      loading: loading,
      onCancel: onCancel,
      onPressed: onPressed,
    );
  }
}
