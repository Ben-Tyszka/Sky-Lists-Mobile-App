import 'package:flutter/material.dart';

class BottomNavBarLoggedInPage extends StatelessWidget {
  BottomNavBarLoggedInPage({
    @required this.controller,
    @required this.onTabTapped,
  });

  final TabController controller;
  final Function onTabTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.index,
      onTap: onTabTapped,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
          ),
          title: Text('My Lists'),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.view_list,
          ),
          title: Text('Shared With Me'),
        ),
      ],
    );
  }
}
