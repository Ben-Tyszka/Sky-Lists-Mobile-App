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
