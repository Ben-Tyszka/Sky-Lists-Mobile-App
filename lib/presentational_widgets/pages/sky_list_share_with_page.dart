import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_permission_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/qr_code_dialog.dart';
import 'package:sky_lists/presentational_widgets/share_with_page_column.dart';

import 'package:sky_lists/utils/custom_icons.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListShareWithPage extends StatelessWidget {
  static final String routeName = '/list_share';

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final repo = FirebaseListMetadataRepository(state.user.uid);
          return MultiBlocProvider(
            providers: [
              BlocProvider<ListMetadataBloc>(
                create: (_) => ListMetadataBloc(
                  listsRepository: repo,
                )..add(
                    LoadListMetadata(args.list),
                  ),
              ),
              BlocProvider<SharedPermissionBloc>(
                create: (_) => SharedPermissionBloc(
                  listRepository: repo,
                )..add(
                    LoadSharedPermission(list: args.list),
                  ),
              ),
            ],
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
                title: Text('Share List'),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Provider(
                create: (_) => repo,
                child: SingleChildScrollView(
                  child: ShareWithPageColumn(),
                ),
              ),
            ),
          );
        } else if (state is Unauthenticated) {
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
    );
  }
}
