import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/common_shared_with.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/presentational_widgets/qr_code_dialog.dart';
import 'package:sky_lists/stateful_widgets/forms/share_with_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_shared_with_pagination.dart';
import 'package:sky_lists/utils/custom_icons.dart';
import 'package:sky_lists/database_service.dart';

class SkyListShareWithPage extends StatelessWidget {
  static final String routeName = '/list_share';
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return StreamProvider<SkyListMeta>(
      create: (_) => _db.streamListMeta(
        list: null, //args.list,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: Icon(CustomIcons.qrcode),
              onPressed: () {
                Provider.of<FirebaseAnalytics>(context)
                    .logEvent(name: 'open_qr_code_dialog');
                showDialog(
                  context: context,
                  builder: (context) => QrCodeAlertDialog(),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          title: Text('Share List'),
        ),
        body: Column(
          children: <Widget>[
            SkyListSharedWithPagination(),
            Divider(),
            CommonSharedWith(),
            ShareWithForm(),
          ],
        ),
      ),
    );
  }
}
