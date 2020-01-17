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
  ListItem previousValue;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.item.name);
    _titleController.addListener(onChange);
    BlocProvider.of<ListItemsBloc>(context).listen((state) {
      if (state is ListItemsLoaded) {
        //Note: Not very efficient, esp. when dealing with large lists, needs to be worked on
        try {
          final selectedItem =
              state.items.where((_) => _.id == widget.item.id)?.first;
          if (!mounted || selectedItem == null) return;
          setState(() {
            previousValue = selectedItem;
            _titleController.value =
                _titleController.value.copyWith(text: selectedItem.name);
          });
        } catch (_) {}
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _titleController?.dispose();
    super.dispose();
  }

  void onChange() {
    if (previousValue.name == _titleController.text) return;
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
      checked: widget.item.checked,
    );
  }
}
