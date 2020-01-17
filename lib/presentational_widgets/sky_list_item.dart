import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/stateful_widgets/forms/item_title_form.dart';

import 'package:list_items_repository/list_items_repository.dart';

class SkyListItem extends StatelessWidget {
  SkyListItem({@required this.item});

  final ListItem item;

  @override
  Widget build(BuildContext context) {
    if (item.hidden) return Container();

    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(item.id),
      onDismissed: (direction) {
        Scaffold.of(context).hideCurrentSnackBar();
        BlocProvider.of<ListItemsBloc>(context).add(
          DeleteListItem(
            item,
          ),
        );
      },
      child: ListTile(
        onLongPress: () {},
        leading: Checkbox(
          activeColor: Theme.of(context).accentColor,
          value: item.checked,
          onChanged: (val) {
            BlocProvider.of<ListItemsBloc>(context).add(
              UpdateListItem(
                item.copyWith(
                  checked: val,
                ),
              ),
            );
          },
        ),
        title: ItemTitleForm(
          item: item,
        ),
        trailing: item.quantity > 0
            ? Text(
                '${item.quantity} ${item.descriptor}${item.quantity > 1 ? 's' : ''}')
            : Container(),
      ),
    );
  }
}
