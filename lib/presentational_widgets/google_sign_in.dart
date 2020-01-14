import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';

import 'package:sky_lists/blocs/login_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class GoogleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoggedInHomePage.routeName,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return GoogleSignInButton(
            borderRadius: 18,
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).add(
                LoginWithGooglePressed(),
              );
            },
            // Sets dark mode
            darkMode: Theme.of(context).brightness == Brightness.dark,
          );
        },
      ),
    );
  }
}
