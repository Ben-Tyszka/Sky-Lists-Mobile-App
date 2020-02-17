import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/schedule_list_column.dart';

class ScheduleListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMetadataBloc, ListMetadataState>(
      builder: (context, state) {
        if (state is ListLoaded) {
          final saveEnabled = state.list.schedule == Schedule.DAILY ||
              (state.list.schedule != Schedule.DAILY &&
                  state.list.daysOfWeek.containsValue(true) &&
                  state.list.scheduleTime.isNotEmpty);

          return AlertDialog(
            title: Text('Schedule List'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text('Close'),
              ),
              FlatButton(
                onPressed: saveEnabled
                    ? () {
                        final listCopy = state.list.copyWith(
                          enableSchedule: true,
                        );
                        BlocProvider.of<ListMetadataBloc>(context).add(
                          UpdateListMetadata(listCopy),
                        );
                        BlocProvider.of<ListMetadataBloc>(context).add(
                          CopyAndSaveScheduleList(listCopy),
                        );
                      }
                    : null,
                child: Text('Save'),
              ),
            ],
            content: ScheduleListColumn(
              state: state,
            ),
          );
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
