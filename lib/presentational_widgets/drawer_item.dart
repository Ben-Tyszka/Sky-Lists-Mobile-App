import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/navigator_bloc/bloc.dart';

class DrawerItem extends StatelessWidget {
  DrawerItem({this.routeName, this.icon, this.text});

  final String routeName;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: Theme.of(context).primaryTextTheme.bodyText2,
      ),
      selected: ModalRoute.of(context).settings.name == routeName,
      onTap: ModalRoute.of(context).settings.name == routeName
          ? () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPop(),
              );
            }
          : () {
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPop(),
              );
              BlocProvider.of<NavigatorBloc>(context).add(
                NavigatorPushTo(
                  routeName,
                ),
              );
            },
    );
  }
}
