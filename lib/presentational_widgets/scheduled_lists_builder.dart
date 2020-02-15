import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/scheduled_list_tile.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ScheduledListsBuilder extends StatelessWidget {
  ScheduledListsBuilder({
    @required this.controller,
    @required this.lists,
    @required this.hasReachedMax,
  });

  final ScrollController controller;
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    if (lists.isEmpty)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No Scheduled Lists',
            style: Theme.of(context).primaryTextTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ],
      );
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.only(
        bottom: 14.0,
      ),
      itemCount: hasReachedMax ? lists.length : lists.length + 1,
      itemBuilder: (context, index) {
        return index >= lists.length
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ScheduledListTile(
                list: lists[index],
              );
      },
    );
  }
}
