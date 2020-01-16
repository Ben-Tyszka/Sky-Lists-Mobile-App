import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/add_first_item_button.dart';
import 'package:sky_lists/presentational_widgets/sky_list_item.dart';

import 'package:list_items_repository/list_items_repository.dart';

class SkyListBuilder extends StatelessWidget {
  SkyListBuilder({
    @required this.controller,
    @required this.items,
    @required this.hasReachedMax,
  });

  final ScrollController controller;
  final List<ListItem> items;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    if (items.length == 0)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'List is empty',
              style: Theme.of(context).primaryTextTheme.display1,
              textAlign: TextAlign.center,
            ),
            AddFirstItemButton(),
          ],
        ),
      );
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(
        bottom: 14.0,
      ),
      itemCount: hasReachedMax ? items.length : items.length + 1,
      itemBuilder: (context, index) {
        return index >= items.length
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SkyListItem(
                item: items[index],
              );
      },
    );
  }
}
