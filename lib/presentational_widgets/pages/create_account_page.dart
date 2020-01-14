import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/register_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/repositories/user_repository.dart';
import 'package:sky_lists/stateful_widgets/forms/create_account_form.dart';

class CreateAccountPage extends StatelessWidget {
  static final String routeName = '/create_account_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              NotLoggedInPage.routeName,
              (Route<dynamic> route) => false,
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
    );
  }
}
