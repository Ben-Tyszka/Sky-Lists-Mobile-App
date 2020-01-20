import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/blocs/list_shared_with_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/sky_list_shared_with_builder.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListSharedWithPagination extends StatefulWidget {
  SkyListSharedWithPagination(this.repo);

  final ListMetadataRepository repo;
  @override
  _SkyListSharedWithPaginationState createState() =>
      _SkyListSharedWithPaginationState();
}

class _SkyListSharedWithPaginationState
    extends State<SkyListSharedWithPagination> {
  final _scrollController = ScrollController();
  ListSharedWithBloc _bloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<ListSharedWithBloc>(context);

    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta) {
      _bloc.add(LoadListSharedWith());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    BlocProvider.of<ListSharedWithBloc>(context)?.close();
    BlocProvider.of<ListMetadataBloc>(context)?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListSharedWithBloc, ListSharedWithState>(
      builder: (context, state) {
        if (state is ListSharedWithLoaded) {
          return SkyListSharedWithBuilder(
            controller: _scrollController,
            listSharedWith: state.listSharedWith,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
