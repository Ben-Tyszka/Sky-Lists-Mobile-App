import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';

import 'package:list_items_repository/list_items_repository.dart';

class AddFirstItemButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.add),
      label: Text('Tap to create first item'),
      onPressed: () {
        BlocProvider.of<ListItemsBloc>(context).add(AddListItem(ListItem('')));
      },
    );
  }
}
