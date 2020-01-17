import 'package:flutter/material.dart';

class Quantity extends StatelessWidget {
  Quantity({
    @required this.onDescriptorChange,
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
                controller: quantityController,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Quantity',
                  isDense: true,
                  suffix: DropdownButton<String>(
                    items: [
                      for (final quantity in _foodQuantityDescriptors)
                        DropdownMenuItem(
                          child: quantityController.text.isEmpty
                              ? Text(quantity)
                              : Text(
                                  '$quantity${int.parse(quantityController.text) > 1 && descriptor.isNotEmpty && descriptor != 'Tsp' && descriptor != 'Tblsp' && descriptor != 'ml' && descriptor != 'Fl oz' ? 's' : ''}'),
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
