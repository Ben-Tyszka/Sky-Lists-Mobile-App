import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/login_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/google_sign_in.dart';
import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/stateful_widgets/forms/login_form.dart';

/// Page user sees when not logged in
class NotLoggedInPage extends StatelessWidget {
  /// Name for page route
  static final String routeName = '/not_logged_in_page';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorReplace(
              LoggedInHomePage.routeName,
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(
                  userRepository: Provider.of<UserRepository>(context),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Sky Lists',
                      style: Theme.of(context).primaryTextTheme.display2,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      'simple and connected',
                      style: Theme.of(context).primaryTextTheme.display1,
                    ),
                    SizedBox(height: 15.0),
                    LoginForm(),
                    SizedBox(height: 15.0),
                    OutlineButton.icon(
                      icon: Icon(Icons.email),
                      label: Text('Sign up with Email'),
                      onPressed: () {
                        // Pushes the CreateAccountPage for user to make account
                        Navigator.pushNamed(
                            context, CreateAccountPage.routeName);
                        BlocProvider.of<NavigatorBloc>(context).add(
                          NavigatorPushTo(
                            CreateAccountPage.routeName,
                          ),
                        );
                      },
                    ),
                    GoogleSignIn(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
