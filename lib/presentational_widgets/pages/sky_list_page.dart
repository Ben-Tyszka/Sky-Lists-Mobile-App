import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page_arguments.dart';
import 'package:sky_lists/stateful_widgets/forms/list_title_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_pagination.dart';
import 'package:sky_lists/database_service.dart';

class SkyListPage extends StatelessWidget {
  static final String routeName = '/list';

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
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, LoggedInHomePage.routeName);
            },
          ),
          title: ListTitleForm(),
        ),
        body: SkyListPagination(),
      ),
    );
  }
}
