import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_estimate/view_model/global_quick_estimate_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class BarcodeScannerDialog extends StatefulWidget {
  const BarcodeScannerDialog({super.key});

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog> {
  final BarcodeScannerDialogController controller =
      Get.find<BarcodeScannerDialogController>();

  @override
  void initState() {
    super.initState();
    // Request focus on the text field when the dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure text field gets focus immediately
      controller.barcodeFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Get.back(); // Close dialog on ESC
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: Get.width * 0.4,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildContent(),
              const SizedBox(height: 24),
              // _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText(
          text: 'Quick Barcode Scanner',
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.close, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Form(
      key: controller.formKey,
      child: TextFormField(
        controller: controller.barcodeController,
        autofocus: true, // Ensure autofocus is set
        focusNode: controller.barcodeFocusNode,
        decoration: const InputDecoration(
          labelText: 'Barcode',
          hintText: 'Scan or enter barcode',
          border: OutlineInputBorder(),
        ),
        validator: controller.validateBarcode,
        onFieldSubmitted: (_) => controller.scanAndPrintBarcode(),
        onChanged: (value) {
          String value = controller.barcodeController.text;
          int? barcodeNum = int.tryParse(value);
          log("barcode: $barcodeNum");

          if (barcodeNum != null && value.length >= 5) {
            controller.scanAndPrintBarcode();
          }
        },
      ),
    );
  }

  // Widget _buildFooter() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Obx(
  //         () => controller.isLoading.value
  //             ? const CircularProgressIndicator()
  //             : Material(
  //                 color: Colors.transparent,
  //                 child: InkWell(
  //                   onTap: controller.scanAndPrintBarcode,
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: Ink(
  //                     decoration: BoxDecoration(
  //                       color: primaryColor,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     height: 40,
  //                     width: 140,
  //                     child: Center(
  //                       child: ButtonShortcutWidget(
  //                         buttonName: "Print",
  //                         shortcut: "Enter",
  //                         buttonsize: 16,
  //                         color: whiteColor,
  //                         shortcutButtonColor: primaryColor,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //       ),
  //     ],
  //   );
  // }
}
