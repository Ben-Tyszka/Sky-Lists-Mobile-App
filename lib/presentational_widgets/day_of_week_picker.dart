import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

class DayOfWeekPicker extends StatelessWidget {
  DayOfWeekPicker({
    @required this.list,
  });

  final ListMetadata list;

  final List<String> days = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) {
        final currentDay = DayOfWeek.values[index];
        return GestureDetector(
          onTap: () {
            final copyOfDaysOfWeek = list.daysOfWeek;
            list.daysOfWeek[currentDay] = !list.daysOfWeek[currentDay];

            BlocProvider.of<ListMetadataBloc>(context).add(
              ListUpdated(
                list.copyWith(
                  daysOfWeek: copyOfDaysOfWeek,
                ),
              ),
            );
          },
          child: ClipOval(
            child: Container(
              color: list.daysOfWeek[currentDay] ? Colors.blue : Colors.grey,
              height: 64.0,
              width: 64.0,
              child: Center(
                child: Text(
                  days[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
