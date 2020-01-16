import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/stateful_widgets/forms/item_title_form.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

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
          UpdateListItem(
            item.copyWith(
              hidden: true,
            ),
          ),
        );
        Scaffold.of(context)
            .showSnackBar(
              SnackBar(
                duration: Duration(),
                content: Text('Item deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    BlocProvider.of<ListItemsBloc>(context).add(
                      UpdateListItem(
                        item.copyWith(
                          hidden: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            .closed
            .then(
          (reason) {
            if (reason != SnackBarClosedReason.action) {
              BlocProvider.of<ListItemsBloc>(context).add(
                DeleteListItem(
                  item,
                ),
              );
            }
          },
        );
      },
      child: CheckboxListTile(
        title: ItemTitleForm(
          item: item,
        ),
        subtitle: Text(
          timestampToFormmatedDate(item.addedAt),
        ),
        onChanged: (val) {
          BlocProvider.of<ListItemsBloc>(context).add(
            UpdateListItem(
              item.copyWith(
                checked: val,
              ),
            ),
          );
        },
        value: item.checked,
      ),
    );
  }
}
