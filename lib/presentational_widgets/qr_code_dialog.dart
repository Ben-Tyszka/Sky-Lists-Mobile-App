import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class QrCodeAlertDialog extends StatelessWidget {
  static final String leftPart = 'rnWSQ';
  static final String centerPart = 'AeGvr';
  static final String rightPart = 'ELoyv';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share via QR code'),
      content: QrImage(
        data: leftPart +
            Provider.of<ListMetadata>(context).id +
            centerPart +
            Provider.of<ListMetadata>(context)
                .docRef
                .parent()
                .parent()
                .documentID +
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
