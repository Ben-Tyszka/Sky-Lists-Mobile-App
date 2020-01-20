import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';
import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/common_shared_with.dart';
import 'package:sky_lists/presentational_widgets/list_share_settings_button.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/qr_code_dialog.dart';

import 'package:sky_lists/stateful_widgets/forms/share_with_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_shared_with_pagination.dart';

import 'package:sky_lists/utils/custom_icons.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListShareWithPage extends StatelessWidget {
  static final String routeName = '/list_share';

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            NotLoggedInPage.routeName,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(CustomIcons.qrcode),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => QrCodeAlertDialog(
                    list: args.list,
                  ),
                );
              },
            ),
          ],
          title: Text('Share'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              final repo = FirebaseListMetadataRepository(state.user.uid);
              return Provider(
                create: (_) => args.list,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      BlocProvider(
                        create: (_) => ShareListBloc(
                          listMetadataRepository: repo,
                        ),
                        child: ShareWithForm(),
                      ),
                      BlocProvider<ListMetadataBloc>(
                        create: (_) => ListMetadataBloc(
                          listsRepository:
                              FirebaseListMetadataRepository(state.user.uid),
                        )..add(LoadListMetadata(args.list)),
                        child: ListShareSettingsButton(),
                      ),
                      BlocProvider(
                        create: (_) => CommonlySharedWithBloc(
                          listRepository: repo,
                        )..add(LoadCommonlySharedWith()),
                        child: CommonSharedWith(),
                      ),
                      Divider(),
                      BlocProvider(
                        create: (_) => ListSharedWithBloc(
                          listRepository: repo,
                        )..add(
                            LoadListSharedWith(
                              list: args.list,
                            ),
                          ),
                        child: SkyListSharedWithPagination(repo),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
