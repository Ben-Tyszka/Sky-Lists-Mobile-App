import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/presentational_widgets/sky_list_builder.dart';
import 'package:sky_lists/database_service.dart';

class SkyListPagination extends StatefulWidget {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

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

    final list = Provider.of<SkyListMeta>(context);
    assert(list != null);

    setState(() {
      _isLoading = true;
    });

    _db
        .streamListItems(
      list: list,
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

  _loadMoreItems() async {
    if (!_moreListsAvailable) return;
    if (_gettingMoreLists) return;

    setState(() {
      _gettingMoreLists = true;
    });

    _db
        .streamListItems(
      list: Provider.of<SkyListMeta>(context),
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
