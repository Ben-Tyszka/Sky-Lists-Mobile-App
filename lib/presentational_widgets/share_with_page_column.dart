import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_permission_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/common_shared_with.dart'
    as CommonSharedWithWidget;
import 'package:sky_lists/presentational_widgets/list_share_settings_button.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/stateful_widgets/forms/share_with_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_shared_with_pagination.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ShareWithPageColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedPermissionBloc, SharedPermissionState>(
      builder: (context, _) {
        if (_ is SharedPermissionNotAllowed) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorPushTo(
              LoggedInHomePage.routeName,
            ),
          );
        }
        return BlocBuilder<ListMetadataBloc, ListMetadataState>(
          builder: (context, state) {
            if (state is ListLoaded) {
              final repo = Provider.of<FirebaseListMetadataRepository>(context);
              final isOwner = repo.isOwner(state.list);
              return Column(
                children: <Widget>[
                  if (isOwner || state.list.othersCanShareList) ...[
                    BlocProvider(
                      create: (_) => ShareListBloc(
                        listMetadataRepository: repo,
                      ),
                      child: ShareWithForm(),
                    ),
                    if (isOwner) ...[
                      ListShareSettingsButton(list: state.list),
                    ],
                    BlocProvider(
                      create: (_) => CommonlySharedWithBloc(
                        listRepository: repo,
                      )..add(LoadCommonlySharedWith()),
                      child: CommonSharedWithWidget.CommonSharedWith(),
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
        );
      },
    );
  }
}
