import 'package:flutter/material.dart';

class ItemTitle extends StatelessWidget {
  ItemTitle({
    @required this.onChanged,
    @required this.controller,
    @required this.onSubmit,
  });

  final void Function(String) onChanged;
  final void Function(String) onSubmit;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Item',
        counterText: '',
        border: InputBorder.none,
      ),
      maxLength: 100,
      onChanged: onChanged,
      controller: controller,
      onSubmitted: onSubmit,
    );
  }
}
