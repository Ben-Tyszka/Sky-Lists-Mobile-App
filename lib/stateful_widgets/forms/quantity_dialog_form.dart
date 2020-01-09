import 'package:flutter/material.dart';

import 'package:sky_lists/models/sky_list_item.dart';
import 'package:sky_lists/presentational_widgets/quantity.dart';
import 'package:sky_lists/database_service.dart';

class QuantityDialogForm extends StatefulWidget {
  QuantityDialogForm({
    @required this.item,
  });

  final SkyListItem item;

  @override
  _QuantityDialogFormState createState() => _QuantityDialogFormState();
}

class _QuantityDialogFormState extends State<QuantityDialogForm> {
  TextEditingController _quantityController;
  final _db = DatabaseService();

  @override
  void initState() {
    _quantityController = TextEditingController(text: widget.item.descriptor);
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _onDescriptorChange(String value) {
    _db.setItemDescriptor(item: widget.item, descriptor: value);
  }

  void _onQuantityChange(String value) {
    _db.setItemQuantity(item: widget.item, quantity: value as int);
  }

  @override
  Widget build(BuildContext context) {
    return Quantity(
      onDescriptorChange: _onDescriptorChange,
      onQuantityChange: _onQuantityChange,
      quantityController: _quantityController,
      descriptor: widget.item.descriptor,
    );
  }
}
