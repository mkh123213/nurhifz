import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  static TextInputFormatter digitsOnly() =>
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter lettersOnly() =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z؀-ۿ\s]'));

  static TextInputFormatter noSpaces() =>
      FilteringTextInputFormatter.deny(RegExp(r'\s'));

  static TextInputFormatter maxLength(int length) =>
      LengthLimitingTextInputFormatter(length);

  static TextInputFormatter decimal({int decimalPlaces = 2}) =>
      FilteringTextInputFormatter.allow(
        RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}'),
      );

  static TextInputFormatter phone() => _PhoneFormatter();

  static TextInputFormatter creditCard() => _CreditCardFormatter();
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9+]'), '');
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

class _CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
