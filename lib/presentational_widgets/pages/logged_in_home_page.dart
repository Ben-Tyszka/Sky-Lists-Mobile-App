import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_bloc/shared_with_me_bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_bloc/shared_with_me_event.dart';

import 'package:sky_lists/presentational_widgets/add_list_fab.dart';
import 'package:sky_lists/presentational_widgets/bottom_nav_bar_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/qr_scanner_icon.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

import 'package:sky_lists/stateful_widgets/shared_sky_lists_pagination.dart';
import 'package:sky_lists/stateful_widgets/sky_lists_pagination.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class LoggedInHomePage extends StatefulWidget {
  static final String routeName = '/logged_in_home_init';

  @override
  _LoggedInHomePageState createState() => _LoggedInHomePageState();
}

class _LoggedInHomePageState extends State<LoggedInHomePage>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  initState() {
    super.initState();
    if (Platform.isIOS) {
      Provider.of(
        context,
        listen: false,
      ).requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    _controller = TabController(
      vsync: this,
      length: 2,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  onTabTapped(int index) {
    setState(() {
      _controller.animateTo(index);
      _controller.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final repository = FirebaseListMetadataRepository(state.user.uid);
          return MultiBlocProvider(
            providers: [
              BlocProvider<ListMetadataBloc>(
                create: (_) => ListMetadataBloc(
                  listsRepository: repository,
                )..add(LoadListsMetadata()),
              ),
              BlocProvider<SharedWithMeBloc>(
                create: (_) => SharedWithMeBloc(
                  listsRepository: repository,
                )..add(LoadSharedWithMe()),
              ),
            ],
            child: Scaffold(
              drawer: Drawer(
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
                      leading: Icon(Icons.account_circle),
                      title: Text('My Account'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text(
                  'Sky Lists',
                ),
                actions: <Widget>[
                  QrScannerIcon(),
                ],
              ),
              body: Provider(
                create: (_) => repository,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    SafeArea(
                      top: false,
                      bottom: false,
                      child: Container(
                        key: ObjectKey(SkyListsPagination),
                        child: SkyListsPagination(),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      bottom: false,
                      child: Container(
                        key: ObjectKey(SharedSkyListsPagination),
                        child: SharedSkyListsPagination(),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: AddListFab(),
              bottomNavigationBar: BottomNavBarLoggedInPage(
                controller: _controller,
                onTabTapped: onTabTapped,
              ),
            ),
          );
        } else if (state is Unauthenticated) {
          BlocProvider.of<NavigatorBloc>(context)
              .add(NavigatorPopAllAndPushTo(NotLoggedInPage.routeName));
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
