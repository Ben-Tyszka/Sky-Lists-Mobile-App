import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/drawer_item.dart';

import 'package:sky_lists/presentational_widgets/pages/account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/archived_lists_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class SkyListsDrawwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerItem(
            icon: Icons.home,
            routeName: LoggedInHomePage.routeName,
            text: 'Home',
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Scheduled Lists'),
          ),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text('Trending Lists'),
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
