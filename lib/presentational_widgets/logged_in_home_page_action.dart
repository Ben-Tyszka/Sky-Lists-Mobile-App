import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class LoggedInHomePageAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle),
      onPressed: () {
        BlocProvider.of<ListMetadataBloc>(context).close();
        BlocProvider.of<SharedWithMeBloc>(context).close();
        Navigator.pushNamed(context, AccountPage.routeName);
      },
    );
  }
}
