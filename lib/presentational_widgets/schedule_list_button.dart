import 'package:flutter/material.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/presentational_widgets/schedule_list_dialog.dart';

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
        showDialog(
          context: context,
          builder: (_) => ScheduleListDialog(
            list: list,
          ),
        );
      },
    );
  }
}
