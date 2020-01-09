import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/list_title.dart';
import 'package:sky_lists/database_service.dart';

class ListTitleForm extends StatefulWidget {
  @override
  _ListTitleFormState createState() => _ListTitleFormState();
}

class _ListTitleFormState extends State<ListTitleForm> {
  TextEditingController _nameController;
  SkyListMeta list;
  final _db = DatabaseService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = Provider.of<SkyListMeta>(context);
    _nameController = TextEditingController(text: list.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void submit(String value) {
    _db.setListTitle(list: list, name: value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTitle(
      controller: _nameController,
      onChanged: submit,
    );
  }
}
