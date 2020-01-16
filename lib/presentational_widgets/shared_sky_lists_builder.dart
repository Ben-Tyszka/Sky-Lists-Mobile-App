import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'package:sky_lists/models/sky_list_shared_meta.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/presentational_widgets/shared_list_info_dialog.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';
import 'package:sky_lists/database_service.dart';

class SharedSkyListsBuilder extends StatelessWidget {
  SharedSkyListsBuilder({
    @required this.controller,
    @required this.data,
    @required this.isLoading,
    @required this.isGettingMoreLists,
  });

  final ScrollController controller;
  final List<SkyListSharedMeta> data;
  final bool isLoading;
  final bool isGettingMoreLists;

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      controller: controller,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final skyList = data[index];
        return StreamBuilder(
          stream: _db.streamListMetaFromSharedMeta(
            list: skyList,
          ),
          builder: (context, AsyncSnapshot<SkyListMeta> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SkyListPage.routeName,
                  arguments: null, //SkyListPageArguments(snapshot.data),
                );
              },
              onLongPress: () {
                Vibration.vibrate();
                showDialog(
                  context: context,
                  builder: (context) => SharedListInfoDialog(
                    list: snapshot.data,
                    sharedList: skyList,
                  ),
                );
              },
              title: Text(snapshot.data.name),
              subtitle: Text(
                timestampToFormmatedDate(snapshot.data.lastModified),
              ),
            );
          },
        );
      },
    );
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : data.length == 0
            ? Center(
                child: Text('No Lists Have Been Shared With You'),
              )
            : listView;
  }
}
