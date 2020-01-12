import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_share_with_page.dart';
import 'package:sky_lists/stateful_widgets/forms/list_title_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_pagination.dart';
import 'package:sky_lists/database_service.dart';

class SkyListPage extends StatelessWidget {
  static final String routeName = '/list';

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {
              final isEmailVerified =
                  Provider.of<FirebaseUser>(context).isEmailVerified;
              if (isEmailVerified) {
                Navigator.pushNamed(context, SkyListShareWithPage.routeName,
                    arguments: args);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Please Verify Email'),
                    content: Text(
                        'You must verify your email before you can share a list.'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Provider.of<FirebaseUser>(context)
                              .sendEmailVerification();
                        },
                        child: Text('Resend Email'),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, LoggedInHomePage.routeName);
          },
        ),
        title: StreamProvider<SkyListMeta>(
          create: (_) => _db.streamListMeta(
            list: args.list,
          ),
          child: ListTitleForm(),
        ),
      ),
      body: SkyListPagination(
        list: args.list,
      ),
    );
  }
}
