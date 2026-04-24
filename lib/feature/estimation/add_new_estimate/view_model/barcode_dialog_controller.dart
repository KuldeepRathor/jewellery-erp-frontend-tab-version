import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/view_model/approval_issue_controller.dart';
import 'estimation_item_details_controller.dart';

class BarcodeDialogController extends GetxController {
  final itemCodeController = TextEditingController();
  final tagNumberController = TextEditingController();

  TextEditingController get tagNoController => tagNumberController;

  final itemCodeFocus = FocusNode();
  final tagFocus = FocusNode();

  FocusNode get tagNoFocus => tagFocus;

  void moveToTag() {
    FocusScope.of(Get.context!).requestFocus(tagFocus);
  }

  Future<void> submit() async {
    await submitItemDetails();
  }

  final debouncer = Debouncer(milliseconds: 500);

  Future<void> submitItemDetails() async {
    final estimationController = Get.find<EstimationItemDetailsController>();

    final index = estimationController.currentRowIndex.value;

    estimationController.controllers[index].code.text =
        itemCodeController.text.trim();

    estimationController.controllers[index].tagNo.text =
        tagNumberController.text.trim();

    Get.back();

    await estimationController.fetchTaggingLineItemCodeTag(index);

    itemCodeController.clear();
    tagNumberController.clear();
  }

  void clearItemCode() {
    itemCodeController.clear();
  }

  @override
  void onClose() {
    itemCodeController.dispose();
    tagNumberController.dispose();
    itemCodeFocus.dispose();
    tagFocus.dispose();
    super.onClose();
  }
}
