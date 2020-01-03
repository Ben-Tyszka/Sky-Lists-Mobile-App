import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/presentational_widgets/sky_lists_builder.dart';
import 'package:sky_lists/database_service.dart';

class SkyListsPagination extends StatefulWidget {
  @override
  _SkyListsPaginationState createState() => _SkyListsPaginationState();
}

class _SkyListsPaginationState extends State<SkyListsPagination> {
  ScrollController _controller;
  List<SkyListMeta> _listOfSkyLists = [];
  bool _isLoading = true;
  bool _moreListsAvailable = true;
  bool _gettingMoreLists = false;
  SkyListMeta _lastListInData;

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
    _db.streamLists(userId: user.uid).listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastListInData = snapshots.last;
      }
      _listOfSkyLists = snapshots;
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
        .streamLists(
            userId: user.uid, afterLastModified: _lastListInData.lastModified)
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _moreListsAvailable = false;
      }

      _lastListInData = snapshots.last;

      _listOfSkyLists.addAll(snapshots);
      setState(() {
        _gettingMoreLists = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkyListsBuilder(
      controller: _controller,
      data: _listOfSkyLists,
      isLoading: _isLoading,
      isGettingMoreLists: _gettingMoreLists,
    );
  }
}
