import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

import 'package:sky_lists/presentational_widgets/schedule_list_column.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

class ScheduleListDialog extends StatefulWidget {
  @override
  _ScheduleListDialogState createState() => _ScheduleListDialogState();
}

class _ScheduleListDialogState extends State<ScheduleListDialog> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMetadataBloc, ListMetadataState>(
      builder: (context, state) {
        if (state is ListLoaded) {
          final saveEnabled = (state.list.schedule == Schedule.DAILY &&
                  state.list.scheduleTime.isNotEmpty) ||
              (state.list.schedule != Schedule.DAILY &&
                      state.list.schedule != Schedule.EMPTY &&
                      state.list.daysOfWeek.containsValue(true) &&
                      state.list.scheduleTime.isNotEmpty) &&
                  !loading;

          return AlertDialog(
            title: Text(
              'Schedule List',
              textAlign: TextAlign.center,
            ),
            actions: loading
                ? <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ]
                : <Widget>[
                    FlatButton(
                      onPressed: loading
                          ? null
                          : () {
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigatorPop());
                            },
                      child: Text('Close'),
                    ),
                    FlatButton(
                      onPressed: saveEnabled
                          ? () async {
                              setState(() {
                                loading = true;
                              });
                              final listCopy = state.list.copyWith(
                                enableSchedule: true,
                              );
                              BlocProvider.of<ListMetadataBloc>(context).add(
                                UpdateListMetadata(listCopy),
                              );
                              BlocProvider.of<ListMetadataBloc>(context).add(
                                CopyAndSaveScheduleList(listCopy),
                              );
                              await Future.delayed(
                                Duration(
                                  seconds: 1,
                                ),
                              );
                              setState(() {
                                loading = false;
                              });
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigatorPop());
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
