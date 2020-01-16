import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  ListTitle({
    @required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'List Name',
        counterText: '',
        filled: true,
        border: InputBorder.none,
      ),
      textAlign: TextAlign.center,
      maxLength: 100,
      controller: controller,
    );
  }
}
