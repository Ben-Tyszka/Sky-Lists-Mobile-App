import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

class TimePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListMetadataBloc, ListMetadataState>(
      builder: (context, state) {
        if (state is ListLoaded) {
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
        return Container();
      },
    );
  }
}
