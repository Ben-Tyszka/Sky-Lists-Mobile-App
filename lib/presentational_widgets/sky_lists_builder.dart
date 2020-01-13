import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/utils/sky_lists_app_theme.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';
import 'package:sky_lists/database_service.dart';

class SkyListsBuilder extends StatelessWidget {
  SkyListsBuilder({
    @required this.controller,
    @required this.data,
    @required this.isLoading,
    @required this.isGettingMoreLists,
  });

  final ScrollController controller;
  final List<SkyListMeta> data;
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
        return skyList.archived || skyList.hidden
            ? Container()
            : Dismissible(
                direction: DismissDirection.startToEnd,
                key: Key(skyList.id),
                onDismissed: (direction) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  _db.setListHidden(list: skyList, status: true);
                  Scaffold.of(context)
                      .showSnackBar(
                        SnackBar(
                          content: Text('List deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              _db.setListArchive(list: skyList, status: false);
                            },
                          ),
                        ),
                      )
                      .closed
                      .then((reason) {
                    if (reason != SnackBarClosedReason.action) {
                      Provider.of<FirebaseAnalytics>(
                        context,
                        listen: false,
                      ).logEvent(name: 'list_delete');
                      _db.deleteList(list: skyList);
                    }
                  });
                },
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SkyListPage.routeName,
                      arguments: SkyListPageArguments(skyList),
                    );
                  },
                  title: Text(
                    skyList.name,
                    style: Theme.of(context).primaryTextTheme.title,
                  ),
                  subtitle: Text(
                    timestampToFormmatedDate(skyList.lastModified),
                    style: Theme.of(context).primaryTextTheme.subtitle.copyWith(
                          color: secondaryTextColor,
                        ),
                  ),
                ),
              );
      },
    );
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : data.length == 0
            ? Center(
                child: Text('Tap below to add a list'),
              )
            : listView;
  }
}
