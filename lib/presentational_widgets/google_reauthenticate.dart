import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/require_reauthentication/bloc.dart';

class GoogleReauthenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequireReauthenticationBloc,
        RequireReauthenticationState>(
      builder: (context, state) {
        if (state.isSuccess) {
          return Container();
        }
        return GoogleSignInButton(
          borderRadius: 18,
          onPressed: () {
            BlocProvider.of<RequireReauthenticationBloc>(context).add(
              ReauthenticateWithGooglePressed(),
            );
          },
          // Sets dark mode
          darkMode: Theme.of(context).brightness == Brightness.dark,
        );
      },
    );
  }
}
