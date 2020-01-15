import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_meta_data_repository.dart';

abstract class ListMetadataState extends Equatable {
  ListMetadataState();

  @override
  List<Object> get props => [];
}

class ListMetadataLoading extends ListMetadataState {}

class ListMetadatasLoaded extends ListMetadataState {
  final List<ListMetadata> lists;

  ListMetadatasLoaded([this.lists = const []]);

  @override
  List<Object> get props => [lists];

  @override
  String toString() => 'ListMetadatasLoaded { lists: $lists }';
}

class ListMetadataNotLoaded extends ListMetadataState {}
