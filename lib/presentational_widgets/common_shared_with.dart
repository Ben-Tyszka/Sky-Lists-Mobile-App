import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_color/random_color.dart';

import 'package:sky_lists/database_service.dart';
import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_profile.dart';

class CommonSharedWith extends StatelessWidget {
  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _db.getCommonSharedWith(
        userId: Provider.of<FirebaseUser>(context).uid,
      ),
      builder: (context, AsyncSnapshot<List<SkyListProfile>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return ActionChip(
              onPressed: () {
                _db.shareList(
                  list: Provider.of<SkyListMeta>(context),
                  shareWithId: snapshot.data[index].docRef.documentID,
                );
              },
              label: Text(snapshot.data[index].name),
              backgroundColor: RandomColor().randomColor(),
            );
          },
        );
      },
    );
  }
}
