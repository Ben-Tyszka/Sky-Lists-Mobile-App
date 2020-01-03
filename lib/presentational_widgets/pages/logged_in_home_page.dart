import 'package:flutter/material.dart';

import 'package:sky_lists/stateful_widgets/sky_lists_pagination.dart';

class LoggedInHomePage extends StatelessWidget {
  static final String routeName = '/logged_in_home_init';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sky Lists'),
      ),
      body: Container(
        child: SkyListsPagination(),
      ),
    );
  }
}
