import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/model/approval_receipt_request.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_receipt/view_model/approval_receipt_party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';

class ApprovalReceiptController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final ApprovalReceiptItemDetailsController itemDetailsController =
      Get.put<ApprovalReceiptItemDetailsController>(
        ApprovalReceiptItemDetailsController(),
      );
  final ApprovalReceiptPartyDetailsController partyDetailsController =
      Get.put<ApprovalReceiptPartyDetailsController>(
        ApprovalReceiptPartyDetailsController(),
      );

  final RxBool isSubmitting = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final Rx<ApprovalReceiptRecordRequest?> submittedReceipt =
      Rx<ApprovalReceiptRecordRequest?>(null);

  final RxString remarks = ''.obs;

  Future<void> submitApprovalReceiptRecord() async {
    try {
      // Validate party selection
      if (partyDetailsController.selectedParty.value == null) {
        showErrorToast(message: 'Please select a party');
        return;
      }

      // Validate and clean up item details rows
      bool isItemDetailsValid =
          await itemDetailsController.validateAndCleanRows();
      if (!isItemDetailsValid) {
        showErrorToast(
          message:
              'Please add at least one valid item with Item Code and Tag No.',
        );
        return;
      }

      isSubmitting.value = true;
      errorMessage.value = null;

      final lineItems =
          itemDetailsController.controllers.map((item) {
            String hallMark =
                item.hall_mark.text.trim().isEmpty
                    ? "0.0"
                    : item.hall_mark.text;
            return LineItem(
              code: item.item_code.text,
              tag: item.tag_no.text,
              description: item.description.text,
              pieces: int.tryParse(item.pcs.text) ?? 0,
              grossWeight: item.gwt.text,
              netWeight: item.nwt.text,
              finalVa: item.va.text,
              finalMc: item.mc.text,
              stoneCost: item.stone.text,
              hallMark: hallMark,
              lineItemId: item.id,
              taggingVa: item.va.text,
              taggingMc: item.mc.text,
              taggingId: item.tagging_id,
            );
          }).toList();

      final date = partyDetailsController.selectedDate.value ?? DateTime.now();
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final request = ApprovalReceiptRecordRequest(
        lineItems: lineItems,
        partyId: partyDetailsController.selectedParty.value?.id ?? '',
        partyType:
            partyDetailsController.selectedParty.value is CustomerSearchValue
                ? 'customer'
                : 'vendor',
        receiptDate: formattedDate,
        remarks: remarks.value,
      );

      final response = await _inventoryRepository.submitApprovalReceiptRecord(
        request,
      );
      submittedReceipt.value = response;

      showSuccessToast(
        message: 'Approval receipt record submitted successfully',
      );

      clearControllers();
    } catch (e, s) {
      log("Error in submitApprovalReceiptRecord: $e\n$s");
      errorMessage.value =
          'Failed to submit approval receipt record: ${e.toString()}';
      showErrorToast(message: errorMessage.value!);
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearControllers() {
    submittedReceipt.value = null;
    errorMessage.value = null;
    remarks.value = '';
    itemDetailsController.clearControllers();
    partyDetailsController.clearControllers();
  }
}
