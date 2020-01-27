import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/name_change_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/change_password_page.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/require_reauthentication_page.dart';
import 'package:sky_lists/presentational_widgets/sign_out_button.dart';
import 'package:sky_lists/presentational_widgets/sky_lists_drawer.dart';

import 'package:sky_lists/stateful_widgets/about_app.dart';
import 'package:sky_lists/stateful_widgets/forms/name_change_form.dart';

import 'package:sky_lists/utils/reauth_type_argument.dart';

import 'package:sky_lists/repositories/user_repository.dart';

class AccountPage extends StatelessWidget {
  static final routeName = '/account_page';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            drawer: SkyListsDrawwer(),
            appBar: AppBar(
              title: Text('Your Account'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) => AboutApp());
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  if (state.user.isEmailVerified) ...[
                    BlocProvider(
                      create: (_) => NameChangeBloc(
                        userRepository: Provider.of<UserRepository>(context),
                      ),
                      child: NameChangeForm(),
                    ),
                    if (state.user.providerData[1].providerId
                        .contains('password')) ...[
                      FlatButton.icon(
                        icon: Icon(Icons.lock_outline),
                        label: Text('Change Password'),
                        onPressed: () {
                          BlocProvider.of<NavigatorBloc>(context).add(
                            NavigatorPushTo(
                              ChangePasswordPage.routeName,
                            ),
                          );
                        },
                      ),
                    ],
                  ] else ...[
                    Card(
                      elevation: 2,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Your email is not verified, some features may be disabled.',
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).primaryTextTheme.title,
                                ),
                              ],
                            ),
                          ),
                          OutlineButton.icon(
                            label: Text('Resend Email'),
                            icon: Icon(
                              Icons.send,
                            ),
                            onPressed: () {
                              state.user.sendEmailVerification();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Email sent, check your inbox'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  Divider(),
                  SignOutButton(),
                  Divider(),
                  RaisedButton.icon(
                    color: Theme.of(context).errorColor,
                    icon: Icon(Icons.delete_forever),
                    label: Text('Delete Account'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RequireReauthenticationPage.routeName,
                        arguments: ReauthTypeArgument(
                          SensitiveOperationType.DELETE_ACCOUNT,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is Unauthenticated) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorPopAllAndPushTo(
              NotLoggedInPage.routeName,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
