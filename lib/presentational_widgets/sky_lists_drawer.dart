import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/drawer_item.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/archived_lists_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class SkyListsDrawwer extends StatelessWidget {
  String _getInitials(String nameString) {
    if (nameString.isEmpty) return " ";

    List<String> nameArray =
        nameString.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");
    String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
        (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final user =
        BlocProvider.of<AuthenticationBloc>(context).state as Authenticated;

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
            accountName: Text(
              user.user.displayName,
              style: Theme.of(context).accentTextTheme.title,
            ),
            accountEmail: Text(user.user.email,
                style: Theme.of(context).accentTextTheme.subtitle),
            currentAccountPicture: CircleAvatar(
              child: Text(
                _getInitials(user.user.displayName),
                style: Theme.of(context).accentTextTheme.body2,
              ),
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
          ),
          DrawerItem(
            icon: Icons.home,
            routeName: LoggedInHomePage.routeName,
            text: 'Home',
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Scheduled Lists'),
          ),
          DrawerItem(
            icon: Icons.archive,
            routeName: ArchivedListsPage.routeName,
            text: 'Archived Lists',
          ),
          DrawerItem(
            icon: Icons.account_circle,
            routeName: AccountPage.routeName,
            text: 'My Account',
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
