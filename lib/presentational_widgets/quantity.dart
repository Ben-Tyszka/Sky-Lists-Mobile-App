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
    'Cup',
    'Gallon',
    'Liter',
    'Barrel',
    'Piece',
    'Quart',
    'Serving',
    'Slice',
    'Loaf',
    'Stick',
    'Box',
    'Bottle',
    'Can',
    'Container',
    'Fl oz',
    'Jar',
    'kg',
    'lb',
    'ml',
    'Package',
    'Scoop',
    'Tblsp',
    'Tsp',
  ];

  final void Function(String) onDescriptorChange;
  final void Function(String) onQuantityChange;
  final TextEditingController quantityController;
  final String descriptor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Quantity',
        style: Theme.of(context).primaryTextTheme.title,
        textAlign: TextAlign.center,
      ),
      content: Form(
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                controller: this.quantityController,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Quantity',
                  isDense: true,
                  suffix: DropdownButton<String>(
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
                ),
                textAlign: TextAlign.center,
                autocorrect: false,
                keyboardType: TextInputType.number,
                maxLength: 1000,
                onChanged: onQuantityChange,
              ),
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
