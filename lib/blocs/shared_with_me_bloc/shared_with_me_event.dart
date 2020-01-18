import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class SharedWithMeEvent extends Equatable {
  SharedWithMeEvent();

  @override
  List<Object> get props => [];
}

class LoadSharedWithMe extends SharedWithMeEvent {
  LoadSharedWithMe();

  @override
  List<Object> get props => [];
}

class SharedWithMeUpdated extends SharedWithMeEvent {
  final List<SharedWithMe> sharedWithMe;
  final bool hasReachedMax;

  SharedWithMeUpdated({
    this.hasReachedMax,
    this.sharedWithMe,
  });

  @override
  List<Object> get props => [
        hasReachedMax,
        sharedWithMe,
      ];
}

class EndStreams extends SharedWithMeEvent {
  EndStreams();

  @override
  List<Object> get props => [];
}
