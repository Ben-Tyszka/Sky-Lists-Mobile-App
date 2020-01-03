import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/stateful_widgets/forms/item_title_form.dart';
import 'package:sky_lists/database_service.dart';
import 'package:vibration/vibration.dart';

class SkyListBuilder extends StatelessWidget {
  SkyListBuilder({
    @required this.controller,
    @required this.data,
    @required this.isLoading,
    @required this.isGettingMoreLists,
  });

  final ScrollController controller;
  final List<SkyListItem> data;
  final bool isLoading;
  final bool isGettingMoreLists;

  final _db = DatabaseService();

  Widget itemTile(BuildContext context, SkyListItem item) => Dismissible(
        direction: DismissDirection.startToEnd,
        key: Key(item.id),
        onDismissed: (direction) {
          Scaffold.of(context).hideCurrentSnackBar();
          _db.setItemHidden(item: item, status: true);
          Scaffold.of(context)
              .showSnackBar(
                SnackBar(
                  duration: Duration(),
                  content: Text('Item deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      _db.setItemHidden(item: item, status: false);
                    },
                  ),
                ),
              )
              .closed
              .then((reason) {
            if (reason != SnackBarClosedReason.action) {
              _db.deleteItem(item: item);
            }
          });
        },
        child: ListTile(
          title: ItemTitleForm(item: item),
          leading: Checkbox(
            value: item.checked,
            onChanged: (val) {
              Vibration.vibrate();
              _db.setItemChecked(item: item, status: val);
            },
          ),
        ),
      );

  Widget addItemTile(BuildContext context) {
    final list = Provider.of<SkyListMeta>(context);
    return ListTile(
      leading: Icon(
        Icons.add,
      ),
      title: Text('Add Item'),
      onTap: () {
        _db.addListItem(list: list);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: controller,
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index != data.length) {
                final item = data[index];
                return item.hidden ? Container() : itemTile(context, item);
              } else {
                return addItemTile(context);
              }
            },
          );
  }
}
