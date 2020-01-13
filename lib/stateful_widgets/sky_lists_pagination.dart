import 'dart:developer';

import 'package:flutter/material.dart';
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
    super.initState();
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
    _getLists();
  }

  _getLists() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    _db.streamLists(userId: user.uid).listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastListInData = snapshots.last;
      }
      _listOfSkyLists = snapshots;
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      log('Lists were updated', name: 'SkyListsPagination stream');
    });
  }

  _loadMoreLists() async {
    if (!_moreListsAvailable) return;
    if (_gettingMoreLists) return;
    final user = await FirebaseAuth.instance.currentUser();
    if (user == null) return;

    setState(() {
      _gettingMoreLists = true;
    });

    _db
        .streamLists(
            userId: user.uid, afterLastModified: _lastListInData.lastModified)
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _moreListsAvailable = false;
      }

      _lastListInData = snapshots.last;

      _listOfSkyLists.addAll(snapshots);
      if (!mounted) return;
      setState(() {
        _gettingMoreLists = false;
      });

      log('Additional lists were updated',
          name: 'SkyListsPagination _loadMoreLists()');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
