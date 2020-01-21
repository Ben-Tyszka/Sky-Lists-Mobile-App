import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class SkyListPageLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoggedInHomePage.routeName,
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
