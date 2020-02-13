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
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: days.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final currentDay = DayOfWeek.values[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: RawMaterialButton(
              key: ObjectKey(currentDay),
              onPressed: () {
                final copyOfDaysOfWeek = list.daysOfWeek;
                copyOfDaysOfWeek[currentDay] = !copyOfDaysOfWeek[currentDay];

                BlocProvider.of<ListMetadataBloc>(context).add(
                  UpdateListMetadata(
                    list.copyWith(
                      daysOfWeek: copyOfDaysOfWeek,
                    ),
                  ),
                );
              },
              child: Text(
                days[index],
                style: Theme.of(context).primaryTextTheme.bodyText1,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor:
                  list.daysOfWeek[currentDay] ? Colors.blue : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
