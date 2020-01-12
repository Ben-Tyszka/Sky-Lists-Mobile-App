import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/database_service.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/new_list_dialog.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class NewListForm extends StatefulWidget {
  @override
  _NewListFormState createState() => _NewListFormState();
}

class _NewListFormState extends State<NewListForm> {
  TextEditingController _controller;
  bool loading;

  @override
  void initState() {
    _controller = TextEditingController(
      text: 'List - ${DateFormat.yMMMd().add_jm().format(DateTime.now())}',
    );
    loading = false;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPressed() async {
    final _db = DatabaseService();
    setState(() {
      loading = true;
    });

    Timeline.startSync('list_create');
    final doc = await _db.createList(
      name: _controller.value.text,
      userId: Provider.of<FirebaseUser>(context, listen: false).uid,
    );
    final snapshot = await doc.get();
    Timeline.finishSync();

    Provider.of<FirebaseAnalytics>(context, listen: false)
        .logEvent(name: 'list_create');

    Navigator.pushNamed(
      context,
      SkyListPage.routeName,
      arguments: SkyListPageArguments(SkyListMeta.fromFirestore(snapshot)),
    );

    setState(() {
      loading = false;
    });
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return NewListDialog(
      controller: _controller,
      loading: loading,
      onCancel: onCancel,
      onPressed: onPressed,
    );
  }
}
