import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/item_title.dart';
import 'package:sky_lists/database_service.dart';

class ItemTitleForm extends StatefulWidget {
  ItemTitleForm({
    @required this.item,
  });

  final SkyListItem item;

  @override
  _ItemTitleFormState createState() => _ItemTitleFormState();
}

class _ItemTitleFormState extends State<ItemTitleForm> {
  TextEditingController _nameController;
  final _db = DatabaseService();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.item.name);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void onChange(String value) {
    _db.setItemTitle(item: widget.item, title: value);
  }

  void onSubmit(String value) {
    final list = Provider.of<SkyListMeta>(context);
    _db.addListItem(list: list);
  }

  @override
  Widget build(BuildContext context) {
    return ItemTitle(
      controller: _nameController,
      onChanged: onChange,
      onSubmit: onSubmit,
    );
  }
}
