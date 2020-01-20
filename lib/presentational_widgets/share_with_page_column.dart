import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';
import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_permission_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/common_shared_with.dart';
import 'package:sky_lists/presentational_widgets/list_share_settings_button.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/stateful_widgets/forms/share_with_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_shared_with_pagination.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ShareWithPageColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedPermissionBloc, SharedPermissionState>(
      listener: (context, state) {
        if (state is SharedPermissionNotAllowed &&
            !Provider.of<FirebaseListMetadataRepository>(context).isOwner(
              (Provider.of<ListMetadataBloc>(context).state as ListLoaded).list,
            )) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoggedInHomePage.routeName,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<ListMetadataBloc, ListMetadataState>(
        builder: (context, state) {
          if (state is ListLoaded) {
            final repo = Provider.of<FirebaseListMetadataRepository>(context);
            return Column(
              children: <Widget>[
                if (repo.isOwner(state.list) ||
                    state.list.othersCanShareList) ...[
                  BlocProvider(
                    create: (_) => ShareListBloc(
                      listMetadataRepository: repo,
                    ),
                    child: ShareWithForm(),
                  ),
                  if (repo.isOwner(state.list)) ...[
                    ListShareSettingsButton(),
                  ],
                  BlocProvider(
                    create: (_) => CommonlySharedWithBloc(
                      listRepository: repo,
                    )..add(LoadCommonlySharedWith()),
                    child: CommonSharedWith(),
                  ),
                ],
                Divider(),
                BlocProvider(
                  create: (_) => ListSharedWithBloc(
                    listRepository: repo,
                  )..add(
                      LoadListSharedWith(
                        list: state.list,
                      ),
                    ),
                  child: SkyListSharedWithPagination(repo),
                ),
              ],
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
