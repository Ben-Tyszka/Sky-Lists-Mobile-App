import "package:validators/validators.dart";

String validateEmail(String value) {
  if (value.isEmpty) {
    return "Email is required";
  }

  if (!isEmail(value)) {
    return "Invalid email";
  }

  return null;
}

String validatePhone(String value) {
  if (value.isEmpty) {
    return "Phone number is required";
  }

  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Password is required";
  }

  if (value.length < 6) {
    return "Password must be at least 7 characters";
  }
  return null;
}

String validateFullName(String value) {
  if (value.isEmpty) {
    return "Name is required";
  }

  if (value.length > 50) {
    return "This name is too long";
  }

  return null;
}
