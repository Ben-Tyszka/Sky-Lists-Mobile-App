import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/shared_permission_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/presentational_widgets/sky_list_builder.dart';

class SkyListPagination extends StatefulWidget {
  @override
  _SkyListPaginationState createState() => _SkyListPaginationState();
}

class _SkyListPaginationState extends State<SkyListPagination> {
  final _scrollController = ScrollController();
  ListItemsBloc _bloc;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<ListItemsBloc>(context);

    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = MediaQuery.of(context).size.height;
    if (maxScroll - currentScroll <= delta) {
      _bloc.add(LoadListItems());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedPermissionBloc, SharedPermissionState>(
      listener: (context, state) {
        final repo = Provider.of<FirebaseListMetadataRepository>(
          context,
          listen: false,
        );

        if (BlocProvider.of<ListMetadataBloc>(context).state is! ListLoaded)
          return;
        if (state is SharedPermissionNotAllowed &&
            !repo.isOwner(
                (BlocProvider.of<ListMetadataBloc>(context).state as ListLoaded)
                    .list)) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorPushTo(
              LoggedInHomePage.routeName,
            ),
          );
        }
      },
      child: BlocBuilder<ListItemsBloc, ListItemsState>(
        builder: (context, state) {
          if (state is ListItemsLoaded) {
            return SkyListBuilder(
              controller: _scrollController,
              hasReachedMax: state.hasReachedMax,
              items: state.items,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
