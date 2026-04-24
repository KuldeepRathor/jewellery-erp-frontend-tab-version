import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/inventory/stock/design/design_add_update/models/get_design_response_models/get_paginated_design_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class DesignSettingsController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final RxBool isTaggingEnabled = true.obs;
  final RxBool isStoneCostEnabled = false.obs;

  final TextEditingController tagCodeController = TextEditingController();
  final RxBool isCheckingCode = false.obs;
  final RxBool isCodeAvailable = true.obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode tagFocusNode = FocusNode();
  final FocusNode stoneFocusNode = FocusNode();
  final FocusNode tagCodeFocusNode = FocusNode();
  @override
  void onInit() {
    super.onInit();
    tagCodeController.addListener(_onDesignCodeChanged);
  }

  @override
  void onClose() {
    tagCodeController.removeListener(_onDesignCodeChanged);
    tagCodeController.dispose();
    tagCodeFocusNode.dispose();
    tagFocusNode.dispose();
    stoneFocusNode.dispose();
    super.onClose();
  }

  void _onDesignCodeChanged() {
    // Add any additional logic needed when design code changes
  }

  void toggleTagging() {
    isTaggingEnabled.toggle();
    if (isTaggingEnabled.value) {
      tagCodeController.clear();
      isCodeAvailable.value = true;
    }
  }

  void toggleStoneCost() => isStoneCostEnabled.toggle();

  void clearControllers() {
    isTaggingEnabled.value = true;
    isStoneCostEnabled.value = false;
    tagCodeController.clear();
    isCodeAvailable.value = true;
  }

  void checkCodeAvailability(String code) {
    if (code.isEmpty) {
      isCodeAvailable.value = true;
      isCheckingCode.value = false;
      return;
    }
    isCheckingCode.value = true;
    _debouncer.run(() async {
      try {
        final isAvailable = await _inventoryRepository.validateCode(
          code,
          "design_tag_code",
        );
        isCodeAvailable.value = isAvailable;
      } catch (e) {
        showErrorToast(message: "Failed to check code availability");
      } finally {
        isCheckingCode.value = false;
      }
    });
  }

  void populateWithFetchedData(GetDesignResponseModel data) {
    isTaggingEnabled.value = data.tagRequired ?? true;
    isStoneCostEnabled.value = data.stoneRequired ?? false;
    if (data.tagCode != null) {
      tagCodeController.text = data.tagCode!;
    }
  }
}
