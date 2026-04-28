import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/settings/print_settings/view_model/printer_setting_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_int_button_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_text_field.dart';

class PrintSettingsConfigurationPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PrintSettingsConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PrinterSettingsController>(
        init: PrinterSettingsController(),
        builder: (controller) {
          if (controller.isLoadingSettings.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left panel - Label Printer configuration
                Expanded(
                  flex: 3,
                  child: _buildLabelPrinterPanel(context, controller),
                ),
                const SizedBox(width: 20),
                // Right panel - Thermal Printer configuration
                Expanded(
                  flex: 3,
                  child: _buildThermalPrinterPanel(context, controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabelPrinterPanel(
    BuildContext context,
    PrinterSettingsController controller,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Label Printer Configuration",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Printer Name
            CustomTextField(
              controller: TextEditingController(
                text: controller.printerSettings.printerName,
              ),
              name: 'Printer Name',
              prefixIcon: const Icon(Icons.print),
              hintText: 'Enter label printer name',
              onChanged: controller.printerSettings.updatePrinterName,
            ),

            const SizedBox(height: 16),

            // COM Port
            CustomTextField(
              controller: TextEditingController(
                text: controller.printerSettings.scalePort,
              ),
              name: 'Scale Port',
              prefixIcon: const Icon(Icons.settings_input_component),
              hintText: 'Enter COM port (e.g. COM8)',
              onChanged: controller.printerSettings.updateScalePort,
            ),

            const SizedBox(height: 24),

            // Selected Label Printer Info
            // _buildSelectedLabelPrinterInfo(controller),
            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: CustomInkButton(
                onPressed: () async {
                  await controller.printerSettings.saveSettings();
                  showSuccessToast(
                    message: "Label printer settings saved successfully",
                  );
                },
                text: "Save Label Printer Settings",
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSelectedLabelPrinterInfo(PrinterSettingsController controller) {
  //   // Only show this section if there's a label printer configured
  //   if (controller.printerSettings.printerName.isEmpty) {
  //     return const SizedBox.shrink();
  //   }

  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.green.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.green.shade300),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             const Icon(Icons.check_circle, color: Colors.green, size: 20),
  //             const SizedBox(width: 8),
  //             Text(
  //               "Currently Selected Label Printer",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.green.shade800,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           children: [
  //             const Icon(Icons.print, color: Colors.grey, size: 16),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: Text(
  //                 "Name: ${controller.printerSettings.printerName}",
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 4),
  //         Row(
  //           children: [
  //             const Icon(Icons.settings_input_component,
  //                 color: Colors.grey, size: 16),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: Text(
  //                 "Port: ${controller.printerSettings.scalePort}",
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildThermalPrinterPanel(
    BuildContext context,
    PrinterSettingsController controller,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thermal Receipt Printer",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Printer Type Selection
              _buildPrinterTypeDropdown(controller),
              const SizedBox(height: 16),

              // Selected Thermal Printer Info
              _buildSelectedThermalPrinterInfo(controller),
              const SizedBox(height: 16),

              // Device list or network config
              Expanded(
                child:
                    controller.isPrinterConnecting
                        ? const Center(child: CircularProgressIndicator())
                        : controller.defaultPrinterType == PrinterType.network
                        ? _buildNetworkFields(controller)
                        : _buildDevicesList(controller),
              ),

              // Print Settings
              // _buildPrintSettings(controller),
              const SizedBox(height: 16),

              // Action Buttons
              _buildActionButtons(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedThermalPrinterInfo(
    PrinterSettingsController controller,
  ) {
    // Only show this section if there's a thermal printer selected
    if (controller.selectedPrinter == null &&
        controller.thermalPrinter.printer == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade800,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "No thermal printer configured. Please select a printer.",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    // Use either the selected printer or the one from thermalPrinter instance
    final printer =
        controller.selectedPrinter ??
        controller.printerSettings.getSavedThermalPrinter();
    if (printer == null) return const SizedBox.shrink();

    // Determine connection type icon and text
    IconData connectionIcon;
    String connectionType;
    switch (printer.typePrinter) {
      case PrinterType.bluetooth:
        connectionIcon = Icons.bluetooth;
        connectionType = "Bluetooth";
        break;
      case PrinterType.usb:
        connectionIcon = Icons.usb;
        connectionType = "USB";
        break;
      case PrinterType.network:
        connectionIcon = Icons.wifi;
        connectionType = "Network";
        break;
      // default:
      //   connectionIcon = Icons.print;
      //   connectionType = "Unknown";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                "Currently Selected Thermal Printer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.print, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Name: ${printer.deviceName ?? 'Unknown'}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(connectionIcon, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Connection: $connectionType",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          if (printer.address != null && printer.address!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.link, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Address: ${printer.address}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
          if (printer.typePrinter == PrinterType.network &&
              printer.port != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.settings_ethernet,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Port: ${printer.port}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrinterTypeDropdown(PrinterSettingsController controller) {
    return DropdownButtonFormField<PrinterType>(
      value: controller.defaultPrinterType,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.print, size: 24),
        labelText: "Printer Connection Type",
        labelStyle: TextStyle(fontSize: 16.0),
        border: OutlineInputBorder(),
      ),
      items: <DropdownMenuItem<PrinterType>>[
        if (Platform.isAndroid || Platform.isIOS)
          const DropdownMenuItem(
            value: PrinterType.bluetooth,
            child: Text("Bluetooth"),
          ),
        if (Platform.isAndroid || Platform.isWindows)
          const DropdownMenuItem(value: PrinterType.usb, child: Text("USB")),
        const DropdownMenuItem(
          value: PrinterType.network,
          child: Text("WiFi/Network"),
        ),
      ],
      onChanged: (PrinterType? value) {
        if (value != null) {
          controller.defaultPrinterType = value;
          controller.isBle = false;
          controller.isConnected = false;
          controller.scan();
          controller.update();
        }
      },
    );
  }

  // Widget _buildPrintSettings(PrinterSettingsController controller) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Thermal Printer Settings",
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 12),

  //         // Settings Switches
  //         Row(
  //           children: [
  //             const Text('Include GST'),
  //             const Spacer(),
  //             Switch(
  //               value: controller.includeGstInPrint.value,
  //               activeColor: primaryBtnColor,
  //               onChanged: (value) {
  //                 controller.includeGstInPrint.value = value;
  //                 controller.update();
  //               },
  //             ),
  //           ],
  //         ),

  //         Row(
  //           children: [
  //             const Text('VA in Percentage'),
  //             const Spacer(),
  //             Switch(
  //               value: controller.vaInPercent.value,
  //               activeColor: primaryBtnColor,
  //               onChanged: (value) {
  //                 controller.vaInPercent.value = value;
  //                 controller.update();
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDevicesList(PrinterSettingsController controller) {
    if (controller.defaultPrinterType != PrinterType.bluetooth &&
        controller.defaultPrinterType != PrinterType.usb) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.defaultPrinterType == PrinterType.bluetooth
                  ? "Bluetooth Printers"
                  : "USB Printers",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                controller.scan();
              },
              tooltip: "Scan for devices",
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child:
              controller.devices.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.print_disabled,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No printers found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Make sure your printer is turned on and in range",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    itemCount: controller.devices.length,
                    separatorBuilder:
                        (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = controller.devices[index];
                      return ListTile(
                        title: Text(
                          device.deviceName ?? 'Unknown Device',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          device.address ?? 'No address',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing:
                            controller.selectedPrinter != null &&
                                    ((device.vendorId != null &&
                                            controller
                                                    .selectedPrinter!
                                                    .vendorId ==
                                                device.vendorId) ||
                                        (device.address != null &&
                                            controller
                                                    .selectedPrinter!
                                                    .address ==
                                                device.address))
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                : null,
                        onTap: () => controller.selectDevice(device),
                        tileColor:
                            controller.selectedPrinter != null &&
                                    ((device.vendorId != null &&
                                            controller
                                                    .selectedPrinter!
                                                    .vendorId ==
                                                device.vendorId) ||
                                        (device.address != null &&
                                            controller
                                                    .selectedPrinter!
                                                    .address ==
                                                device.address))
                                ? Colors.green.withOpacity(0.1)
                                : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildNetworkFields(PrinterSettingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Network Printer Configuration",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          focusNode: controller.ipFocusNode,
          controller: controller.ipController,
          name: 'IP Address',
          prefixIcon: const Icon(Icons.wifi),
          hintText: 'Enter IP address (e.g., 192.168.1.1)',
          onChanged: controller.setIpAddress,
          validator: (val) {
            final ipPattern = RegExp(
              r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$',
            );
            if (val == null || val.isEmpty) {
              return 'IP Address cannot be empty';
            } else if (!ipPattern.hasMatch(val)) {
              return 'Enter a valid IP Address';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          focusNode: controller.portFocusNode,
          controller: controller.portController,
          name: 'Port',
          prefixIcon: const Icon(Icons.settings_ethernet),
          hintText: 'Enter port (default: 9100)',
          keyboardType: TextInputType.number,
          onChanged: controller.setPort,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Port cannot be empty';
            } else if (int.tryParse(val) == null ||
                int.parse(val) < 1 ||
                int.parse(val) > 65535) {
              return 'Enter a valid port number (1-65535)';
            }
            return null;
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Make sure your printer is connected to the network and has a static IP address. Most thermal printers use port 9100.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(PrinterSettingsController controller) {
    return Row(
      children: [
        Expanded(
          child: CustomInkButton(
            onPressed: () async {
              // Test print functionality would go here
              await controller.testPrinter();
            },
            text: "Test Printer",
            backgroundColor: Colors.amber.shade700,
            textColor: Colors.white,
            // icon: const Icon(Icons.print_outlined, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomInkButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                if (controller.selectedPrinter != null) {
                  await controller.savePrinterSettings();
                  showSuccessToast(
                    message: "Thermal printer configured successfully",
                  );
                } else {
                  showErrorToast(message: "Please select a printer device");
                }
              }
            },
            text: "Save Configuration",
            backgroundColor: primaryColor,
            // icon: const Icon(Icons.save_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
