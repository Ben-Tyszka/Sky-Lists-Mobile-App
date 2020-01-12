import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/presentational_widgets/sky_list_builder.dart';
import 'package:sky_lists/database_service.dart';

class SkyListPagination extends StatefulWidget {
  SkyListPagination({@required this.list});

  final SkyListMeta list;
  @override
  _SkyListPaginationState createState() => _SkyListPaginationState();
}

class _SkyListPaginationState extends State<SkyListPagination> {
  ScrollController _controller;
  List<SkyListItem> _items = [];
  bool _isLoading = true;
  bool _moreListsAvailable = true;
  bool _gettingMoreLists = false;
  SkyListItem _lastItem;

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
          log('More list items are set to be loaded',
              name: 'SkyListPagination didChangeDependencies()');
          _loadMoreItems();
        }
      });

    setState(() {
      _isLoading = true;
    });
    _getItems();
  }

  _getItems() {
    _db
        .streamListItems(
      list: widget.list,
    )
        .listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastItem = snapshots.last;
      }
      _items = snapshots;

      setState(() {
        _isLoading = false;
      });
      log('List items were updated', name: 'SkyListPagination stream');
    });
  }

  _loadMoreItems() {
    if (!_moreListsAvailable) return;
    if (_gettingMoreLists) return;

    setState(() {
      _gettingMoreLists = true;
    });

    _db
        .streamListItems(
      list: widget.list,
      afterAddedAt: _lastItem.addedAt,
    )
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _moreListsAvailable = false;
      }

      _lastItem = snapshots.last;

      _items.addAll(snapshots);
      setState(() {
        _gettingMoreLists = false;
      });
      log('Additional list items were updated',
          name: 'SkyListPagination _loadMoreLists()');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SkyListBuilder(
      controller: _controller,
      data: _items,
      isLoading: _isLoading,
      isGettingMoreLists: _gettingMoreLists,
    );
  }
}
