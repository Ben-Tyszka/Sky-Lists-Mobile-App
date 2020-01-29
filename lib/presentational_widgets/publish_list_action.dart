import 'package:flutter/material.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/presentational_widgets/publish_list_dialog.dart';

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
              showDialog(
                  context: context, builder: (context) => PublishListDialog());
            },
          )
        : Container();
  }
}
