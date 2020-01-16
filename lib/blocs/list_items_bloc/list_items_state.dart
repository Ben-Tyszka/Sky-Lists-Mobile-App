import 'package:equatable/equatable.dart';

abstract class ListItemsState extends Equatable {
  const ListItemsState();
}

class InitialListItemsState extends ListItemsState {
  @override
  List<Object> get props => [];
}
