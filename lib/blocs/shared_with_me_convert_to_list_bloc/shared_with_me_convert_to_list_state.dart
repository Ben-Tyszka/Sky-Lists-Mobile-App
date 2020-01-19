import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class SharedWithMeConvertToListState extends Equatable {
  SharedWithMeConvertToListState();

  @override
  List<Object> get props => [];
}

class SharedWithMeConvertToListLoading extends SharedWithMeConvertToListState {}

class SharedWithMeConvertToListLoaded extends SharedWithMeConvertToListState {
  final ListMetadata list;

  SharedWithMeConvertToListLoaded(
    this.list,
  );

  SharedWithMeConvertToListLoaded copyWith({
    UserProfile list,
  }) {
    return SharedWithMeConvertToListLoaded(
      list ?? this.list,
    );
  }

  @override
  List<Object> get props => [
        list,
      ];

  @override
  String toString() => 'SharedWithMeConvertToListLoaded | list: $list';
}

class SharedWithMeConvertToListNotLoaded
    extends SharedWithMeConvertToListState {}
