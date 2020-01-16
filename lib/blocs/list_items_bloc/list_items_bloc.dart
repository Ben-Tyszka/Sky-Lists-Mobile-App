import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ListItemsBloc extends Bloc<ListItemsEvent, ListItemsState> {
  @override
  ListItemsState get initialState => InitialListItemsState();

  @override
  Stream<ListItemsState> mapEventToState(
    ListItemsEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
