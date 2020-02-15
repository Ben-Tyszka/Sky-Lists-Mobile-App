import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_scheduled_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/stateful_widgets/scheduled_lists_pagination.dart';

class ScheduledListsPage extends StatelessWidget {
  static final routeName = '/scheduled_lists';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final repository = FirebaseListMetadataRepository(state.user.uid);
          return BlocProvider<ListScheduledBloc>(
            create: (_) => ListScheduledBloc(
              listsRepository: repository,
            )..add(LoadListsMetadata()),
            child: Provider(
              create: (_) => repository,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Scheduled Lists'),
                ),
                body: ScheduledListsPagination(),
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
