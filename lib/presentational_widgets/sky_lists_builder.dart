import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

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
            : ListTile(
                title: Text(lists[index].name),
                subtitle: Text(
                  timestampToFormmatedDate(lists[index].lastModified),
                ),
              );
      },
    );
  }
}
