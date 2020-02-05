import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/schedule_list_column.dart';

import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class ScheduleListPage extends StatelessWidget {
  static final String routeName = '/schedule_list';

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule List'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider<ListMetadataBloc>(
              create: (_) => ListMetadataBloc(
                listsRepository: FirebaseListMetadataRepository(state.user.uid),
              )..add(
                  LoadListMetadata(args.list),
                ),
              child: ScheduleListColumn(),
            );
          }
          if (state is Unauthenticated) {
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
      ),
    );
  }
}
