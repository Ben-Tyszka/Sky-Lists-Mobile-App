import "package:validators/validators.dart";

bool validateEmail(String value) {
  return isEmail(value);
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
bool validatePhone(String value) {
  if (value.isEmpty) {
    return false;
  }

  return true;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
bool validatePassword(String value) {
  if (value.isEmpty || value.length < 6) {
    return false;
  }

  return true;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
bool validateName(String value) {
  if (value.isEmpty || value.length > 50) {
    return false;
  }

  return true;
}

/// Ensures consistant validation standards across app, takes in a [value] to validate
/// and returns a error [String]
String validateAgreements(bool value) {
  if (!value) {
    return "Please agree to terms and privacy policy";
  }

  return null;
}
