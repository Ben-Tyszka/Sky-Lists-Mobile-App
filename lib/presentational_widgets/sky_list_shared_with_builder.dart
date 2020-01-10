import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_profile.dart';
import 'package:sky_lists/models/sky_list_share_page_meta.dart';
import 'package:sky_lists/database_service.dart';

class SkyListSharedWithBuilder extends StatelessWidget {
  SkyListSharedWithBuilder({
    @required this.controller,
    @required this.data,
    @required this.isLoading,
    @required this.isGettingMorePeople,
  });

  final ScrollController controller;
  final List<SkyListSharePageMeta> data;
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
              return FutureBuilder<SkyListProfile>(
                future: _db.getUsersProfile(userId: data[index].sharedWithId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListTile(
                    title: Text(snapshot.data.name),
                    subtitle: Text(snapshot.data.email),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<FirebaseAnalytics>(context)
                            .logEvent(name: 'list_unshare');

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
