import 'package:meta/meta.dart';

@immutable
class NameChangeState {
  final bool isNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String failureMessage;

  bool get isFormValid => isNameValid;

  NameChangeState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
    @required this.isNameValid,
  });

  factory NameChangeState.empty() {
    return NameChangeState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory NameChangeState.loading() {
    return NameChangeState(
      isNameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory NameChangeState.failure(String message) {
    return NameChangeState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureMessage: message,
    );
  }

  factory NameChangeState.success() {
    return NameChangeState(
      isNameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      failureMessage: '',
    );
  }

  NameChangeState update({
    bool isNameValid,
  }) {
    return copyWith(
      isNameValid: isNameValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  NameChangeState copyWith({
    bool isNameValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return NameChangeState(
      isNameValid: isNameValid ?? this.isNameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  String toString() {
    return '''NameChangeState {
      isNameValid: $isNameValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
    }''';
  }
}
