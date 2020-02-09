import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_convert_bloc/bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/utils/sky_lists_app_theme.dart';

class ListSharedWithUserTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ListSharedWithConvertProfileBloc>(context),
      builder: (context, state) {
        if (state is ListSharedWithConvertProfileLoaded) {
          final shouldShowDeleteIcon =
              (BlocProvider.of<ListMetadataBloc>(context).state as ListLoaded)
                      .list
                      .othersCanDeleteItems ||
                  Provider.of<FirebaseListMetadataRepository>(context).isOwner(
                      (BlocProvider.of<ListMetadataBloc>(context).state
                              as ListLoaded)
                          .list);
          return ListTile(
            title: Text(state.userProfile.name),
            subtitle: Text(
              state.userProfile.email,
              style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                    color: secondaryTextColor,
                  ),
            ),
            trailing: shouldShowDeleteIcon
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      BlocProvider.of<ListSharedWithBloc>(context).add(
                        ListSharedWithUnshareUser(
                          profile: state.userProfile,
                          list: (BlocProvider.of<ListMetadataBloc>(context)
                                  .state as ListLoaded)
                              .list,
                        ),
                      );
                    },
                  )
                : null,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
