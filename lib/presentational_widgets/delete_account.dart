import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:sky_lists/blocs/authentication_bloc/authentication_event.dart';

import 'package:sky_lists/blocs/require_reauthentication/bloc.dart';

class DeleteAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequireReauthenticationBloc,
        RequireReauthenticationState>(
      builder: (context, state) {
        return RaisedButton.icon(
          color: Theme.of(context).errorColor,
          icon: Icon(Icons.delete_forever),
          label: Text('Hold to Delete Account'),
          onPressed: state.isSuccess ? () {} : null,
          onLongPress: state.isSuccess
              ? () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    DeleteUsersAccount(),
                  );
                }
              : null,
        );
      },
    );
  }
}
