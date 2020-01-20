import 'package:equatable/equatable.dart';

abstract class SharedPermissionState extends Equatable {
  SharedPermissionState();

  @override
  List<Object> get props => [];
}

class SharedPermissionLoading extends SharedPermissionState {}

class SharedPermissionAllowed extends SharedPermissionState {}

class SharedPermissionNotAllowed extends SharedPermissionState {}

class SharedPermissionNotLoaded extends SharedPermissionState {}
