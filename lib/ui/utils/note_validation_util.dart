import 'package:flutter/services.dart';

class NoteValidationUtil {



  static const nameMaxLength = 60;
  static const mobileMaxLength = 10;
  static const titleMaxLength = 60;

  static List<TextInputFormatter> mobileInputFormatter = [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];

  static List<TextInputFormatter> nameInputFormatter = [
    LengthLimitingTextInputFormatter(nameMaxLength),
  ];

  static List<TextInputFormatter> titleInputFormatter = [
    LengthLimitingTextInputFormatter(titleMaxLength),
  ];

  static String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    if (value.length > titleMaxLength) {
      return 'Title should not exceed $titleMaxLength characters';
    }
    return null;
  }

  static String? patientMobileNumberValidator(String? value, {bool required = false}) {
    if (required && (value == null || value.isEmpty)) {
      return 'Patient mobile number is required';
    }
    if (value != null && value.isNotEmpty && value.length != mobileMaxLength) {
      return 'Mobile number should be $mobileMaxLength digits';
    }
    return null;

  }


  NoteValidationUtil._();
}
