import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/barcode_dialog_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';

class BarcodeDialogWidget extends StatefulWidget {
  const BarcodeDialogWidget({super.key});

  @override
  State<BarcodeDialogWidget> createState() => _BarcodeDialogWidgetState();
}

class _BarcodeDialogWidgetState extends State<BarcodeDialogWidget> {
  final controller = Get.put(BarcodeDialogController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.itemCodeFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.25,
      width: Get.width * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Quick Barcode Entry",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: redTextColor),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildTextFiled(
                  title: "Item Code",
                  controller: controller.itemCodeController,
                  focusNode: controller.itemCodeFocus,
                  onFieldSubmitted: (_) => controller.moveToTag(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextFiled(
                  title: "Tag No",
                  controller: controller.tagNoController,
                  focusNode: controller.tagNoFocus,
                  onFieldSubmitted: (_) => controller.submit(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFiled({
    required String title,
    required TextEditingController controller,
    Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 14, fontWeight: FontWeight.w700),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: (value) {
            // Only for Item Code field
            if (title == "Item Code") {
              final upperCaseValue = value.toUpperCase();
              final cursorPos = controller.selection.baseOffset;
              controller.value = TextEditingValue(
                text: upperCaseValue,
                selection: TextSelection.collapsed(offset: cursorPos),
              );

              int? barcodeNum = int.tryParse(value);
              log("barcode: $barcodeNum");

              if (barcodeNum != null) {
                final estimationController =
                    Get.find<EstimationItemDetailsController>();

                final index = estimationController.currentRowIndex.value;

                estimationController.debouncer.run(() {
                  estimationController.fetchTaggingLineItemByBarcode(
                    index,
                    value,
                  );
                  this.controller.clearItemCode();

                  Get.back();
                });
              }
            }
          },
        ),
      ],
    );
  }
}
