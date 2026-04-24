// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
// import 'package:get/get.dart';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
// import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view/widgets/estimate_dialog_printer.dart';
// import 'package:jewellery_erp_frontend_tab_version/model/printer/printer_connect_model.dart';
// import 'package:jewellery_erp_frontend_tab_version/utils/pos_printer/pos_thermal_printer.dart';

// class PrinterController extends GetxController with PosThermalPrinterUtils {
//   var defaultPrinterType = PrinterType.network;
//   final FocusNode ipFocusNode = FocusNode();
//   final FocusNode portFocusNode = FocusNode();

//   bool isBle = false;
//   bool reconnect = false;
//   bool isConnected = false;
//   bool isPrinterConnecting = false;

//   List<BluetoothPrinter> devices = [];
//   StreamSubscription<PrinterDevice>? subscription;
//   StreamSubscription<BTStatus>? subscriptionBtStatus;
//   StreamSubscription<USBStatus>? subscriptionUsbStatus;
//   BTStatus currentStatus = BTStatus.none;
//   USBStatus currentUsbStatus = USBStatus.none;
//   List<int>? pendingTask;
//   String ipAddress = '';
//   int port = 9100;
//   TextEditingController ipController = TextEditingController();
//   TextEditingController portController = TextEditingController();
//   BluetoothPrinter? selectedPrinter;

//   final RxBool includeGstInPrint = true.obs;
//   final RxBool vaInPercent = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     if (Platform.isWindows) defaultPrinterType = PrinterType.usb;

//     portController.text = port.toString();
//     scan();
//     _initializeSubscriptions();
//   }

//   void _initializeSubscriptions() {
//     subscriptionBtStatus =
//         PrinterManager.instance.stateBluetooth.listen((status) {
//       _handleBluetoothStatus(status);
//     });

//     subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
//       _handleUsbStatus(status);
//     });
//   }

//   void _handleBluetoothStatus(BTStatus status) {
//     currentStatus = status;
//     if (status == BTStatus.connected) {
//       isConnected = true;
//       update();
//     }
//     if (status == BTStatus.none) {
//       isConnected = false;
//       update();
//     }
//     if (status == BTStatus.connected && pendingTask != null) {
//       _processPendingBluetoothTask();
//     }
//   }

//   void _processPendingBluetoothTask() {
//     if (Platform.isAndroid) {
//       Future.delayed(const Duration(milliseconds: 1000), () {
//         printerManager.send(type: PrinterType.bluetooth, bytes: pendingTask!);
//         pendingTask = null;
//       });
//     } else if (Platform.isIOS) {
//       printerManager.send(type: PrinterType.bluetooth, bytes: pendingTask!);
//       pendingTask = null;
//     }
//   }

//   void _handleUsbStatus(USBStatus status) {
//     currentUsbStatus = status;
//     if (Platform.isAndroid) {
//       if (status == USBStatus.connected && pendingTask != null) {
//         Future.delayed(const Duration(milliseconds: 1000), () {
//           printerManager.send(type: PrinterType.usb, bytes: pendingTask!);
//           pendingTask = null;
//         });
//       }
//     }
//   }

//   void scan() {
//     devices.clear();
//     subscription = printerManager
//         .discovery(type: defaultPrinterType, isBle: isBle)
//         .listen((device) {
//       devices.add(BluetoothPrinter(
//         deviceName: device.name,
//         address: device.address,
//         isBle: isBle,
//         vendorId: device.vendorId,
//         productId: device.productId,
//         typePrinter: defaultPrinterType,
//       ));
//       update();
//     });
//   }

//   void setPort(String value) {
//     if (value.isEmpty) value = '9100';
//     port = int.tryParse(value) ?? 0;
//     _updateSelectedDevice();
//   }

//   void setIpAddress(String value) {
//     ipAddress = value;
//     _updateSelectedDevice();
//   }

//   void _updateSelectedDevice() {
//     var device = BluetoothPrinter(
//       deviceName: ipAddress,
//       address: ipAddress,
//       port: port,
//       typePrinter: PrinterType.network,
//       state: false,
//     );
//     selectDevice(device);
//   }

//   void selectDevice(BluetoothPrinter device) async {
//     if (selectedPrinter != null) {
//       if ((device.address != selectedPrinter!.address) ||
//           (device.typePrinter == PrinterType.usb &&
//               selectedPrinter!.vendorId != device.vendorId)) {
//         await printerManager.disconnect(type: selectedPrinter!.typePrinter);
//       }
//     }
//     selectedPrinter = device;
//     _updatePrinterConfiguration();
//     update();
//   }

//   void _updatePrinterConfiguration() {
//     if (selectedPrinter?.typePrinter == PrinterType.network) {
//       _configureNetworkPrinter();
//     } else if (selectedPrinter?.typePrinter == PrinterType.usb) {
//       _configureUsbPrinter();
//     } else {
//       _configureBluetoothPrinter();
//     }
//   }

//   void _configureNetworkPrinter() {
//     printer = PrinterConnectModel(
//       input: TcpPrinterInput(
//         ipAddress: selectedPrinter?.address ?? '',
//         port: selectedPrinter?.port ?? 9100,
//         paperSize: PaperSize.fromWidth(printer?.input.paperSize.value ?? 558),
//       ),
//       uuid: '',
//     );
//   }

//   void _configureUsbPrinter() {
//     printer = PrinterConnectModel(
//       input: UsbPrinterInput(
//         name: selectedPrinter?.deviceName,
//         vendorId: selectedPrinter?.vendorId,
//         productId: selectedPrinter?.productId,
//         paperSize: PaperSize.fromWidth(printer?.input.paperSize.value ?? 558),
//       ),
//       uuid: '',
//     );
//   }

//   void _configureBluetoothPrinter() {
//     printer = PrinterConnectModel(
//       input: BluetoothPrinterInput(
//         name: selectedPrinter?.deviceName ?? '',
//         address: selectedPrinter?.address ?? '',
//         paperSize: PaperSize.fromWidth(printer?.input.paperSize.value ?? 558),
//       ),
//       uuid: '',
//     );
//   }

//   void resetController() {
//     ipController.clear();
//     portController.clear();
//     selectedPrinter = null;
//     update();
//   }

//   @override
//   void dispose() {
//     subscription?.cancel();
//     subscriptionBtStatus?.cancel();
//     subscriptionUsbStatus?.cancel();
//     portController.dispose();
//     ipController.dispose();
//     ipFocusNode.dispose();
//     portFocusNode.dispose();
//     super.dispose();
//   }
// }
