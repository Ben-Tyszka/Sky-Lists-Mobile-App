import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:sky_lists/blocs/authentication_bloc/authentication_state.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/list_metadata_bloc.dart';
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
          builder: (_) => BlocProvider<ListMetadataBloc>(
            create: (_) => ListMetadataBloc(
              listsRepository: FirebaseListMetadataRepository(
                (BlocProvider.of<AuthenticationBloc>(context) as Authenticated)
                    .user
                    .uid,
              ),
            )..add(
                LoadListMetadata(list),
              ),
            child: ScheduleListDialog(),
          ),
        );
      },
    );
  }
}
