import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListShareSettingsButton extends StatelessWidget {
  final ListMetadata list;

  ListShareSettingsButton({@required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Allow others to share list'),
            Switch(
              onChanged: (val) {
                BlocProvider.of<ListMetadataBloc>(context).add(
                  UpdateListMetadata(
                    list.copyWith(
                      othersCanShareList: val,
                    ),
                  ),
                );
              },
              value: list.othersCanShareList,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Allow others to delete list items'),
            Switch(
              onChanged: (val) {
                BlocProvider.of<ListMetadataBloc>(context).add(
                  UpdateListMetadata(
                    list.copyWith(
                      othersCanDeleteItems: val,
                    ),
                  ),
                );
              },
              value: list.othersCanDeleteItems,
            ),
          ],
        ),
      ],
    );
  }
}
