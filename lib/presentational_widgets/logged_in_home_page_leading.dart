import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';

class LoggedInHomePageLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.camera,
      ),
      onPressed: () {
        Navigator.pushNamed(context, QRScannerPage.routeName);
      },
    );
  }
}
