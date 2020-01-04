import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_profile.dart';
import 'package:sky_lists/models/sky_list_shared.dart';
import 'package:sky_lists/database_service.dart';

class SkyListSharedWithBuilder extends StatelessWidget {
  SkyListSharedWithBuilder({
    @required this.controller,
    @required this.data,
    @required this.isLoading,
    @required this.isGettingMorePeople,
  });

  final ScrollController controller;
  final List<SkyListShared> data;
  final bool isLoading;
  final bool isGettingMorePeople;

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            controller: controller,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _db.getUsersProfile(userId: data[index].sharedWithId),
                builder: (context, AsyncSnapshot<SkyListProfile> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListTile(
                    title: Text(snapshot.data.name),
                    subtitle: Text(snapshot.data.email),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _db.removeFromSharedList(
                          list: Provider.of<SkyListMeta>(context),
                          ownerId: Provider.of<FirebaseUser>(context).uid,
                          sharedWithId: data[index].sharedWithId,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}
