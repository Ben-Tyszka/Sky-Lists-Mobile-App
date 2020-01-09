import 'dart:developer';

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
  FirebaseUser _user;

  final _db = DatabaseService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = ScrollController()
      ..addListener(() {
        final maxScroll = _controller.position.maxScrollExtent;
        final current = _controller.position.pixels;
        final delta = MediaQuery.of(context).size.height;

        if (maxScroll - current <= delta) {
          log('More lists are set to be loaded',
              name: 'SkyListsPagination didChangeDependencies()');
          _loadMoreLists();
        }
      });

    _user = Provider.of<FirebaseUser>(context);
    _getLists();
  }

  _getLists() {
    if (_user == null) return;

    setState(() {
      _isLoading = true;
    });

    _db.streamLists(userId: _user.uid).listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastListInData = snapshots.last;
      }
      _listOfSkyLists = snapshots;
      setState(() {
        _isLoading = false;
      });
      log('Lists were updated', name: 'Sky Lists Pagination _getLists()');
    });
  }

  _loadMoreLists() {
    if (!_moreListsAvailable) return;
    if (_gettingMoreLists) return;
    assert(_user == null);

    setState(() {
      _gettingMoreLists = true;
    });

    _db
        .streamLists(
            userId: _user.uid, afterLastModified: _lastListInData.lastModified)
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _moreListsAvailable = false;
      }

      _lastListInData = snapshots.last;

      _listOfSkyLists.addAll(snapshots);
      setState(() {
        _gettingMoreLists = false;
      });

      log('Additional lists were updated',
          name: 'Sky Lists Pagination _loadMoreLists()');
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
