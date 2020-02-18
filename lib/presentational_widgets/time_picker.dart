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
        FlatButton.icon(
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then(
              (val) {
                BlocProvider.of<ListMetadataBloc>(context).add(
                  UpdateListMetadata(
                    state.list.copyWith(
                      scheduleTime: val.format(context),
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.timer),
          label: Text(
            state.list.scheduleTime.isEmpty
                ? 'Set Time'
                : state.list.scheduleTime,
          ),
        ),
      ],
    );
  }
}
