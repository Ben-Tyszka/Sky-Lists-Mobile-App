import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/stateful_widgets/forms/item_title_form.dart';
import 'package:sky_lists/database_service.dart';
import 'package:sky_lists/stateful_widgets/forms/quantity_dialog_form.dart';

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
              Provider.of<FirebaseAnalytics>(context, listen: false)
                  .logEvent(name: 'item_delete');
            }
          });
        },
        child: ListTile(
          onLongPress: () {
            Provider.of<FirebaseAnalytics>(context, listen: false)
                .logEvent(name: 'item_quantity_change', parameters: {
              'descriptor': item.descriptor,
              'quantity': item.quantity,
            });
            showDialog(
              context: context,
              builder: (context) => QuantityDialogForm(
                item: item,
              ),
            );
          },
          title: ItemTitleForm(item: item),
          leading: Checkbox(
            value: item.checked,
            onChanged: (val) {
              Vibration.vibrate();
              Provider.of<FirebaseAnalytics>(context, listen: false)
                  .logEvent(name: 'item_check');
              _db.setItemChecked(item: item, status: val);
            },
          ),
          trailing: item.quantity > 0
              ? Text('${item.quantity} ${item.descriptor}')
              : null,
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
        Provider.of<FirebaseAnalytics>(context, listen: false)
            .logEvent(name: 'item_add');
        log('Item added', name: 'SkyListBuilder addItemTile');
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
            shrinkWrap: true,
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
