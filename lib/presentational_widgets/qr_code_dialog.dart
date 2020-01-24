import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class QrCodeAlertDialog extends StatelessWidget {
  QrCodeAlertDialog({@required this.list});

  final ListMetadata list;

  static final String leftPart = 'rnWSQ';
  static final String centerPart = 'AeGvr';
  static final String rightPart = 'ELoyv';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Share List via QR Code',
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: QrImage(
          data: leftPart +
              list.id +
              centerPart +
              list.docRef.parent().parent().documentID +
              rightPart,
          version: QrVersions.auto,
        ),
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
