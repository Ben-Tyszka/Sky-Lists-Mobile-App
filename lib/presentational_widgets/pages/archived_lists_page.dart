import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';

import 'package:sky_lists/stateful_widgets/sky_lists_pagination.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ArchivedListsPage extends StatelessWidget {
  static final String routeName = '/archived';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Lists'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final repository = FirebaseListMetadataRepository(state.user.uid);
            return BlocProvider<ListMetadataBloc>(
              create: (_) => ListMetadataBloc(
                listsRepository: repository,
              )..add(LoadListsMetadata(showArchived: true)),
              child: Center(
                child: SkyListsPagination(
                  showArchived: true,
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
      ),
    );
  }
}
