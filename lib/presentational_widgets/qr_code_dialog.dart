import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sky_lists/models/sky_list_meta.dart';

class QrCodeAlertDialog extends StatelessWidget {
  static final String leftPart = 'r#A~NWS@';
  static final String rightPart = '!VP*Gli(r';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share via QR code'),
      content: QrImage(
        data: leftPart + Provider.of<SkyListMeta>(context).id + rightPart,
        version: QrVersions.auto,
        size: 100.0,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
