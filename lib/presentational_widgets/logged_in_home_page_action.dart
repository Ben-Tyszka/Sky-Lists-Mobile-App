import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class LoggedInHomePageAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle),
      onPressed: () {
        BlocProvider.of<NavigatorBloc>(context).add(
          NavigatorPushTo(
            AccountPage.routeName,
          ),
        );
      },
    );
  }
}
