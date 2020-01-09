import 'package:flutter/material.dart';

class Quantity extends StatelessWidget {
  Quantity({
    @required this.onDescriptorChange,
    @required this.onQuantityChange,
    @required this.quantityController,
    @required this.descriptor,
  });

  final _foodQuantityDescriptors = [
    '',
    'Bar',
  ];

  final void Function(String) onDescriptorChange;
  final void Function(String) onQuantityChange;
  final TextEditingController quantityController;
  final String descriptor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Quantity'),
      content: Form(
        child: Row(
          children: <Widget>[
            TextFormField(
              controller: this.quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                counterText: "",
                hintText: '',
                icon: Icon(Icons.shopping_cart),
              ),
              autocorrect: false,
              keyboardType: TextInputType.number,
              maxLength: 10000,
              onChanged: onQuantityChange,
            ),
            DropdownButton<String>(
              items: [
                for (final quantity in _foodQuantityDescriptors)
                  DropdownMenuItem(
                    child: Text(quantity),
                    value: quantity,
                  ),
              ],
              onChanged: onDescriptorChange,
              value: descriptor,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
