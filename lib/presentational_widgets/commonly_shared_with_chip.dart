import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';

import 'package:sky_lists/blocs/commonly_shared_with_convert_to_user_profile_bloc/bloc.dart';

class CommonlySharedWithChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonlySharedWithConvertToUserProfileBloc,
        CommonlySharedWithConvertToUserProfileState>(
      builder: (context, state) {
        if (state is CommonlySharedWithConvertToUserProfileLoaded) {
          return ActionChip(
            onPressed: () {
              //TODO: Share list with user
            },
            label: Text(state.userProfile.name),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
