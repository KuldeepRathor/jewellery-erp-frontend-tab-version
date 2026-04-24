import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalTextInputFormatter({required this.decimalPlaces});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If text is being deleted, allow it
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    // Pattern: Optional minus sign, followed by digits,
    // optional decimal point and up to [decimalPlaces] digits
    String pattern = r'^-?\d*\.?\d{0,' + decimalPlaces.toString() + r'}$';

    if (RegExp(pattern).hasMatch(newValue.text)) {
      return newValue;
    }

    return oldValue;
  }
}

class WeightInputFormatter extends DecimalTextInputFormatter {
  WeightInputFormatter() : super(decimalPlaces: 3);
}

class AmountInputFormatter extends DecimalTextInputFormatter {
  AmountInputFormatter() : super(decimalPlaces: 2);
}
