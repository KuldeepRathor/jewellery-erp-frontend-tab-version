import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:get/get.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/printer_setting_class.dart';
import 'package:jewellery_erp_frontend_tab_version/model/printer/bluetooth_printer_model.dart';
import 'package:jewellery_erp_frontend_tab_version/model/printer/printer_connect_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/pos_printer/pos_thermal_printer.dart';

import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'dart:developer';

class PrinterSettingsController extends GetxController {
  final PrinterManager printerManager = PrinterManager.instance;
  final PosThermalPrinter thermalPrinter = PosThermalPrinter();
  final PrinterSettings printerSettings = PrinterSettings();

  // Device discovery variables
  var defaultPrinterType = PrinterType.network;
  bool isBle = false;
  bool reconnect = false;
  bool isConnected = false;
  bool isPrinterConnecting = false;
  List<BluetoothPrinter> devices = [];
  BluetoothPrinter? selectedPrinter;

  // Network printer variables
  String ipAddress = '';
  int port = 9100;
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final FocusNode ipFocusNode = FocusNode();
  final FocusNode portFocusNode = FocusNode();

  // Print settings
  final RxBool includeGstInPrint = true.obs;
  final RxBool vaInPercent = true.obs;

  // Streams
  StreamSubscription<PrinterDevice>? _discoverySubscription;
  StreamSubscription<BTStatus>? _btStatusSubscription;
  StreamSubscription<USBStatus>? _usbStatusSubscription;
  BTStatus currentStatus = BTStatus.none;
  USBStatus currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;

