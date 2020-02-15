import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/schedule_list_dialog.dart';

import 'package:sky_lists/utils/sky_lists_app_theme.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class ScheduledListTile extends StatelessWidget {
  ScheduledListTile({@required this.list});

  final ListMetadata list;

  @override
  Widget build(BuildContext context) {
    String schedule = '';
    StringBuffer days;
    final Map<DayOfWeek, bool> daysMap = list.daysOfWeek;

    if (list.schedule == Schedule.DAILY) {
      schedule = 'Daily';
    } else if (list.schedule == Schedule.BIWEEKLY) {
      schedule = 'Biweekly';
    } else if (list.schedule == Schedule.MONTHLY) {
      schedule = 'Monthly';
    } else if (list.schedule == Schedule.WEEKLY) {
      schedule = 'Weekly';
    }

    daysMap.forEach((key, value) {
      if (value) {
        if (key == DayOfWeek.SUN) {
          days.write('SUN');
        } else if (key == DayOfWeek.MON) {
          days.write('M');
        } else if (key == DayOfWeek.TUE) {
          days.write('TU');
        } else if (key == DayOfWeek.WED) {
          days.write('W');
        } else if (key == DayOfWeek.TH) {
          days.write('TH');
        } else if (key == DayOfWeek.FRI) {
          days.write('F');
        } else if (key == DayOfWeek.SAT) {
          days.write('SAT');
        }
      }
    });

    return ListTile(
      title: Text(list.name),
      subtitle: Text(
        '$schedule on ${days.toString()} @ ${list.scheduleTime}',
        style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
              color: secondaryTextColor,
            ),
      ),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => BlocProvider<ListMetadataBloc>(
                create: (_) => ListMetadataBloc(
                  listsRepository:
                      Provider.of<FirebaseListMetadataRepository>(context),
                )..add(
                    LoadListMetadata(list),
                  ),
                child: ScheduleListDialog(),
              ),
            );
          }),
    );
  }
}
