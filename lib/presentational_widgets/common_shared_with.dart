import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_color/random_color.dart';

import 'package:sky_lists/blocs/commonly_shared_with_state.bloc/bloc.dart';

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
          return Column(
            children: <Widget>[
              Text(
                'Suggestions',
                style: Theme.of(context).primaryTextTheme.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              if (state.profiles.isEmpty) ...[
                Text(
                  'None at this time, use the app to generate suggestions',
                  style: Theme.of(context).primaryTextTheme.body1,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.profiles.length,
                  itemBuilder: (context, index) {
                    return ActionChip(
                      onPressed: () {},
                      label: Text(state.profiles[index].name),
                      backgroundColor: RandomColor().randomColor(),
                    );
                  },
                ),
              ],
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
