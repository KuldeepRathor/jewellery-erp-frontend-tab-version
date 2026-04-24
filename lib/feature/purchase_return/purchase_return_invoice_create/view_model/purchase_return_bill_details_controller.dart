import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class PurchaseReturnBillDetailsController extends GetxController {
  final invoiceNoController = TextEditingController();
  final invoiceCreatedController = TextEditingController();
  final invoiceReceivedController = TextEditingController();
  final FocusNode invoiceNumberFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // final InventoryRepository _inventoryRepository = InventoryRepository();

  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final RxString invoiceNumber = ''.obs;

  final RxString salesNumber = ''.obs;
  final sequencesDropdownResponse =
      Rx<ApiResponse<GetSequencesDropdownResponse>>(
        ApiResponse.initial("INITIAL"),
      );
  final sequencesDropdownList = <GetSequencesDropdownValue>[].obs;
  final selectedSequence = Rx<GetSequencesDropdownValue?>(null);
  final sequencesDropdownController = TextEditingController();
  final sequencesDropdownFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    loadSequencesDropdown();
  }

  Future<void> loadSequencesDropdown({
    String? voucherType = "7",
    String? voucherSection = "10",
  }) async {
    try {
      sequencesDropdownResponse.value = ApiResponse.loading(
        "Loading sequences...",
      );

      final response = await _purchaseInvoiceRepository.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: voucherSection,
      );

      if (response.values != null && response.values!.isNotEmpty) {
        sequencesDropdownList.assignAll(response.values!);
        sequencesDropdownResponse.value = ApiResponse.completed(response);

        final defaultSequence =
            response.values!.firstWhereOrNull((seq) => seq.isDefault == true) ??
            response.values!.first;
        setSelectedSequence(defaultSequence);
      } else {
        sequencesDropdownResponse.value = ApiResponse.completed(response);
        showErrorToast(message: 'No sequences available');
      }
    } catch (e) {
      log('Error loading sequences dropdown: $e');
      sequencesDropdownResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to load sequences');
    }
  }

  void setSelectedSequence(GetSequencesDropdownValue sequence) {
    selectedSequence.value = sequence;
    sequencesDropdownController.text = sequence.value ?? '';
    salesNumber.value = sequence.value ?? '';
  }

  @override
  void onClose() {
    invoiceNoController.dispose();
    invoiceCreatedController.dispose();
    invoiceReceivedController.dispose();
    invoiceNumberFocusNode.dispose();
    sequencesDropdownController.dispose();
    sequencesDropdownFocusNode.dispose();
    setDefaultDates();
    super.onClose();
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  void setDefaultDates() {
    final today = DateTime.now();
    final formattedDate = formatDate(today);
    invoiceCreatedController.text = formattedDate;
    invoiceReceivedController.text = formattedDate;
  }

  bool validateBillDetails() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void clearControllers() {
    invoiceNoController.text = "";
    invoiceCreatedController.text = "";
    invoiceReceivedController.text = "";
    selectedSequence.value = null;
    sequencesDropdownController.text = "";
    salesNumber.value = "";
  }
}
