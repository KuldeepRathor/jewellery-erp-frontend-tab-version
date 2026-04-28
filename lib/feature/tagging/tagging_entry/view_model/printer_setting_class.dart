import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
import 'package:jewellery_erp_frontend_tab_version/model/printer/bluetooth_printer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:jewellery_erp_frontend_tab_version/model/printer/printer_connect_model.dart';

class PrinterSettings {
  // Singleton instance
  static PrinterSettings? _instance;

  // Factory constructor to return the singleton instance
  factory PrinterSettings() {
    _instance ??= PrinterSettings._internal();
    return _instance!;
  }

  // Private constructor for internal use
  PrinterSettings._internal() {
    loadSettings();
  }

  // Static method to get the instance
  static PrinterSettings get instance {
    _instance ??= PrinterSettings._internal();
    return _instance!;
  }

  // Default values for label printer
  static const String DEFAULT_PRINTER = 'GODEX G500';
  static const String DEFAULT_PORT = 'COM8';

  // Keys for label printer settings
  static const String PRINTER_KEY = 'printer_name';
  static const String PORT_KEY = 'scale_port';

  // Keys for thermal printer settings
  static const String THERMAL_PRINTER_TYPE_KEY = 'thermal_printer_type';
  static const String THERMAL_PRINTER_ADDRESS_KEY = 'thermal_printer_address';
  static const String THERMAL_PRINTER_PORT_KEY = 'thermal_printer_port';
  static const String THERMAL_PRINTER_NAME_KEY = 'thermal_printer_name';
  static const String THERMAL_PRINTER_VENDOR_ID_KEY =
      'thermal_printer_vendor_id';
  static const String THERMAL_PRINTER_PRODUCT_ID_KEY =
      'thermal_printer_product_id';
  static const String INCLUDE_GST_KEY = 'include_gst';
  static const String VA_IN_PERCENT_KEY = 'va_in_percent';

  // Observable values for label printer
  String printerName = DEFAULT_PRINTER;
  String scalePort = DEFAULT_PORT;

  // Thermal printer configuration
  PrinterType thermalPrinterType = PrinterType.network;
  String thermalPrinterAddress = '';
  int thermalPrinterPort = 9100;
  String thermalPrinterName = '';
  String? thermalPrinterVendorId;
  String? thermalPrinterProductId;

  // Print settings
  bool includeGstInPrint = true;
  bool vaInPercent = true;

  // Flag to track if settings are loaded
  bool _isInitialized = false;

  // Load saved settings
  Future<void> loadSettings() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load label printer settings
      printerName = prefs.getString(PRINTER_KEY) ?? DEFAULT_PRINTER;
      scalePort = prefs.getString(PORT_KEY) ?? DEFAULT_PORT;

      // Load thermal printer settings
      final printerTypeIndex = prefs.getInt(THERMAL_PRINTER_TYPE_KEY);
      if (printerTypeIndex != null) {
        thermalPrinterType = PrinterType.values[printerTypeIndex];
      }

      thermalPrinterAddress =
          prefs.getString(THERMAL_PRINTER_ADDRESS_KEY) ?? '';
      thermalPrinterPort = prefs.getInt(THERMAL_PRINTER_PORT_KEY) ?? 9100;
      thermalPrinterName = prefs.getString(THERMAL_PRINTER_NAME_KEY) ?? '';
      thermalPrinterVendorId = prefs.getString(THERMAL_PRINTER_VENDOR_ID_KEY);
      thermalPrinterProductId = prefs.getString(THERMAL_PRINTER_PRODUCT_ID_KEY);

      // Load print settings
      includeGstInPrint = prefs.getBool(INCLUDE_GST_KEY) ?? true;
      vaInPercent = prefs.getBool(VA_IN_PERCENT_KEY) ?? true;

      log('Loaded label printer settings: $printerName, $scalePort');
      log(
        'Loaded thermal printer settings: $thermalPrinterName $thermalPrinterType, $thermalPrinterAddress:$thermalPrinterPort',
      );

