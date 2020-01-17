import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class ShareListEvent extends Equatable {
  ShareListEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ShareListEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged $email';
}

class Submitted extends ShareListEvent {
  final String email;
  final ListMetadata list;

  Submitted({
    @required this.email,
    @required this.list,
  });

  @override
  List<Object> get props => [email, this.list];

  @override
  String toString() {
    return 'Submitted | email: $email, list:$list';
  }
}
