import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/list_shared_with_convert_bloc/list_shared_with_convert_profile_bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_convert_bloc/list_shared_with_convert_profile_event.dart';

import 'package:sky_lists/presentational_widgets/list_shared_with_user_tile.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListSharedWithBuilder extends StatelessWidget {
  SkyListSharedWithBuilder({
    @required this.controller,
    @required this.listSharedWith,
  });

  final ScrollController controller;
  final List<ListSharedWith> listSharedWith;

  @override
  Widget build(BuildContext context) {
    if (listSharedWith.isNotEmpty) {
      return Column(
        children: <Widget>[
          Text(
            'Shared With',
            style: Theme.of(context).primaryTextTheme.display1,
            textAlign: TextAlign.center,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            controller: controller,
            itemCount: listSharedWith.length,
            itemBuilder: (context, index) {
              return BlocProvider(
                create: (_) => ListSharedWithConvertProfileBloc(
                  listRepository:
                      Provider.of<FirebaseListMetadataRepository>(context),
                )..add(
                    LoadListSharedWithConvertProfile(
                      sharedWith: listSharedWith[index],
                    ),
                  ),
                child: ListSharedWithUserTile(),
              );
            },
          ),
        ],
      );
    }
    return Text(
      'Not Shared',
      style: Theme.of(context).primaryTextTheme.display1,
      textAlign: TextAlign.center,
    );
  }
}
