import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/terms_and_condition_reponse.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/create_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class TermsConditionsController extends GetxController {
  final planTermsAndConditionController = TextEditingController();
  final EstimationRepository _estimationRepository = EstimationRepository();
  final RxList<TermsAndConditionValue> termsTemplates =
      <TermsAndConditionValue>[].obs;
  final RxString planType = RxString("");
  final RxBool isLoading = false.obs;
  // final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading.value = true;
      final response = await _estimationRepository.getTermsAndCondition();
      if (response.values != null && response.values!.isNotEmpty) {
        termsTemplates.value = response.values!;
        // Set initial value to the first template's text
        if (termsTemplates.isNotEmpty) {
          planType.value = termsTemplates[0].text ?? "";
          planTermsAndConditionController.text = termsTemplates[0].text ?? "";
        }
      }
    } catch (e) {
      log('Error fetching terms and conditions: $e');
      showErrorToast(message: "Failed to fetch terms and conditions templates");
    } finally {
      isLoading.value = false;
    }
  }

  String? getSelectedTemplateId() {
    if (planType.value.isEmpty) return null;

    final selectedTemplate = termsTemplates.firstWhereOrNull(
      (template) => template.text == planType.value,
    );
    return selectedTemplate?.id;
  }

  void setPlanType(String? value) {
    if (value != null) {
      planType.value = value;
      final selectedTemplate = termsTemplates.firstWhereOrNull(
        (template) => template.text == value,
      );
      if (selectedTemplate != null) {
        planTermsAndConditionController.text = selectedTemplate.text ?? '';
      }
    }
  }

  bool validateFields() {
    // if (!formKey.currentState!.validate()) {
    //   return false;
    // }

    // Validate template selection
    if (planType.value.isEmpty || getSelectedTemplateId() == null) {
      showErrorToast(message: "Please select a valid terms template");
      return false;
    }

    // Validate terms and conditions content
    if (planTermsAndConditionController.text.trim().isEmpty) {
      showErrorToast(message: "Terms and conditions content cannot be empty");
      return false;
    }

    // Validate minimum content length
    // if (planTermsAndConditionController.text.trim().length < 50) {
    //   showErrorToast(message: "Terms and conditions content is too short");
    //   return false;
    // }

    return true;
  }

  String? validateTermsContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Terms and conditions content is required';
    }
    // if (value.trim().length < 50) {
    //   return 'Terms and conditions content must be at least 50 characters';
    // }
    return null;
  }

  void handleNext() async {
    if (!validateFields()) {
      return;
    }

    try {
      final createPlanController = Get.find<CreateJewelleryPlanController>();
      await createPlanController.createJewelleryPlan();
    } catch (e) {
      log('Error in handleNext: $e');
      showErrorToast(message: "Failed to proceed: ${e.toString()}");
    }
  }

  void handleDiscard() {
    planTermsAndConditionController.clear();
    if (termsTemplates.isNotEmpty) {
      planType.value = termsTemplates[0].text ?? "";
      planTermsAndConditionController.text = termsTemplates[0].text ?? "";
    }
  }

  @override
  void onClose() {
    planTermsAndConditionController.dispose();
    super.onClose();
  }
}