  final RxBool isLoadingSettings = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSettings();
    _initializeSubscriptions();
    _setPlatformDefaults();
    scan();
  }

  void _initializeSettings() async {
    isLoadingSettings.value = true;
    // Load saved settings from PrinterSettings
    await printerSettings.loadSettings();

    // Apply saved thermal printer settings to the controller
    defaultPrinterType = printerSettings.thermalPrinterType;
    includeGstInPrint.value = printerSettings.includeGstInPrint;
    vaInPercent.value = printerSettings.vaInPercent;

    // Initialize network printer fields if applicable
    if (defaultPrinterType == PrinterType.network) {
      ipAddress = printerSettings.thermalPrinterAddress;
      port = printerSettings.thermalPrinterPort;
      ipController.text = ipAddress;
      portController.text = port.toString();
    }

    // Try to restore the previously saved printer
    BluetoothPrinter? savedPrinter = printerSettings.getSavedThermalPrinter();
    if (savedPrinter != null) {
      selectedPrinter = savedPrinter;

      // If it's a network printer, we can set it up immediately
      if (defaultPrinterType == PrinterType.network && ipAddress.isNotEmpty) {
        _updatePrinterConfiguration();
      }
      // For Bluetooth and USB, we'll need to wait for device discovery to confirm
    }

    // Apply settings to thermal printer
    // thermalPrinter.includeGstInPrint = includeGstInPrint.value;
    // thermalPrinter.vaInPercent = vaInPercent.value;

    // Try to apply saved printer configuration if available
    PrinterConnectModel? savedPrinterModel =
        printerSettings.createThermalPrinterModel();
    if (savedPrinterModel != null) {
      thermalPrinter.printer = savedPrinterModel;
    }

    log(
      "Initialized printer settings from saved configuration ${selectedPrinter?.deviceName}",
    );
    isLoadingSettings.value = false;
  }

  void _setPlatformDefaults() {
    // Only set defaults if no saved printer type exists
    if (selectedPrinter == null) {
      // Set default printer type based on platform
      if (Platform.isWindows) {
        defaultPrinterType = PrinterType.usb;
      } else if (Platform.isAndroid || Platform.isIOS) {
        defaultPrinterType = PrinterType.bluetooth;
      } else {
        defaultPrinterType = PrinterType.network;
      }
    }
  }

  void _initializeSubscriptions() {
    _btStatusSubscription = printerManager.stateBluetooth.listen((status) {
      _handleBluetoothStatus(status);
    });

    _usbStatusSubscription = printerManager.stateUSB.listen((status) {
      _handleUsbStatus(status);
    });
  }

  void _handleBluetoothStatus(BTStatus status) {
    currentStatus = status;
    if (status == BTStatus.connected) {
      isConnected = true;
      update();
    }
    if (status == BTStatus.none) {
      isConnected = false;
      update();
    }
    if (status == BTStatus.connected && pendingTask != null) {
      _processPendingBluetoothTask();
    }
  }

  void _processPendingBluetoothTask() {
    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        printerManager.send(type: PrinterType.bluetooth, bytes: pendingTask!);
        pendingTask = null;
      });
    } else if (Platform.isIOS) {
      printerManager.send(type: PrinterType.bluetooth, bytes: pendingTask!);
      pendingTask = null;
    }
  }

  void _handleUsbStatus(USBStatus status) {
    currentUsbStatus = status;
    if (Platform.isAndroid) {
      if (status == USBStatus.connected && pendingTask != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          printerManager.send(type: PrinterType.usb, bytes: pendingTask!);
          pendingTask = null;
        });
      }
    }
  }

  void scan() {
    devices.clear();
    update();
    _discoverySubscription?.cancel();

    _discoverySubscription = printerManager
        .discovery(type: defaultPrinterType, isBle: isBle)
        .listen((device) {
          // Add device to the list
          BluetoothPrinter bluetoothPrinter = BluetoothPrinter(
            deviceName: device.name,
            address: device.address,
            isBle: isBle,
            vendorId: device.vendorId,
            productId: device.productId,
            typePrinter: defaultPrinterType,
          );

          devices.add(bluetoothPrinter);

          update();
        });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    port = int.tryParse(value) ?? 9100;
    _updateSelectedNetworkDevice();
  }

  void setIpAddress(String value) {
    ipAddress = value;
    _updateSelectedNetworkDevice();
  }

  void _updateSelectedNetworkDevice() {
    var device = BluetoothPrinter(
      deviceName: ipAddress,
      address: ipAddress,
      port: port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(BluetoothPrinter device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await printerManager.disconnect(type: selectedPrinter!.typePrinter);
      }
    }
    selectedPrinter = device;

    _updatePrinterConfiguration();
    update();
  }

  void _updatePrinterConfiguration() {
    if (selectedPrinter == null) return;
    log(
      "Thermal printer : ${selectedPrinter!.typePrinter} ${selectedPrinter!.deviceName}",
    );
    // First update the thermal printer with the selected device
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.network:
        _configureNetworkPrinter();
        break;
      case PrinterType.usb:
        _configureUsbPrinter();
        break;
      case PrinterType.bluetooth:
        _configureBluetoothPrinter();
        break;
      // default:
      //   break;
    }

    // Also save to PrinterSettings for persistence
    printerSettings.saveThermalPrinter(selectedPrinter!);
    printerSettings.updateThermalPrinterSettings(
      includeGstInPrint.value,
      vaInPercent.value,
    );
  }

  void _configureNetworkPrinter() {
    thermalPrinter.printer = PrinterConnectModel(
      input: TcpPrinterInput(
        ipAddress: selectedPrinter?.address ?? '',
        port: selectedPrinter?.port ?? 9100,
        paperSize: PaperSize.mm80,
      ),
      uuid: '',
    );
  }

  void _configureUsbPrinter() {
    thermalPrinter.printer = PrinterConnectModel(
      input: UsbPrinterInput(
        name: selectedPrinter?.deviceName,
        vendorId: selectedPrinter?.vendorId,
        productId: selectedPrinter?.productId,
        paperSize: PaperSize.mm80,
      ),
      uuid: '',
    );
  }

  void _configureBluetoothPrinter() {
    thermalPrinter.printer = PrinterConnectModel(
      input: BluetoothPrinterInput(
        name: selectedPrinter?.deviceName ?? '',
        address: selectedPrinter?.address ?? '',
        paperSize: PaperSize.mm80,
      ),
      uuid: '',
    );
  }

  Future<void> savePrinterSettings() async {
    // Update print settings
    printerSettings.updateThermalPrinterSettings(
      includeGstInPrint.value,
      vaInPercent.value,
    );

    // If a printer is selected, save it
    if (selectedPrinter != null) {
      printerSettings.saveThermalPrinter(selectedPrinter!);
    }

    // Save all settings
    await printerSettings.saveSettings();

    // Apply settings to the thermal printer
    // thermalPrinter.includeGstInPrint = includeGstInPrint.value;
    // thermalPrinter.vaInPercent = vaInPercent.value;

    // // Register thermal printer in GetX for global access
    // if (!Get.isRegistered<PosThermalPrinter>()) {
    //   Get.put<PosThermalPrinter>(thermalPrinter, permanent: true);
    // } else {
    //   // Update the existing instance
    //   Get.find<PosThermalPrinter>().printer = thermalPrinter.printer;
    //   Get.find<PosThermalPrinter>().includeGstInPrint = includeGstInPrint.value;
    //   Get.find<PosThermalPrinter>().vaInPercent = vaInPercent.value;
    // }

    log("Printer settings saved successfully");
  }

  void resetController() {
    ipController.clear();
    portController.clear();
    selectedPrinter = null;
    update();
  }

  // This function can be called by the dialog's print button
  Future<void> printWithSelectedDevice(Function printFunction) async {
    try {
      isPrinterConnecting = true;
      update();

      // Make sure the printer settings are applied
      // thermalPrinter.includeGstInPrint = includeGstInPrint.value;
      // thermalPrinter.vaInPercent = vaInPercent.value;

      // Call the print function (passed from the dialog)
      await printFunction();

      // Save the settings for future use
      await savePrinterSettings();
    } catch (e) {
      showErrorToast(message: "Printing error: $e");
    } finally {
      isPrinterConnecting = false;
      update();
    }
  }

  Future<void> testPrinter() async {
    try {
      isPrinterConnecting = true;
      update();

      if (selectedPrinter == null && thermalPrinter.printer == null) {
        showErrorToast(
          message: "No printer selected. Please configure a printer first.",
        );
        return;
      }

      // Create test page
      List<int> bytes = await _generateTestPrintPage();

      // Get the current printer from either selection or saved config
      PrinterConnectModel? printerToUse = thermalPrinter.printer;

      if (printerToUse == null) {
        showErrorToast(message: "Printer configuration is invalid");
        return;
      }

      // Connect and print
      bool connected = await _checkConnection(input: printerToUse.input);
      if (connected) {
        await _sendBytesToPrint(bytes, printerToUse.input.printerType);
        showSuccessToast(message: "Test page printed successfully");
      } else {
        showErrorToast(message: "Failed to connect to printer");
      }
    } catch (e) {
      log("Test print error: $e");
      showErrorToast(message: "Error printing test page: $e");
    } finally {
      isPrinterConnecting = false;
      update();
    }
  }

  Future<List<int>> _generateTestPrintPage() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Printer type name
    String connectionType = "Unknown";
    switch (selectedPrinter?.typePrinter ?? defaultPrinterType) {
      case PrinterType.bluetooth:
        connectionType = "Bluetooth";
        break;
      case PrinterType.usb:
        connectionType = "USB";
        break;
      case PrinterType.network:
        connectionType = "Network";
        break;
      // default:
      //   connectionType = "Unknown";
    }

    // Add header
    bytes += generator.text(
      'PRINTER TEST PAGE',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    // Add date and time
    final now = DateTime.now();
    final dateStr = "${now.day}-${now.month}-${now.year}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    bytes += generator.text(
      '$dateStr $timeStr',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr();

    // Printer details
    bytes += generator.text(
      'PRINTER DETAILS',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // Name and connection info
    bytes += generator.row([
      PosColumn(width: 4, text: 'Name:'),
      PosColumn(width: 8, text: selectedPrinter?.deviceName ?? "Unknown"),
    ]);

    bytes += generator.row([
      PosColumn(width: 4, text: 'Type:'),
      PosColumn(width: 8, text: connectionType),
    ]);

    if (selectedPrinter?.address != null &&
        selectedPrinter!.address!.isNotEmpty) {
      bytes += generator.row([
        PosColumn(width: 4, text: 'Address:'),
        PosColumn(width: 8, text: selectedPrinter?.address ?? ""),
      ]);
    }

    if (selectedPrinter?.typePrinter == PrinterType.network &&
        selectedPrinter?.port != null) {
      bytes += generator.row([
        PosColumn(width: 4, text: 'Port:'),
        PosColumn(width: 8, text: selectedPrinter?.port.toString() ?? "9100"),
      ]);
    }

    bytes += generator.hr();

    // Print settings
    bytes += generator.text(
      'PRINT SETTINGS',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.row([
      PosColumn(width: 8, text: 'Include GST:'),
      PosColumn(width: 4, text: includeGstInPrint.value ? 'Yes' : 'No'),
    ]);

    bytes += generator.row([
      PosColumn(width: 8, text: 'VA in Percentage:'),
      PosColumn(width: 4, text: vaInPercent.value ? 'Yes' : 'No'),
    ]);

    bytes += generator.hr();

    // Test patterns
    bytes += generator.text(
      'FONT STYLES',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text('Normal text');

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));

    bytes += generator.text(
      'Underlined text',
      styles: const PosStyles(underline: true),
    );

    bytes += generator.text(
      'Normal Align Left',
      styles: const PosStyles(align: PosAlign.left),
    );

    bytes += generator.text(
      'Center Aligned Text',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text(
      'Right Aligned Text',
      styles: const PosStyles(align: PosAlign.right),
    );

    bytes += generator.text(
      'Different size',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.hr();

    // Barcode
    bytes += generator.text(
      'BARCODE TEST',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.barcode(
      Barcode.code39(['T', 'E', 'S', 'T']),
      height: 50,
      width: 2,
      textPos: BarcodeText.below,
    );

    bytes += generator.hr();

    // Footer
    bytes += generator.text(
      'If you can read this,',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text(
      'your printer is working correctly!',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(3);
    bytes += generator.cut();

    return bytes;
  }

  Future<bool> _checkConnection({required BasePrinterInput input}) async {
    bool connected = false;
    try {
      connected = await printerManager.connect(
        type: input.printerType,
        model: input,
      );
      log("Printer connection status: $connected");
    } catch (e) {
      log("Connection error: $e");
      connected = false;
    }
    return connected;
  }

  Future<void> _sendBytesToPrint(List<int> bytes, PrinterType type) async {
    await printerManager.send(type: type, bytes: bytes);
    await printerManager.disconnect(type: type);
  }

  @override
  void dispose() {
    _discoverySubscription?.cancel();
    _btStatusSubscription?.cancel();
    _usbStatusSubscription?.cancel();
    portController.dispose();
    ipController.dispose();
    ipFocusNode.dispose();
    portFocusNode.dispose();
    super.dispose();
  }
}
