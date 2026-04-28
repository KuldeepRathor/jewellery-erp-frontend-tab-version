import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/printer_setting_class.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/barcode_template/model/barcode_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/vinayak_godex_printer/label_printer_class_stub.dart'
    if (dart.library.io) 'package:jewellery_erp_frontend_tab_version/utils/vinayak_godex_printer/label_printer_class.dart';

class ReTagController extends GetxController {
  // Text controllers
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();

  // Repository
  final InventoryRepository _inventoryRepository = Get.put<InventoryRepository>(
    InventoryRepository(),
  );

  final Rx<GetTaggingLineItemCodeTagResponse> tagData =
      GetTaggingLineItemCodeTagResponse().obs;

  // UI state variables
  final RxBool isLoading = false.obs;
  final RxBool hasData = false.obs;
  final RxList<String> images = <String>[].obs;

  // Printer related
  final PrinterSettings printerSettings = PrinterSettings();
  final RxBool isPrintingEnabled = true.obs;
  final Rx<TextEditingController> printCopiesController =
      TextEditingController(text: '1').obs;
  Uint8List? pdf;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Function? onClearCallback;

  @override
  void onInit() {
    super.onInit();
    printerSettings.loadSettings();
  }

  void clearFields() {
    tagData.value = GetTaggingLineItemCodeTagResponse();
    images.clear();
    hasData.value = false;
  }

  void clearAll() {
    tagNoController.clear();
    itemCodeController.clear();
    clearFields();
    if (onClearCallback != null) {
      onClearCallback!();
    }
  }

  Future<void> postTaggingLineItemReTag() async {
    try {
      if (!hasData.value) {
        showErrorToast(message: "Please fetch item details first");
        return;
      }

      final taggingLineItemId = tagData.value.id;
      if (taggingLineItemId == null || taggingLineItemId.isEmpty) {
        showErrorToast(message: "Invalid tagging line item ID");
        return;
      }

      await _inventoryRepository.postTaggingLineItemReTag(taggingLineItemId);

      showSuccessToast(message: "Item has been retagged successfully");
    } catch (e) {
      log('Error in postTaggingLineItemReTag: $e');
      showErrorToast(message: 'Failed to retag item: $e');
    }
  }

  Future<void> fetchTaggingDetails() async {
    try {
      // Validate form fields if form key is present
      if (formKey.currentState != null) {
        if (!formKey.currentState!.validate()) {
          return;
        }
      }

      final itemCode = itemCodeController.text;
      final tagNumber = int.tryParse(tagNoController.text);

      if (itemCode.isEmpty || tagNumber == null) {
        showErrorToast(message: "Please enter valid item code and tag number");
        return;
      }

      isLoading.value = true;
      clearFields();

      log(
        'Fetching tagging details for itemCode: $itemCode, tagNumber: $tagNumber',
      );

      final response = await _inventoryRepository.getTaggingLineItemCodeTag(
        itemCode,
        tagNumber,
      );

      log('API Response received');
      log('API Response status: ${response.status}');

      // Debug logging
      if (response.design != null) {
        log('Design name: ${response.design?.name}');
      } else {
        log('Design is null');
      }

      if (response.design?.stockHead != null) {
        try {
          debugPrintObject('StockHead', response.design?.stockHead?.toJson());
        } catch (e) {
          log('Error serializing StockHead: $e');
        }
      }

      // Check availability status
      if (response.status == null ||
          response.status?.toLowerCase() != "available") {
        showErrorToast(message: "This Item is not available");
        isLoading.value = false;
        return;
      }

      // Store the entire response model
      tagData.value = response;

      // Process images separately (as it's a combined list from multiple sources)
      try {
        List<String> combinedImages = [];

        // Add images from response if available
        if (response.images != null) {
          for (var image in response.images!) {
            if (image.presignedUrl != null && image.presignedUrl!.isNotEmpty) {
              combinedImages.add(image.presignedUrl!);
            }
          }
        }

        // Add images from design if available
        if (response.design?.images != null) {
          for (var image in response.design!.images!) {
            if (image.presignedUrl != null && image.presignedUrl!.isNotEmpty) {
              combinedImages.add(image.presignedUrl!);
            }
          }
        }

        images.value = combinedImages;
      } catch (e) {
        log('Error processing images: $e');
        images.value = [];
      }

      hasData.value = true;
      isLoading.value = false;
    } catch (e) {
      log('Error fetching tagging details: $e');
      showErrorToast(message: "Error fetching item details");
      isLoading.value = false;
    }
  }

