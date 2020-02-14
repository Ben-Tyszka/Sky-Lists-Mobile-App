import 'package:flutter/material.dart';

import 'package:sky_lists/presentational_widgets/drawer_item.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/archived_lists_page.dart';
import 'package:sky_lists/presentational_widgets/pages/scheduled_lists_page.dart';

import 'package:sky_lists/utils/sky_lists_app_theme.dart';

class SkyListsDrawwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 18,
          ),
          Center(
            child: FlutterLogo(),
          ),
          SizedBox(
            height: 8,
          ),
          DrawerItem(
            icon: Icons.timer,
            text: 'Scheduled Lists',
            routeName: ScheduledListsPage.routeName,
          ),
          DrawerItem(
            icon: Icons.archive,
            routeName: ArchivedListsPage.routeName,
            text: 'Archived Lists',
          ),
          Divider(),
          DrawerItem(
            icon: Icons.account_circle,
            routeName: AccountPage.routeName,
            text: 'My Account',
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Text(
                  '© 2020 Sky Lists',
                  style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                        color: secondaryTextColor,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
