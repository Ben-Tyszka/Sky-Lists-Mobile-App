import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:vibration/vibration.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_shared_meta.dart';
import 'package:sky_lists/utils/timestamp_to_formmated_date.dart';
import 'package:sky_lists/database_service.dart';

class SharedListInfoDialog extends StatelessWidget {
  SharedListInfoDialog({@required this.list, @required this.sharedList});

  final SkyListMeta list;
  final SkyListSharedMeta sharedList;

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(list.name),
      content: Column(
        children: <Widget>[
          FutureBuilder(
            future: _db.getUserDisplayName(userId: sharedList.owner),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return Row(
                children: <Widget>[
                  Text('Shared by: ${snapshot.data}'),
                  CircleAvatar(
                    backgroundColor: RandomColor().randomColor(),
                    child: Text(snapshot.data[0]),
                    radius: 6.0,
                  ),
                ],
              );
            },
          ),
          Text('Shared at: ${timestampToFormmatedDate(sharedList.sharedAt)}'),
          Text('Last modified: ${timestampToFormmatedDate(list.lastModified)}'),
          SizedBox(
            height: 10,
          ),
          RaisedButton.icon(
            icon: Icon(Icons.delete),
            color: Colors.red,
            label: Text('Hold to unshare'),
            onPressed: () {},
            onLongPress: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Vibration.vibrate();

              Provider.of<FirebaseAnalytics>(context)
                  .logEvent(name: 'list_unshare_with_me');

              _db.removeFromSharedList(
                list: list,
                ownerId: sharedList.owner,
                sharedWithId: Provider.of<FirebaseUser>(context).uid,
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