  void submitReTag() {
    if (!hasData.value) {
      showErrorToast(message: "Please fetch item details first");
      return;
    }

    showSuccessToast(message: "Item has been retagged successfully");
  }

  Future<void> printBarcode() async {
    if (!hasData.value) {
      showErrorToast(message: "Please fetch item details first");
      return;
    }

    try {
      // Create barcode model with item details
      BarcodeModel barcodeData = BarcodeModel(
        weight: tagData.value.netWeight ?? '',
        itemCode: '${itemCodeController.text} ${tagNoController.text}',
        itemName: tagData.value.design?.name ?? '',
        purity: tagData.value.purity ?? '',
        barCode: tagData.value.tagBarcode ?? "",
        weightGroup: getWeightGroupName(),
        showNumber: true,
        fontFamily: 'Roboto',
        count: int.tryParse(printCopiesController.value.text) ?? 1,
      );

      // Check if printing is enabled
      if (isPrintingEnabled.value) {
        log("Printing barcode with tag: ${tagData.value.tagBarcode}");

        // Generate PDF for barcode
        pdf = await _inventoryRepository.getBarCodePrint(detail: barcodeData);

        // Initialize printer and talker
        final talker = Get.find<TalkerController>().talker;
        final printer = GodexG500Printer(
          logger: talker,
          selectedPrinter: printerSettings.printerName,
        );

        // Create label configuration
        final labelConfig = LabelConfig(
          weight: tagData.value.netWeight ?? "",
          tagNumber: '${itemCodeController.text}-${tagNoController.text}',
          grossWeight: "GWT : ${tagData.value.grossWeight ?? ""}",
          purity: tagData.value.purity ?? "",
          size: getSizeValue(),
          qrCode1: barcodeData.barCode,
          qrCode2: barcodeData.barCode,
          vendorId: tagData.value.vendorCode ?? "",
        );

        try {
          // Print the label using the printer
          await printer.printLabel(labelConfig);
          log("Label printed successfully");
          showSuccessToast(message: 'Label printed successfully');
          clearAll();
        } catch (e) {
          talker.error(
            'Error printing label with printer ${printerSettings.printerName}: $e',
          );
          showErrorToast(message: 'Failed to print label: $e');
          rethrow;
        }
      } else {
        showErrorToast(message: 'Printing is disabled');
      }
    } catch (e) {
      log('Error in printBarcode: $e');
      showErrorToast(message: 'Failed to generate or print barcode: $e');
    }
  }

  // Helper method to get weight group name from the model
  String getWeightGroupName() {
    if (tagData.value.design?.stockHead?.weightGroups != null &&
        tagData.value.design!.stockHead!.weightGroups!.isNotEmpty) {
      return tagData.value.design!.stockHead!.weightGroups!.first.name ??
          '10-100';
    }
    return '10-100';
  }

  // Helper method to get size value from the model
  String getSizeValue() {
    if (tagData.value.sizeGroup != null &&
        tagData.value.sizeGroup!.size != null) {
      return tagData.value.sizeGroup!.size!;
    }
    return '8';
  }

  // Helper method to get stone details as a string
  String getStoneDetailsFormatted() {
    if (tagData.value.lineStones != null &&
        tagData.value.lineStones!.isNotEmpty) {
      return tagData.value.lineStones!.first.name ?? '--';
    }
    return '--';
  }

  Future<void> openPrinterSettings() async {
    await Get.dialog(
      AlertDialog(
        title: const Text(
          'Printer Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Print copies
              const Text('Print Copies'),
              const SizedBox(height: 8),
              TextField(
                controller: printCopiesController.value,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Printer name
              const Text('Printer Name'),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(
                  text: printerSettings.printerName,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (value) => printerSettings.updatePrinterName(value),
              ),
              const SizedBox(height: 16),

              // Scale port
              const Text('Scale Port'),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(
                  text: printerSettings.scalePort,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (value) => printerSettings.updateScalePort(value),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              printerSettings.saveSettings();
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
