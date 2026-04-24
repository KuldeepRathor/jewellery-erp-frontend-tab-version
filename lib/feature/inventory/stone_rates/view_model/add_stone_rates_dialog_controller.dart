import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view/components/dialog_box/generic_attention_dialog_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/models/post_stone_rate_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stone_rates/view_model/stone_rates_page_llisting_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/inventory_models/get_all_ornaments_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/inventory_viewmodel.dart';
import 'package:jewellery_erp_frontend_tab_version/model/stone_rates/get_stone_rates_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:toastification/toastification.dart';

class AddStoneRatesController extends GetxController {
  final InventoryRepository inventoryRepository = InventoryRepository();
  final InventoryViewmodel inventoryViewmodel = Get.put(InventoryViewmodel());
  final _debouncer = CustomDebouncer(milliseconds: 500);

  // Original rate tracking
  String? originalRate;

  // Form Controllers
  final stoneRatesCodeController = TextEditingController();
  final stoneRatesNameController = TextEditingController();
  final ratesController = TextEditingController();
  final colorController = TextEditingController();
  final cutController = TextEditingController();
  final clarityController = TextEditingController();
  final buybackController = TextEditingController();
  final ornamentCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Observable variables
  final RxBool isCodeAvailable = true.obs;
  final RxBool isCheckingCode = false.obs;
  final rateTypeItems = ['GM', 'CT', 'PC'];
  final selectedRateType = Rx<String>('CT');
  final RxList<GetAllOrnamentsResponseValue> ornamentCodeList =
      <GetAllOrnamentsResponseValue>[].obs;
  final Rx<GetAllOrnamentsResponseValue?> selectedOrnamentCode = Rx(null);
  final RxBool applyChangesToExisting = false.obs;
  final RxBool isOtherMix = false.obs; // New toggle state

  // API Response states
  final addStoneRatesResponse = Rx<ApiResponse<GetStoneRatesValue>>(
    ApiResponse.initial("Initial"),
  );
  final editStoneRatesResponse = Rx<ApiResponse<GetStoneRatesValue>>(
    ApiResponse.initial("Initial"),
  );
  final getStoneRateIdResponse = Rx<ApiResponse<GetStoneRatesValue>>(
    ApiResponse.initial("Initial"),
  );

  void toggleIsOtherMix(bool value) {
    isOtherMix.value = value;
    // Force validation to update with new requirements
    formKey.currentState?.validate();
  }

  void onRateTypeChanged(String? value) {
    if (value != null) {
      selectedRateType.value = value;
    }
  }

