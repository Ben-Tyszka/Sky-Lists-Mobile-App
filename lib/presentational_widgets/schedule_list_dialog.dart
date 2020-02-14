import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/schedule_list_column.dart';

class ScheduleListDialog extends StatelessWidget {
  ScheduleListDialog({
    @required this.list,
  });

  final ListMetadata list;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Schedule List'),
      content: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return BlocProvider<ListMetadataBloc>(
              create: (_) => ListMetadataBloc(
                listsRepository: FirebaseListMetadataRepository(state.user.uid),
              )..add(
                  LoadListMetadata(list),
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
