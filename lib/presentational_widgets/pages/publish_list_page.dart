import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:publish_list_repository/publish_list_repository.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';
import 'package:sky_lists/blocs/publish_list_bloc/bloc.dart';

import 'package:sky_lists/stateful_widgets/forms/publish_list_form.dart';

import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class PublishListPage extends StatelessWidget {
  static final routeName = '/publish_list';

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Publish List'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorPop());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              BlocProvider(
                create: (_) => PublishListBloc(
                  publishListRepository: FirebasePublishListRepository(
                    (BlocProvider.of<AuthenticationBloc>(context).state
                            as Authenticated)
                        .user
                        .uid,
                    args.list,
                  ),
                ),
                child: PublishListForm(list: args.list),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
