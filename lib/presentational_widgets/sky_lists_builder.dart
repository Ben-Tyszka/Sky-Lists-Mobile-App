import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/sky_list_tile.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListsBuilder extends StatelessWidget {
  SkyListsBuilder({
    @required this.controller,
    @required this.lists,
    @required this.hasReachedMax,
  });

  final ScrollController controller;
  final List<ListMetadata> lists;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
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
            : SkyListTile(
                list: lists[index],
              );
      },
    );
  }
}
