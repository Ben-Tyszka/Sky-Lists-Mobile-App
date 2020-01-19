import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      icon: Icon(Icons.exit_to_app),
      label: Text('Sign Out'),
      onPressed: () {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      },
    );
  }
}
