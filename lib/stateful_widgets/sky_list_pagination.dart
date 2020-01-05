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
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        final maxScroll = _controller.position.maxScrollExtent;
        final current = _controller.position.pixels;
        final delta = MediaQuery.of(context).size.height;

        if (maxScroll - current <= delta) {
          print('Loading more list items');
          _loadMoreItems();
        }
      });
    getItems();
    super.initState();
  }

  getItems() {
    setState(() {
      _isLoading = true;
    });

    _db
        .streamListItems(
      list: Provider.of<SkyListMeta>(context),
    )
        .listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastItem = snapshots.last;
      }
      _items = snapshots;

      setState(() {
        _isLoading = false;
      });
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
    });
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