import 'package:meta/meta.dart';

@immutable
class ShareListState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String failureMessage;

  bool get isFormValid => isEmailValid;

  ShareListState({
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
  });

  factory ShareListState.empty() {
    return ShareListState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory ShareListState.loading() {
    return ShareListState(
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory ShareListState.failure(String message) {
    return ShareListState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureMessage: message,
    );
  }

  factory ShareListState.success() {
    return ShareListState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      failureMessage: '',
    );
  }

  ShareListState update({
    bool isEmailValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  ShareListState copyWith({
    bool isEmailValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return ShareListState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  String toString() {
    return '''ShareListState {
      isEmailValid: $isEmailValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
    }''';
  }
}
