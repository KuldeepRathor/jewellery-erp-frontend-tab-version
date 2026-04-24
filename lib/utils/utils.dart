// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_error_models/purchase_invoice_error_model.dart';
import 'package:toastification/toastification.dart';

String convertToFormattedDate(String inputDate) {
  try {
    DateTime parsedDate = DateFormat(
      "dd/MM/yyyy",
    ).parse(inputDate.replaceAll(' ', ''));
    return DateFormat("yyyy-MM-dd").format(parsedDate);
  } catch (e) {
    // Handle invalid format
    print('Date parsing error: $e');
    return '';
  }
}

Map<int, TableColumnWidth> getColumnWidths({
  required List<double> columnWidths,
  required BuildContext context,
}) {
  Map<int, TableColumnWidth> widths = {};
  for (int i = 0; i < columnWidths.length; i++) {
    widths[i] = FixedColumnWidth(
      (MediaQuery.of(context).size.width - 32) * (columnWidths[i] / 4),
    );
  }
  return widths;
}

double getColumnWidthForSingleTableCell({
  required double totalWidth,
  required double columnWidth,
}) {
  return (totalWidth) * (columnWidth / 4);
}

// PAN Number Validation Regex
final RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

// Function to validate PAN number
bool isValidPAN(String pan) {
  return panRegex.hasMatch(pan);
}

void showSuccessToast({required String message}) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
    ),
    autoCloseDuration: const Duration(seconds: 5),
    showProgressBar: false,
    alignment: Alignment.bottomCenter,
    icon: const Icon(Icons.check, color: Colors.white),
    primaryColor: Colors.green,
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(100),
  );
}

void showErrorToast({
  required String message,
  AlignmentGeometry? alignment = Alignment.bottomCenter,
}) {
  toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.fillColored,
    description: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
    ),
    title: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
    ),
    autoCloseDuration: const Duration(seconds: 5),
    showProgressBar: false,
    alignment: alignment,
    icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
    primaryColor: Colors.red,
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(100),
  );
}

void showInfoToast({
  required String message,
  AlignmentGeometry? alignment = Alignment.bottomCenter,
}) {
  toastification.show(
    type: ToastificationType.info,
    style: ToastificationStyle.fillColored,
    description: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
    ),
    title: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
    ),
    autoCloseDuration: const Duration(seconds: 5),
    showProgressBar: false,
    alignment: alignment,
    icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(100),
  );
}

DateTime? convertStringToDateTime(String dateString, {DateFormat? formatSent}) {
  // First, we'll define the expected date format
  final DateFormat format;
  if (formatSent == null) {
    format = DateFormat('dd/MM/yyyy');
  } else {
    format = formatSent;
  }

  try {
    // Attempt to parse the string into a DateTime object
    return format.parse(dateString);
  } catch (e) {
    // If parsing fails, print an error message and return null
    print('Error parsing date: $dateString. Error: $e');
    return null;
  }
}

String convertDateTimeToString(DateTime? dateTime) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  if (dateTime == null) {
    return "-";
  }
  return formatter.format(dateTime);
}

String convertDateTimeToTimeString(DateTime? dateTime) {
  final DateFormat formatter = DateFormat('h:mm a');
  if (dateTime == null) {
    return "-";
  }
  return formatter.format(dateTime);
}

KeyEventResult Function(FocusNode, KeyEvent, [List<FocusNode>])
onNormalKeyEvent = (node, event, [ignoreFocusNodes = const []]) {
  print("Normal key even called $node $ignoreFocusNodes");
  print(
    "Normal key even called primary focus ${FocusManager.instance.primaryFocus}",
  );
  if (ignoreFocusNodes.contains(FocusManager.instance.primaryFocus)) {
    print("Normal key even called inside Ignore $node $ignoreFocusNodes");
    return KeyEventResult.ignored;
  }
  print("Normal key even called outside Ignore $node $ignoreFocusNodes");
  if (event is KeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        print("I am here");
        return KeyEventResult.ignored;
      } else {
        node.nextFocus();
        print("I am here 12");
        return KeyEventResult.handled;
      }
    } else if (event.logicalKey == LogicalKeyboardKey.tab &&
        HardwareKeyboard.instance.isShiftPressed) {
      node.previousFocus();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.tab) {
      node.nextFocus();
      return KeyEventResult.handled;
    }
  }
  return KeyEventResult.ignored;
};
double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

ApiResponse<dynamic> handleDTOResponseErrors(Object error) {
  String message = "Something went wrong :";
  try {
    if (error is BadRequestException) {
      BadRequestException err = error;
      print("Runtime Type ${err.message.runtimeType}");
      print(err.message);
      log("Bad Request Exception ${err.message}");
      PurchaseInvoiceErrorResponse errorResponse =
          PurchaseInvoiceErrorResponse.fromJson(err.message);
      for (Detail element in errorResponse.detail ?? []) {
        message =
            "$message\n${element.loc?.last.toString() ?? ""} : ${element.msg}";
      }
    }
    return ApiResponse.error(message);
  } catch (e, s) {
    log("Error in handleDTOResponseErrors $e $s");
    return ApiResponse.error("Something went wrong");
  }
}

String formatCurrency(String? value) {
  if (value == null || value.isEmpty) return '-';
  // Remove quotes if present and convert to number
  final numValue = double.tryParse(value.replaceAll('"', ''));
  if (numValue == null) return '-';

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '',
    decimalDigits: 2,
  );
  return formatter.format(numValue);
}

FilteringTextInputFormatter numbersWithDecimalFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'));
bool isPhoneNumber(String input) {
  // Remove all common phone number separators
  String cleaned = input.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

  // If the cleaned string contains only digits and is between 7 and 15 characters
  // (covering most phone number lengths worldwide), it's likely a phone number
  bool isDigitsOnly = RegExp(r'^[0-9]+$').hasMatch(cleaned);
  bool isValidLength = cleaned.length >= 7 && cleaned.length <= 15;

  return isDigitsOnly && isValidLength;
}

void debugPrintObject(String label, dynamic obj) {
  try {
    log('$label: ${jsonEncode(obj)}');
  } catch (e) {
    log('$label: Could not encode object - $e');
    log('$label type: ${obj.runtimeType}');
  }
}
