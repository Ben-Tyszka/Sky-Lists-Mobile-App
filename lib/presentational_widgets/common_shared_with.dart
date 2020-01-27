import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/commonly_shared_with_convert_to_user_profile_bloc/bloc.dart';
import 'package:sky_lists/blocs/commonly_shared_with_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/commonly_shared_with_chip.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class CommonSharedWith extends StatefulWidget {
  @override
  _CommonSharedWithState createState() => _CommonSharedWithState();
}

class _CommonSharedWithState extends State<CommonSharedWith> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonlySharedWithBloc, CommonlySharedWithState>(
      builder: (context, state) {
        if (state is CommonlySharedWithLoaded) {
          if (state.commonSharedWith.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Suggestions',
                  style: Theme.of(context).primaryTextTheme.title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.commonSharedWith.length,
                    itemBuilder: (context, index) {
                      return BlocProvider(
                        create: (_) =>
                            CommonlySharedWithConvertToUserProfileBloc(
                          listRepository:
                              Provider.of<FirebaseListMetadataRepository>(
                                  context),
                        )..add(
                                LoadCommonlySharedWithConvertToUserProfile(
                                  commonSharedWith:
                                      state.commonSharedWith[index],
                                ),
                              ),
                        child: CommonlySharedWithChip(),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
