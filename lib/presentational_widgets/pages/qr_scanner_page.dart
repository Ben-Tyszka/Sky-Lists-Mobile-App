import 'package:flutter/material.dart';

import 'package:sky_lists/stateful_widgets/qr_scanner.dart';

class QRScannerPage extends StatelessWidget {
  static final String routeName = '/qr_scanner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan List QR Code'),
      ),
      body: QRScanner(),
    );
  }
}
