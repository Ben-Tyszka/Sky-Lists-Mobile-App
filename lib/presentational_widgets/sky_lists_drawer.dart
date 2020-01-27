import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/account_page.dart';

class SkyListsDrawwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Scheduled Lists'),
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text('Trending Lists'),
          ),
          ListTile(
            leading: Icon(Icons.archive),
            title: Text('Archived Lists'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Account'),
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPushTo(
                  AccountPage.routeName,
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
