import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/register_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/repositories/user_repository.dart';
import 'package:sky_lists/stateful_widgets/forms/create_account_form.dart';

class CreateAccountPage extends StatelessWidget {
  static final String routeName = '/create_account_page';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticated) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorReplace(
              LoggedInHomePage.routeName,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPopAllAndPushTo(
                  NotLoggedInPage.routeName,
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              BlocProvider<RegisterBloc>(
                create: (_) => RegisterBloc(
                  userRepository: Provider.of<UserRepository>(context),
                ),
                child: CreateAccountForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
