import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:vibration/vibration.dart';

import 'package:sky_lists/blocs/shared_with_me_convert_to_list_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';

import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SharedListInfoDialog extends StatelessWidget {
  SharedListInfoDialog({@required this.state});

  final SharedWithMeConvertToListLoaded state;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(state.list.name),
      content: Column(
        children: <Widget>[
          StreamBuilder<UserProfile>(
            stream: Provider.of<FirebaseListMetadataRepository>(context)
                .streamUserProfileFromSharedWithMe(
              Provider.of<SharedWithMe>(context),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Text(
                'Shared by: ${snapshot.data.name} | ${snapshot.data.email}',
              );
            },
          ),
          Text(
            'Shared on: ${timestampToFormmatedDate(state.list.lastModified)}',
          ),
          Text(
            'Last modified: ${timestampToFormmatedDate(state.list.lastModified)}',
          ),
          Text(
              '''Can share list with others? ${state.list.othersCanShareList ? 'Yes' : 'No'}'''),
          Text(
              '''Can delete list items? ${state.list.othersCanDeleteItems ? 'Yes' : 'No'}'''),
          SizedBox(
            height: 10,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            label: Text('Hold to unshare'),
            onPressed: () {},
            onLongPress: () {
              Vibration.vibrate();
              Navigator.pop(context);

              BlocProvider.of<ListSharedWithBloc>(context)
                  .add(ListSharedWithUnshareUser());
            },
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
