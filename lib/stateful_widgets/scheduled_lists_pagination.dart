import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_scheduled_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/scheduled_lists_builder.dart';

class ScheduledListsPagination extends StatefulWidget {
  ScheduledListsPagination();

  @override
  _ScheduledListsPaginationState createState() =>
      _ScheduledListsPaginationState();
}

class _ScheduledListsPaginationState extends State<ScheduledListsPagination> {
  final _scrollController = ScrollController();
  ListScheduledBloc _bloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<ListScheduledBloc>(context);

    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta) {
      _bloc.add(
        LoadListsMetadata(),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListScheduledBloc, ListScheduledState>(
      builder: (context, state) {
        if (state is ListScheduledsLoaded) {
          return ScheduledListsBuilder(
            controller: _scrollController,
            hasReachedMax: state.hasReachedMax,
            lists: state.lists,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
