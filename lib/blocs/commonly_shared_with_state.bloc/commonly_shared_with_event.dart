import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithEvent extends Equatable {
  CommonlySharedWithEvent();

  @override
  List<Object> get props => [];
}

class LoadCommonlySharedWith extends CommonlySharedWithEvent {}

class CommonlySharedWithUpdated extends CommonlySharedWithEvent {
  final List<UserProfile> profiles;

  CommonlySharedWithUpdated(this.profiles);

  @override
  List<Object> get props => [profiles];
}
