import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class PrinterConnectModel {
  final String uuid;
  final BasePrinterInput input;

  PrinterType get printerType => input.printerType;

  const PrinterConnectModel({
    required this.input,
    required this.uuid,
  });
}
