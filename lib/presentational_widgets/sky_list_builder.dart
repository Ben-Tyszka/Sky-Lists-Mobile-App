import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';

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
      itemCount: hasReachedMax ? items.length + 1 : items.length + 2,
      itemBuilder: (context, index) {
        if (index < items.length)
          return SkyListItem(
            item: items[index],
          );
        if (index == items.length)
          return ListTile(
            leading: Icon(Icons.add),
            onTap: () {
              BlocProvider.of<ListItemsBloc>(context).add(
                AddListItem(
                  ListItem(''),
                ),
              );
            },
            title: Text('Add Item'),
          );
        return Container(
          padding: EdgeInsets.only(
            top: 20.0,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
