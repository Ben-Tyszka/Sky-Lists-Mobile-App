import 'package:validators/validators.dart';

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validateEmail(String value) {
  if (value.isEmpty) {
    return 'Email is required';
  }

  if (!isEmail(value)) {
    return 'Invalid email';
  }

  return null;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validatePhone(String value) {
  if (value.isEmpty) {
    return 'Phone number is required';
  }

  return null;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 6) {
    return 'Password must be at least 7 characters';
  }
  return null;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validateFullName(String value) {
  if (value.isEmpty) {
    return 'Name is required';
  }

  if (value.length > 50) {
    return 'This name is too long';
  }

  return null;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validateAgreements(bool value) {
  if (!value) {
    return 'Please agree to terms and privacy policy';
  }

  return null;
}

String validateListName(String value) {
  if (value.isEmpty) {
    return 'List name cannot be empty';
  }

  return null;
}

String validateDescription(String value) {
  if (value.isEmpty) {
    return 'List description cannot be empty';
  }

  return null;
}
