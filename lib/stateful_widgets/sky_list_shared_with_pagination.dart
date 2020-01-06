import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/models/sky_list_meta.dart';
import 'package:sky_lists/models/sky_list_share_page_meta.dart';
import 'package:sky_lists/presentational_widgets/sky_list_shared_with_builder.dart';
import 'package:sky_lists/database_service.dart';

class SkyListSharedWithPagination extends StatefulWidget {
  @override
  _SkyListSharedWithPaginationState createState() =>
      _SkyListSharedWithPaginationState();
}

class _SkyListSharedWithPaginationState
    extends State<SkyListSharedWithPagination> {
  ScrollController _controller;
  List<SkyListSharePageMeta> _people = [];
  bool _isLoading = true;
  bool _morePeopleAvailable = true;
  bool _gettingMorePeople = false;
  SkyListSharePageMeta _lastPerson;

  final _db = DatabaseService();

  @override
  void initState() {
    _controller = ScrollController()
      ..addListener(() {
        final maxScroll = _controller.position.maxScrollExtent;
        final current = _controller.position.pixels;
        final delta = MediaQuery.of(context).size.height;

        if (maxScroll - current <= delta) {
          print('Loading more list shared with');
          _loadMorePeople();
        }
      });
    getSharedWith();

    super.initState();
  }

  getSharedWith() {
    setState(() {
      _isLoading = true;
    });

    _db
        .streamListSharedWith(
      list: Provider.of<SkyListMeta>(context),
    )
        .listen((snapshots) {
      if (snapshots.isNotEmpty) {
        _lastPerson = snapshots.last;
      }
      _people = snapshots;

      setState(() {
        _isLoading = false;
      });
    });
  }

  _loadMorePeople() async {
    if (!_morePeopleAvailable) return;
    if (_gettingMorePeople) return;

    setState(() {
      _gettingMorePeople = true;
    });

    _db
        .streamListSharedWith(
      list: Provider.of<SkyListMeta>(context),
      afterSharedAt: _lastPerson.sharedAt,
    )
        .listen((snapshots) {
      if (snapshots.length < 10) {
        _morePeopleAvailable = false;
      }

      _lastPerson = snapshots.last;

      _people.addAll(snapshots);

      setState(() {
        _gettingMorePeople = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkyListSharedWithBuilder(
        controller: _controller,
        data: _people,
        isLoading: _isLoading,
        isGettingMorePeople: _gettingMorePeople);
  }
}
