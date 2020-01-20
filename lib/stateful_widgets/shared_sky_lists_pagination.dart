import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_with_me_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/shared_sky_lists_builder.dart';

class SharedSkyListsPagination extends StatefulWidget {
  @override
  _SharedSkyListsPaginationState createState() =>
      _SharedSkyListsPaginationState();
}

class _SharedSkyListsPaginationState extends State<SharedSkyListsPagination> {
  final _scrollController = ScrollController();
  SharedWithMeBloc _bloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<SharedWithMeBloc>(context);

    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta) {
      _bloc.add(LoadSharedWithMe());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    BlocProvider.of<ListMetadataBloc>(context).close();
    BlocProvider.of<SharedWithMeBloc>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedWithMeBloc, SharedWithMeState>(
      builder: (context, state) {
        if (state is SharedWithMeLoaded) {
          return SharedSkyListsBuilder(
            controller: _scrollController,
            hasReachedMax: state.hasReachedMax,
            sharedWithMe: state.sharedWithMe,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
