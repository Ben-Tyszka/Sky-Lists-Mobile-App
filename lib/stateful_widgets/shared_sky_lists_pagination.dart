import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/models/sky_list_shared_meta.dart';
import 'package:sky_lists/presentational_widgets/shared_sky_lists_builder.dart';
import 'package:sky_lists/database_service.dart';

class SharedSkyListsPagination extends StatefulWidget {
  @override
  _SharedSkyListsPaginationState createState() =>
      _SharedSkyListsPaginationState();
}

class _SharedSkyListsPaginationState extends State<SharedSkyListsPagination> {
  ScrollController _controller;
  List<SkyListSharedMeta> _listOfSharedSkyLists = [];
  bool _isLoading = true;
  bool _moreListsAvailable = true;
  bool _gettingMoreLists = false;
  SkyListSharedMeta _lastSharedListInData;

  final _db = DatabaseService();

  @override
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        final maxScroll = _controller.position.maxScrollExtent;
        final current = _controller.position.pixels;
        final delta = MediaQuery.of(context).size.height;

        if (maxScroll - current <= delta) {
          print('Loading more lists');
          _loadMoreLists();
        }
      });
    getLists();
    super.initState();
  }

  getLists() {
    setState(() {
      _isLoading = true;
    });
    final user = Provider.of<FirebaseUser>(context);
    _db.streamListsSharedWithMe(userId: user.uid).listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastSharedListInData = snapshots.last;
      }
      _listOfSharedSkyLists = snapshots;
      setState(() {
        _isLoading = false;
      });
    });
  }

  _loadMoreLists() async {
    if (!_moreListsAvailable) return;
    if (_gettingMoreLists) return;
    setState(() {
      _gettingMoreLists = true;
    });

    final user = Provider.of<FirebaseUser>(context);
    _db
        .streamListsSharedWithMe(
            userId: user.uid, afterSharedAt: _lastSharedListInData.sharedAt)
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _moreListsAvailable = false;
      }

      _lastSharedListInData = snapshots.last;

      _listOfSharedSkyLists.addAll(snapshots);
      setState(() {
        _gettingMoreLists = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SharedSkyListsBuilder(
      controller: _controller,
      data: _listOfSharedSkyLists,
      isLoading: _isLoading,
      isGettingMoreLists: _gettingMoreLists,
    );
  }
}
