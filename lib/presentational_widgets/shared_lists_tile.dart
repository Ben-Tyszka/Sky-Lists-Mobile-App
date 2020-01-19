import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/shared_with_me_convert_to_list_bloc/bloc.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

class SharedListsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<SharedWithMeConvertToListBloc>(context),
      builder: (context, state) {
        if (state is SharedWithMeConvertToListLoaded) {
          return ListTile(
            onTap: () {
              // Navigator.pushNamed(
              //   context,
              //   SkyListPage.routeName,
              //   arguments: null,
              // );
            },
            onLongPress: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => SharedListInfoDialog(
              //     list: snapshot.data,
              //     sharedList: skyList,
              //   ),
              // );
            },
            title: Text(state.list.name),
            subtitle: Text(
              timestampToFormmatedDate(state.list.lastModified),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
