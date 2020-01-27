import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/commonly_shared_with_convert_to_user_profile_bloc/bloc.dart';
import 'package:sky_lists/blocs/commonly_shared_with_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

class CommonlySharedWithChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonlySharedWithConvertToUserProfileBloc,
        CommonlySharedWithConvertToUserProfileState>(
      builder: (context, state) {
        if (state is CommonlySharedWithConvertToUserProfileLoaded) {
          return ActionChip(
            backgroundColor: Theme.of(context).primaryColorLight,
            onPressed: () {
              BlocProvider.of<CommonlySharedWithBloc>(context).add(
                CommonlySharedWithShareWithUser(
                  state.userProfile,
                  (BlocProvider.of<ListMetadataBloc>(context).state
                          as ListLoaded)
                      .list,
                ),
              );
            },
            label: Text(state.userProfile.name),
            labelStyle: Theme.of(context).primaryTextTheme.body1,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