      _isInitialized = true;
    } catch (e) {
      // If loading fails, use defaults
      log('Failed to load printer settings: $e');
    }
  }

  // Save settings
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save label printer settings
      await prefs.setString(PRINTER_KEY, printerName);
      await prefs.setString(PORT_KEY, scalePort);

      // Save thermal printer settings
      await prefs.setInt(THERMAL_PRINTER_TYPE_KEY, thermalPrinterType.index);
      await prefs.setString(THERMAL_PRINTER_ADDRESS_KEY, thermalPrinterAddress);
      await prefs.setInt(THERMAL_PRINTER_PORT_KEY, thermalPrinterPort);

      if (thermalPrinterName.isNotEmpty) {
        await prefs.setString(THERMAL_PRINTER_NAME_KEY, thermalPrinterName);
      }

      if (thermalPrinterVendorId != null) {
        await prefs.setString(
          THERMAL_PRINTER_VENDOR_ID_KEY,
          thermalPrinterVendorId!,
        );
      }

      if (thermalPrinterProductId != null) {
        await prefs.setString(
          THERMAL_PRINTER_PRODUCT_ID_KEY,
          thermalPrinterProductId!,
        );
      }

      // Save print settings
      await prefs.setBool(INCLUDE_GST_KEY, includeGstInPrint);
      await prefs.setBool(VA_IN_PERCENT_KEY, vaInPercent);

      log('Saved label printer settings: $printerName, $scalePort');
      log(
        'Saved thermal printer settings: $thermalPrinterName $thermalPrinterType, $thermalPrinterAddress:$thermalPrinterPort',
      );
    } catch (e) {
      log('Failed to save printer settings: $e');
    }
  }

  // Update label printer name
  void updatePrinterName(String name) {
    if (name.isNotEmpty) {
      printerName = name;
    }
  }

  // Update scale port
  void updateScalePort(String port) {
    if (port.isNotEmpty) {
      scalePort = port;
    }
  }

  // Save thermal printer configuration from a BluetoothPrinter object
  void saveThermalPrinter(BluetoothPrinter printer) {
    thermalPrinterType = printer.typePrinter;
    thermalPrinterAddress = printer.address ?? '';
    thermalPrinterPort = printer.port ?? 9100;
    thermalPrinterVendorId = printer.vendorId;
    thermalPrinterProductId = printer.productId;

    if (printer.deviceName != null && printer.deviceName!.isNotEmpty) {
      thermalPrinterName = printer.deviceName!;
    }
  }

  // Update thermal printer settings
  void updateThermalPrinterSettings(bool includeGst, bool vaInPercent) {
    includeGstInPrint = includeGst;
    this.vaInPercent = vaInPercent;
  }

  // Create a PrinterConnectModel from the saved thermal printer settings
  PrinterConnectModel? createThermalPrinterModel() {
    BasePrinterInput input;

    switch (thermalPrinterType) {
      case PrinterType.bluetooth:
        input = BluetoothPrinterInput(
          name: thermalPrinterName,
          address: thermalPrinterAddress,
          paperSize: PaperSize.mm80,
        );
        break;
      case PrinterType.usb:
        input = UsbPrinterInput(
          name: thermalPrinterName,
          vendorId: thermalPrinterVendorId,
          productId: thermalPrinterProductId,
          paperSize: PaperSize.mm80,
        );
        break;
      case PrinterType.network:
        input = TcpPrinterInput(
          ipAddress: thermalPrinterAddress,
          port: thermalPrinterPort,
          paperSize: PaperSize.mm80,
        );
      // default:
      //   input = TcpPrinterInput(
      //     ipAddress: thermalPrinterAddress,
      //     port: thermalPrinterPort,
      //     paperSize: PaperSize.mm80,
      //   );
      //   break;
    }
    log("Returning printer ${input.toString()} $thermalPrinterType");
    return PrinterConnectModel(input: input, uuid: '');
  }

  // Check if we have previously saved a thermal printer
  bool hasThermalPrinterSaved() {
    if (thermalPrinterType == PrinterType.network) {
      return thermalPrinterAddress.isNotEmpty;
    } else if (thermalPrinterType == PrinterType.usb) {
      // return thermalPrinterVendorId != null && thermalPrinterProductId != null;
      return true;
    } else {
      return thermalPrinterAddress.isNotEmpty;
    }
  }

  // Create a virtual BluetoothPrinter object from saved settings
  // This can be used to match against discovered devices
  BluetoothPrinter? getSavedThermalPrinter() {
    if (!hasThermalPrinterSaved()) return null;

    return BluetoothPrinter(
      deviceName: thermalPrinterName,
      address: thermalPrinterAddress,
      port: thermalPrinterPort,
      vendorId: thermalPrinterVendorId,
      productId: thermalPrinterProductId,
      typePrinter: thermalPrinterType,
    );
  }
}
