import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/stateful_widgets/forms/new_list_form.dart';

class AddListFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 10,
      backgroundColor: Theme.of(context).accentColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider<ListMetadataBloc>.value(
            value: BlocProvider.of<ListMetadataBloc>(context),
            child: NewListForm(),
          ),
        );
      },
      icon: Icon(Icons.add),
      label: Text('Add List'),
    );
  }
}
