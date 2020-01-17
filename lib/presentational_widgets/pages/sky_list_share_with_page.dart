import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/commonly_shared_with_bloc.dart';
import 'package:sky_lists/blocs/share_list_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/common_shared_with.dart';
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(CustomIcons.qrcode),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => QrCodeAlertDialog(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('Share List'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final repo = FirebaseListMetadataRepository(state.user.uid);
            return Column(
              children: <Widget>[
                SkyListSharedWithPagination(),
                Divider(),
                BlocProvider(
                  create: (_) => CommonlySharedWithBloc(
                    listRepository: repo,
                  ),
                  child: CommonSharedWith(),
                ),
                BlocProvider(
                  create: (_) => ShareListBloc(
                    listMetadataRepository: repo,
                  ),
                  child: ShareWithForm(list: args.list),
                ),
              ],
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              NotLoggedInPage.routeName,
              (Route<dynamic> route) => false,
            );
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
