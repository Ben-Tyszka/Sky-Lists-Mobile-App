import 'package:flutter/material.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page_arguments.dart';
import 'package:sky_lists/stateful_widgets/forms/new_list_form.dart';
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
                  title: Text(skyList.name),
                  subtitle: Text(
                    timestampToFormmatedDate(skyList.lastModified),
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
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.add,
                  ),
                  label: Text('Add List'),
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) => NewListForm());
                  },
                ),
              )
            : listView;
  }
}
