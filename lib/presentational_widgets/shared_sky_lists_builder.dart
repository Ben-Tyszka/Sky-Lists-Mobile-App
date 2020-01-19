import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/shared_with_me_convert_to_list_bloc/shared_with_me_convert_to_list_bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_convert_to_list_bloc/shared_with_me_convert_to_list_event.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/presentational_widgets/shared_lists_tile.dart';

class SharedSkyListsBuilder extends StatelessWidget {
  SharedSkyListsBuilder({
    @required this.controller,
    @required this.sharedWithMe,
    @required this.hasReachedMax,
  });

  final ScrollController controller;
  final List<SharedWithMe> sharedWithMe;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    if (sharedWithMe.length == 0)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No lists are shared with you',
              style: Theme.of(context).primaryTextTheme.display1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    return ListView.builder(
      controller: controller,
      itemCount: sharedWithMe.length,
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (_) => SharedWithMeConvertToListBloc(
            listRepository:
                Provider.of<FirebaseListMetadataRepository>(context),
          )..add(
              LoadSharedWithMeConvertToList(
                sharedWithMe: sharedWithMe[index],
              ),
            ),
          child: SharedListsTile(),
        );
      },
    );
  }
}
