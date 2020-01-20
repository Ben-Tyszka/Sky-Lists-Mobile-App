import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';

class LoggedInHomePageLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.camera,
      ),
      onPressed: () {
        BlocProvider.of<ListMetadataBloc>(context).close();
        BlocProvider.of<SharedWithMeBloc>(context).close();
        Navigator.pushNamed(context, QRScannerPage.routeName);
      },
    );
  }
}
