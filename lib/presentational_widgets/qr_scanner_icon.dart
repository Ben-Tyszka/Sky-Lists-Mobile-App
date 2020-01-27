import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';

class QrScannerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.camera,
      ),
      onPressed: () {
        BlocProvider.of<NavigatorBloc>(context).add(
          NavigatorPushTo(
            QRScannerPage.routeName,
          ),
        );
      },
    );
  }
}
