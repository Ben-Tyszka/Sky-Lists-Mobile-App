import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/stateful_widgets/forms/item_title_form.dart';

import 'package:list_items_repository/list_items_repository.dart';
import 'package:sky_lists/stateful_widgets/forms/quantity_dialog_form.dart';

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
            ? FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider<ListItemsBloc>.value(
                      value: BlocProvider.of<ListItemsBloc>(context),
                      child: QuantityDialogForm(
                        item: item,
                      ),
                    ),
                  );
                },
                child: Text(
                    '${item.quantity} ${item.descriptor}${item.quantity > 1 && item.descriptor.isNotEmpty && item.descriptor != 'Tsp' && item.descriptor != 'Tblsp' && item.descriptor != 'ml' && item.descriptor != 'Fl oz' ? 's' : ''}'),
              )
            : IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                ),
                tooltip: 'Tap to set quantity',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider<ListItemsBloc>.value(
                      value: BlocProvider.of<ListItemsBloc>(context),
                      child: QuantityDialogForm(
                        item: item,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
