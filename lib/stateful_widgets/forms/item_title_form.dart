import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_items_repository/list_items_repository.dart';
import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/item_title.dart';

class ItemTitleForm extends StatefulWidget {
  ItemTitleForm({
    @required this.item,
  });

  final ListItem item;

  @override
  _ItemTitleFormState createState() => _ItemTitleFormState();
}

class _ItemTitleFormState extends State<ItemTitleForm> {
  TextEditingController _titleController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.item.name);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void onChange(String value) {
    BlocProvider.of<ListItemsBloc>(context).add(
      UpdateListItem(
        widget.item.copyWith(
          name: _titleController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ItemTitle(
      controller: _titleController,
      onChanged: onChange,
      checked: widget.item.checked,
    );
  }
}
