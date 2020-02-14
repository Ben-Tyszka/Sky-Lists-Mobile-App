import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

class TimePicker extends StatelessWidget {
  TimePicker({
    @required this.state,
  });

  final ListLoaded state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('At ${state.list.scheduleTime}'),
        FlatButton.icon(
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then(
              (val) {
                BlocProvider.of(context).add(
                  ListUpdated(
                    state.list.copyWith(
                      scheduleTime: val.toString(),
                      enableSchedule: state.list.schedule == Schedule.DAILY ||
                          (state.list.schedule != Schedule.DAILY &&
                              state.list.daysOfWeek.containsValue(true) &&
                              state.list.scheduleTime.isNotEmpty),
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.timer),
          label: Text('Set Time'),
        ),
      ],
    );
  }
}
