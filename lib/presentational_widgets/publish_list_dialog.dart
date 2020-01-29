import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:publish_list_repository/publish_list_repository.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/publish_list_bloc/bloc.dart';

import 'package:sky_lists/stateful_widgets/forms/publish_list_form.dart';

class PublishListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Publish List',
        style: Theme.of(context).primaryTextTheme.title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: <Widget>[
          Text(
            'Your list will be published. You can remove it at anytime.',
            style: Theme.of(context).primaryTextTheme.body1,
          ),
          BlocProvider(
            create: (_) => PublishListBloc(
              publishListRepository: FirebasePublishListRepository(
                (BlocProvider.of<AuthenticationBloc>(context).state
                        as Authenticated)
                    .user
                    .uid,
              ),
            ),
          ),
          PublishListForm(),
        ],
      ),
    );
  }
}
