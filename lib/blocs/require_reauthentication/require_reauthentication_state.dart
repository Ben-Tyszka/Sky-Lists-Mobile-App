import 'package:meta/meta.dart';

@immutable
class RequireReauthenticationState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool hidePassword;
  final String failureMessage;

  bool get isFormValid => isEmailValid && isPasswordValid;

  RequireReauthenticationState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
    @required this.hidePassword,
  });

  factory RequireReauthenticationState.empty() {
    return RequireReauthenticationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory RequireReauthenticationState.loading() {
    return RequireReauthenticationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory RequireReauthenticationState.failure(String message) {
    return RequireReauthenticationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      hidePassword: true,
      failureMessage: message,
    );
  }

  factory RequireReauthenticationState.success() {
    return RequireReauthenticationState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  RequireReauthenticationState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool hidePassword,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: hidePassword,
      failureMessage: '',
    );
  }

  RequireReauthenticationState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool hidePassword,
    String failureMessage,
  }) {
    return RequireReauthenticationState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      hidePassword: hidePassword ?? this.hidePassword,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  String toString() {
    return '''RequireReauthenticationState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      hidePassword: $hidePassword,
      failureMessage: $failureMessage,
    }''';
  }
}
