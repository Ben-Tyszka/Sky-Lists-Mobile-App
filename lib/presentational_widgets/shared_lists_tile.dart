import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_convert_to_list_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/presentational_widgets/shared_list_info_dialog.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SharedListsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<SharedWithMeConvertToListBloc>(context),
      builder: (context, state) {
        if (state is SharedWithMeConvertToListLoaded) {
          return ListTile(
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPushTo(
                  SkyListPage.routeName,
                  arguments: SkyListPageArguments(
                    state.list,
                  ),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => Provider.value(
                  value: Provider.of<SharedWithMe>(context),
                  child: SharedListInfoDialog(state: state),
                ),
              );
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
