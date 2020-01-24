import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/sky_list_share_with_page.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'package:sky_lists/utils/sky_list_page_arguments.dart';

class ShareListButton extends StatelessWidget {
  ShareListButton({
    @required this.user,
    @required this.list,
  });

  final FirebaseUser user;
  final ListMetadata list;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.share,
      ),
      onPressed: () {
        if (user.isEmailVerified) {
          BlocProvider.of<NavigatorBloc>(context).add(
            NavigatorPushTo(
              SkyListShareWithPage.routeName,
              arguments: SkyListPageArguments(list),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Please Verify Email'),
              content: Text(
                  'You must verify your email before you can share a list.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    user.sendEmailVerification();
                  },
                  child: Text('Resend Email'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
