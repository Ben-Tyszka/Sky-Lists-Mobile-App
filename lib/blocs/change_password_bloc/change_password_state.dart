import 'package:meta/meta.dart';

@immutable
class ChangePasswordState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNewPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool hidePassword;
  final String failureMessage;

  bool get isFormValid => isEmailValid && isPasswordValid && isNewPasswordValid;

  ChangePasswordState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isNewPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
    @required this.hidePassword,
  });

  factory ChangePasswordState.empty() {
    return ChangePasswordState(
      isEmailValid: true,
      isPasswordValid: true,
      isNewPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory ChangePasswordState.loading() {
    return ChangePasswordState(
      isEmailValid: true,
      isPasswordValid: true,
      isNewPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory ChangePasswordState.failure(String message) {
    return ChangePasswordState(
      isEmailValid: true,
      isPasswordValid: true,
      isNewPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      hidePassword: true,
      failureMessage: message,
    );
  }

  factory ChangePasswordState.success() {
    return ChangePasswordState(
      isEmailValid: true,
      isPasswordValid: true,
      isNewPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  ChangePasswordState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isNewPasswordValid,
    bool hidePassword,
    String failureMessage,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isNewPasswordValid: isNewPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: hidePassword,
      failureMessage: failureMessage,
    );
  }

  ChangePasswordState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isNewPasswordValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool hidePassword,
    String failureMessage,
  }) {
    return ChangePasswordState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
      hidePassword: hidePassword ?? this.hidePassword,
    );
  }

  @override
  String toString() {
    return '''ChangePasswordState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isNewPasswordValid: $isNewPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
      hidePassword: $hidePassword,
    }''';
  }
}
