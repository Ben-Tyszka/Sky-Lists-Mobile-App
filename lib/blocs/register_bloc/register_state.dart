import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNameValid;
  final bool isAgreementsValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool hidePassword;
  final String failureMessage;

  bool get isFormValid =>
      isEmailValid &&
      isPasswordValid &&
      isAgreementsValid &&
      isNameValid &&
      isAgreementsValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isNameValid,
    @required this.isAgreementsValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.failureMessage,
    @required this.hidePassword,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isAgreementsValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isAgreementsValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  factory RegisterState.failure(String message) {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isAgreementsValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      hidePassword: true,
      failureMessage: message,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isNameValid: true,
      isAgreementsValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      hidePassword: true,
      failureMessage: '',
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isNameValid,
    bool isAgreementsValid,
    bool hidePassword,
    String failureMessage,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isNameValid: isNameValid,
      isAgreementsValid: isAgreementsValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      hidePassword: hidePassword,
      failureMessage: failureMessage,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isNameValid,
    bool isAgreementsValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool hidePassword,
    String failureMessage,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isAgreementsValid: isAgreementsValid ?? this.isAgreementsValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage ?? this.failureMessage,
      hidePassword: hidePassword ?? this.hidePassword,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isNameValid: $isNameValid,
      isAgreementsValid: $isAgreementsValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
      hidePassword: $hidePassword,
    }''';
  }
}
