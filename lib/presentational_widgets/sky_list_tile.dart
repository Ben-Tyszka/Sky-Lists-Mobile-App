import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';

import 'package:sky_lists/utils/sky_list_page_arguments.dart';
import 'package:sky_lists/utils/sky_lists_app_theme.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListTile extends StatelessWidget {
  SkyListTile({@required this.list});

  final ListMetadata list;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(list.name),
      subtitle: Text(
        timestampToFormmatedDate(list.lastModified),
        style: Theme.of(context).primaryTextTheme.body1.copyWith(
              color: secondaryTextColor,
            ),
      ),
      onTap: () {
        BlocProvider.of<NavigatorBloc>(context).add(
          NavigatorPushTo(
            SkyListPage.routeName,
            arguments: SkyListPageArguments(
              list,
            ),
          ),
        );
      },
    );
  }
}
