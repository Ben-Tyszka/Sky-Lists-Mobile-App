import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

class SkyListPageLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        BlocProvider.of<ListMetadataBloc>(context)?.close();
        BlocProvider.of<ListItemsBloc>(context)?.close();
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoggedInHomePage.routeName,
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
