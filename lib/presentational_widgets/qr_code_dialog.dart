import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/database_service.dart';

class QrCodeAlertDialog extends StatelessWidget {
  static final String leftPart = 'rnWSQ';
  static final String centerPart = 'AeGvr';
  static final String rightPart = 'ELoyv';

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share via QR code'),
      content: QrImage(
        data: leftPart +
            Provider.of<SkyListMeta>(context).id +
            centerPart +
            _db.getOwnerFromListMeta(
              list: Provider.of<SkyListMeta>(context),
            ) +
            rightPart,
        version: QrVersions.auto,
        size: 32.0,
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
