import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ListShareSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ListMetadata>(context);
    final _listRepo = Provider.of<FirebaseListMetadataRepository>(context);

    if (_listRepo.isOwner(list))
      return BlocBuilder<ListMetadataBloc, ListMetadataState>(
        builder: (context, state) {
          if (state is ListTitleLoaded) {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Allow others to share list'),
                    Switch(
                      onChanged: (val) {
                        BlocProvider.of<ListMetadataBloc>(context).add(
                          UpdateListMetadata(
                            state.list.copyWith(
                              othersCanShareList: val,
                            ),
                          ),
                        );
                      },
                      value: state.list.othersCanShareList,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Allow others to delete list items'),
                    Switch(
                      onChanged: (val) {
                        BlocProvider.of<ListMetadataBloc>(context).add(
                          UpdateListMetadata(
                            state.list.copyWith(
                              othersCanDeleteItems: val,
                            ),
                          ),
                        );
                      },
                      value: state.list.othersCanDeleteItems,
                    ),
                  ],
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

    return Container();
  }
}
