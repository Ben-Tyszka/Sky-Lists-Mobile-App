import 'package:meta/meta.dart';

@immutable
class PublishListState {
  final bool isListNameValid;
  final bool isDescriptionValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String failureMessage;

  bool get isFormValid => isListNameValid && isDescriptionValid;

  PublishListState({
    @required this.isListNameValid,
    @required this.isDescriptionValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
  });

  factory PublishListState.empty() {
    return PublishListState(
      isListNameValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory PublishListState.loading() {
    return PublishListState(
      isListNameValid: true,
      isDescriptionValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  factory PublishListState.failure(String message) {
    return PublishListState(
      isListNameValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureMessage: message,
    );
  }

  factory PublishListState.success() {
    return PublishListState(
      isListNameValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      failureMessage: '',
    );
  }

  PublishListState update({
    bool isListNameValid,
    bool isDescriptionValid,
  }) {
    return copyWith(
      isListNameValid: isListNameValid,
      isDescriptionValid: isDescriptionValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: '',
    );
  }

  PublishListState copyWith({
    bool isListNameValid,
    bool isDescriptionValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return PublishListState(
      isListNameValid: isListNameValid ?? this.isListNameValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  String toString() {
    return '''PublishListState {
      isListNameValid: $isListNameValid,
      isDescriptionValid: $isDescriptionValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
    }''';
  }
}
