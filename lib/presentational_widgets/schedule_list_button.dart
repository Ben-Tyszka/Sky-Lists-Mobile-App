import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/schedule_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class ScheduleListButton extends StatelessWidget {
  final ListMetadata list;

  ScheduleListButton({
    @required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.schedule),
      onPressed: () {
        BlocProvider.of<NavigatorBloc>(context).add(
          NavigatorPushTo(
            ScheduleListPage.routeName,
            arguments: SkyListPageArguments(list),
          ),
        );
      },
    );
  }
}
