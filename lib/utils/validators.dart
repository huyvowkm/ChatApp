import 'package:email_validator/email_validator.dart';

String? validateEmpty(String? value) {
  if(value == null || value.isEmpty) {
    return "Cannot be empty";
  }
  return null;
}

String? validateEmail(String? value) {
  return EmailValidator.validate(value ?? "") ? null : "Invalid email";
}