  void checkCodeAvailability(String code, String model) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }

    isCheckingCode.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await inventoryRepository.validateCode(code, model);
        isCodeAvailable.value = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code Availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  Future<void> getStoneRateById(String stoneRateId) async {
    try {
      getStoneRateIdResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getStoneRateeById(stoneRateId);
      setStoneRateData(response);
      // Store original rate for comparison
      originalRate = response.rate;
      getStoneRateIdResponse.value = ApiResponse.completed(response);
    } catch (e) {
      log('Error getting stone rate: $e');
      getStoneRateIdResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Failed to load Stone Rate");
    }
  }

  Future<void> getCodeList() async {
    await inventoryViewmodel.getAllOrnaments(isStone: true);
    ornamentCodeList.assignAll(
      inventoryViewmodel.getAllOrnamentsResponse.value.data?.values ?? [],
    );
  }

  void setSelectedcode(GetAllOrnamentsResponseValue value) {
    selectedOrnamentCode.value = value;
    update();
  }

  Future<bool> _checkIfRateChanged() {
    // Check if this is an edit operation and if the rate has changed
    return Future.value(
      originalRate != null && originalRate != ratesController.text,
    );
  }

  Future<bool> _showRateChangeDialog() async {
    final completer = Completer<bool>();

    Get.dialog(
      GenericAttentionDialog(
        title: 'Rate Changed',
        message:
            'Do you want to apply changes to All Pieces or Further Pieces?',
        actions: [
          DialogAction(
            text: "Further",
            onPressed: () {
              applyChangesToExisting.value = false;
              Get.back();
              completer.complete(false);
            },
            shortcut: 'esc',
          ),
          DialogAction(
            text: 'All',
            onPressed: () {
              applyChangesToExisting.value = true;
              Get.back();
              completer.complete(true);
            },
            isDefault: true,
            shortcut: 'Enter',
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return completer.future;
  }

  Future<void> submitStoneRates(String? stoneRateId) async {
    try {
      if (!formKey.currentState!.validate()) return;

      final isEdit = stoneRateId != null;
      bool applyToExisting = false;

      // Check if rate changed and show dialog if needed
      if (isEdit && await _checkIfRateChanged()) {
        await _showRateChangeDialog();
        applyToExisting = applyChangesToExisting.value;
      }

      final response = isEdit ? editStoneRatesResponse : addStoneRatesResponse;
      response.value = ApiResponse.loading("Loading");
      isCodeAvailable.value = true;
      final stoneRatesValues = PostStoneRateRequest(
        name: stoneRatesNameController.text,
        code: stoneRatesCodeController.text,
        rate: ratesController.text,
        rateType: selectedRateType.value,
        color: colorController.text,
        cut: cutController.text,
        clarity: clarityController.text,
        buyBackPercentage:
            buybackController.text.isEmpty ? "0" : buybackController.text,
        ornamentId: selectedOrnamentCode.value?.id,
        change_existing_rate: isEdit ? applyToExisting : null,
        isOther: isOtherMix.value, // Include the isOther flag in the request
      );

      final result =
          isEdit
              ? await inventoryRepository.editStoneRate(
                stoneRateId,
                stoneRatesValues,
              )
              : await inventoryRepository.addStoneRates(stoneRatesValues);

      response.value = ApiResponse.completed(result);
      formKey.currentState?.reset();
      Get.back();
      // await Future.delayed(const Duration(milliseconds: 100));
      resetFields();

      // Show success toast
      _showSuccessToast(isEdit);

      // Refresh the list
      Get.put(StoneRatesListController()).getStoneRatesDetails(resetList: true);
    } catch (e) {
      log('Error submitting stone rate: $e');
      final response =
          stoneRateId != null ? editStoneRatesResponse : addStoneRatesResponse;
      response.value = ApiResponse.error(e.toString());
      showErrorToast(
        message:
            stoneRateId == null
                ? "Failed to add stone rate"
                : "Failed to update stone rate",
      );
    }
  }

  void _showSuccessToast(bool isEdit) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(
        isEdit
            ? "Stone rate updated successfully"
            : 'Stone rate added successfully',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.check, color: Colors.white),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(100),
    );
  }

  void setStoneRateData(GetStoneRatesValue data) {
    stoneRatesCodeController.text = data.code ?? "";
    stoneRatesNameController.text = data.name ?? "";
    ratesController.text = data.rate ?? "";
    colorController.text = data.color ?? "";
    cutController.text = data.cut ?? "";
    clarityController.text = data.clarity ?? "";
    buybackController.text = data.buyBackPercentage ?? "";
    selectedRateType.value = data.rateType ?? "CT";
    selectedOrnamentCode.value = data.ornament;
    ornamentCodeController.text = data.ornament?.code ?? "";
    isOtherMix.value =
        data.isOther ?? false; // Set the toggle state from response

    // Store original rate for later comparison
    originalRate = data.rate;
  }

  void resetFields() {
    stoneRatesCodeController.clear();
    stoneRatesNameController.clear();
    ratesController.clear();
    buybackController.clear();
    colorController.clear();
    cutController.clear();
    clarityController.clear();
    selectedRateType.value = 'CT';
    selectedOrnamentCode.value = null;
    ornamentCodeController.clear();
    applyChangesToExisting.value = false;
    isOtherMix.value = false; // Reset toggle state
    originalRate = null;
    isCodeAvailable.value = true;
  }

  @override
  void onClose() {
    // Dispose controllers
    stoneRatesCodeController.dispose();
    stoneRatesNameController.dispose();
    ratesController.dispose();
    colorController.dispose();
    cutController.dispose();
    clarityController.dispose();
    buybackController.dispose();
    ornamentCodeController.dispose();
    super.onClose();
  }
}
