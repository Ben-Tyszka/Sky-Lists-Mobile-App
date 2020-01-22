import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/blocs/require_reauthentication/bloc.dart';
import 'package:sky_lists/presentational_widgets/delete_account.dart';

import 'package:sky_lists/presentational_widgets/google_reauthenticate.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/stateful_widgets/forms/reauthenticate_email_password_form.dart';

import 'package:sky_lists/utils/reauth_type_argument.dart';

class RequireReauthenticationPage extends StatelessWidget {
  static final String routeName = '/reauth';

  @override
  Widget build(BuildContext context) {
    final ReauthTypeArgument args = ModalRoute.of(context).settings.arguments;

    return BlocProvider<RequireReauthenticationBloc>(
      create: (_) => RequireReauthenticationBloc(
        userRepository: Provider.of<UserRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPopAllAndPushTo(
                  AccountPage.routeName,
                ),
              );
            },
          ),
          title: Text('Please Login Again'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ReauthenticateEmailAndPasswordForm(),
                SizedBox(height: 15.0),
                GoogleReauthenticate(),
                SizedBox(height: 15.0),
                Text(args.type == SensitiveOperationType.DELETE_ACCOUNT
                    ? 'To delete account, please log in again to confirm your identity'
                    : ''),
                DeleteAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
