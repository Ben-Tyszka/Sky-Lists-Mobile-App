import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/pusblish_list_page.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class PublishListAction extends StatelessWidget {
  PublishListAction({
    @required this.list,
  });

  final ListMetadata list;

  @override
  Widget build(BuildContext context) {
    return Provider.of<FirebaseListMetadataRepository>(context).isOwner(list)
        ? IconButton(
            tooltip: 'Publish List',
            icon: Icon(Icons.public),
            onPressed: () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPushTo(
                  PublishListPage.routeName,
                  arguments: SkyListPageArguments(list),
                ),
              );
            },
          )
        : Container();
  }
}
