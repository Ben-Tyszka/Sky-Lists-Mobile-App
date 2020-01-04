import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page_arguments.dart';
import 'package:sky_lists/stateful_widgets/forms/share_with_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_shared_with_pagination.dart';
import 'package:sky_lists/database_service.dart';

class SkyListShareWithPage extends StatelessWidget {
  static final String routeName = '/list_share';
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return StreamProvider<SkyListMeta>(
      create: (_) => _db.streamListMeta(
        list: args.list,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Share List'),
        ),
        body: Column(
          children: <Widget>[
            SkyListSharedWithPagination(),
            Divider(),
            ShareWithForm(),
          ],
        ),
      ),
    );
  }
}
