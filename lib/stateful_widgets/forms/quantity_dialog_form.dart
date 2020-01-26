import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/presentational_widgets/quantity.dart';

import 'package:list_items_repository/list_items_repository.dart';

class QuantityDialogForm extends StatefulWidget {
  QuantityDialogForm({
    @required this.item,
  });

  final ListItem item;

  @override
  _QuantityDialogFormState createState() => _QuantityDialogFormState();
}

class _QuantityDialogFormState extends State<QuantityDialogForm> {
  TextEditingController _quantityController;
  ListItem previousValue;
  StreamSubscription _streamSubscription;
  String descriptor;

  @override
  void initState() {
    _quantityController = TextEditingController(
        text: widget.item.quantity > 0 ? widget.item.quantity.toString() : '');
    descriptor = widget.item.descriptor;

    _quantityController.addListener(_onQuantityChange);
    _streamSubscription =
        BlocProvider.of<ListItemsBloc>(context).listen((state) {
      if (widget.item == null) return;
      if (state is ListItemsLoaded) {
        //Note: Not very efficient, esp. when dealing with large lists, needs to be worked on
        try {
          final selectedItem =
              state.items.where((_) => _.id == widget.item.id)?.first;
          if (!mounted || selectedItem == null) return;
          setState(() {
            previousValue = selectedItem;
            _quantityController.value = _quantityController.value
                .copyWith(text: selectedItem.quantity.toString());
            descriptor = selectedItem.descriptor;
          });
        } catch (_) {}
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  void _onDescriptorChange(String value) {
    if (descriptor == value) return;
    BlocProvider.of<ListItemsBloc>(context).add(
      UpdateListItem(
        widget.item.copyWith(
          descriptor: value,
          quantity: int.parse(_quantityController.text),
        ),
      ),
    );
  }

  void _onQuantityChange() {
    if (previousValue.quantity.toString() == _quantityController.text) return;
    BlocProvider.of<ListItemsBloc>(context).add(
      UpdateListItem(
        widget.item.copyWith(
          quantity: int.parse(_quantityController.text),
          descriptor: descriptor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Quantity(
      onDescriptorChange: _onDescriptorChange,
      quantityController: _quantityController,
      descriptor: descriptor,
    );
  }
}
