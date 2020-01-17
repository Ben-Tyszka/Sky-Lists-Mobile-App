import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';

import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/bloc.dart';

class CommonSharedWith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonlySharedWithBloc, CommonlySharedWithState>(
      builder: (context, state) {
        if (state is CommonlySharedWithLoaded) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.profiles.length,
            itemBuilder: (context, index) {
              return ActionChip(
                onPressed: () {
                  // _db.shareList(
                  //   list: Provider.of<SkyListMeta>(context),
                  //   shareWithId: snapshot.data[index].docRef.documentID,
                },
                label: Text(state.profiles[index].name),
                backgroundColor: RandomColor().randomColor(),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
