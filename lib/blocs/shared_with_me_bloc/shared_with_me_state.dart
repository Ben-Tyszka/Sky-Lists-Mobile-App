import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class SharedWithMeState extends Equatable {
  SharedWithMeState();

  @override
  List<Object> get props => [];
}

class SharedWithMeLoading extends SharedWithMeState {}

class SharedWithMeLoaded extends SharedWithMeState {
  final List<SharedWithMe> sharedWithMe;
  final bool hasReachedMax;

  SharedWithMeLoaded({
    this.sharedWithMe,
    this.hasReachedMax,
  });

  SharedWithMeLoaded copyWith({
    List<SharedWithMe> sharedWithMe,
    bool hasReachedMax,
  }) {
    return SharedWithMeLoaded(
      sharedWithMe: sharedWithMe ?? this.sharedWithMe,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        sharedWithMe,
        hasReachedMax,
      ];

  @override
  String toString() =>
      'SharedWithMeLoaded | sharedWithMe: $sharedWithMe, hasReachedMax: $hasReachedMax';
}

class SharedWithMeNotLoaded extends SharedWithMeState {}
