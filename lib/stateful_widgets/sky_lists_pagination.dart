import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/sky_lists_builder.dart';

class SkyListsPagination extends StatefulWidget {
  SkyListsPagination({this.showArchived = false});

  final bool showArchived;
  @override
  _SkyListsPaginationState createState() => _SkyListsPaginationState();
}

class _SkyListsPaginationState extends State<SkyListsPagination> {
  final _scrollController = ScrollController();
  ListMetadataBloc _bloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<ListMetadataBloc>(context);

    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta) {
      _bloc.add(
        LoadListsMetadata(
          showArchived: widget.showArchived,
        ),
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
    return BlocBuilder<ListMetadataBloc, ListMetadataState>(
      builder: (context, state) {
        if (state is ListMetadatasLoaded) {
          return Provider(
            create: (_) => widget.showArchived,
            child: SkyListsBuilder(
              controller: _scrollController,
              hasReachedMax: state.hasReachedMax,
              lists: state.lists,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
