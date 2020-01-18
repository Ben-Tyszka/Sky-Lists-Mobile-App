import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';

class SkyListSharedWithBuilder extends StatelessWidget {
  SkyListSharedWithBuilder({
    @required this.controller,
    @required this.profiles,
    @required this.hasReachedMax,
  });

  final ScrollController controller;
  final List<UserProfile> profiles;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) return Text('List has not been shared with anyone');
    return ListView.builder(
      controller: controller,
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];

        return ListTile(
          title: Text(profile.name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<ListSharedWithBloc>(context).add(
                ListSharedWithUnshareUser(
                  profile: profile,
                  list: Provider.of<ListMetadata>(context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
