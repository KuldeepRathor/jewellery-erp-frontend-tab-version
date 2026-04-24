import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/model/create_jewellery_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view/setup_plan_listing_page.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/design_selection_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/setup_jewellery_plan_benefits_controler.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/setup_jewellery_plan_listing_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/setup_plan/view_model/terms_and_condition_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CreateJewelleryPlanController extends GetxController {
  // Text Controllers
  final planNameController = TextEditingController();
  final minSipAmountController = TextEditingController();
  final maxSipAmountController = TextEditingController();
  final prefixedAmountController = TextEditingController();
  final planBenefitsController = TextEditingController();

  final daysController = TextEditingController();
  final planTimeFrame = RxString("Monthly Plan");

  // Reactive variables using RxString and RxBool
  final planDuration = RxString("1");
  final planType = RxString("In Weight");
  final chargeGatewayFees = RxBool(true);

  // New reactive variables for field states
  final isSipFieldsEnabled = RxBool(true);
  final isPrefixedFieldEnabled = RxBool(true);
  final EstimationRepository _estimationRepository = EstimationRepository();
  final RxBool isLoading = false.obs;

  // List of available plan durations
  final planDurations = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
  ];

  @override
  void onInit() {
    super.onInit();
    // Add listeners to the text controllers
    minSipAmountController.addListener(_updateFieldStates);
    maxSipAmountController.addListener(_updateFieldStates);
    prefixedAmountController.addListener(_updateFieldStates);
  }

  // Update field states based on text values
  void _updateFieldStates() {
    bool hasMinSipAmount = minSipAmountController.text.isNotEmpty;
    bool hasMaxSipAmount = maxSipAmountController.text.isNotEmpty;
    bool hasPrefixedAmount = prefixedAmountController.text.isNotEmpty;

    // If both SIP amounts have values, disable prefixed amount field
    if (hasMinSipAmount && hasMaxSipAmount) {
      isPrefixedFieldEnabled.value = false;
      if (hasPrefixedAmount) {
        prefixedAmountController
            .clear(); // Clear prefixed amount if it has value
      }
    } else {
      isPrefixedFieldEnabled.value = true;
    }

    // If prefixed amount has value, disable SIP amount fields
    if (hasPrefixedAmount) {
      isSipFieldsEnabled.value = false;
      if (hasMinSipAmount || hasMaxSipAmount) {
        minSipAmountController.clear(); // Clear min SIP amount if it has value
        maxSipAmountController.clear(); // Clear max SIP amount if it has value
      }
    } else {
      isSipFieldsEnabled.value = true;
    }
  }

  // Helper method to determine the API plan type
  String _getApiPlanType() {
    if (planTimeFrame.value == "Daily Plan") {
      return "DAB"; // Daily Amount Based
    } else {
      // Monthly Plan
      return planType.value == "In Weight" ? "WB" : "AB";
    }
  }

  // Modified setters
  void setPlanDuration(String? duration) {
    if (duration != null) {
      planDuration.value = duration;
    }
  }

  void setPlanType(String? type) {
    if (type != null) {
      planType.value = type;
    }
  }

  void setChargeGatewayFees(bool? value) {
    if (value != null) {
      chargeGatewayFees.value = value;
    }
  }

  void setPlanTimeFrame(String? type) {
    if (type != null) {
      planTimeFrame.value = type;
    }
  }

  //Validations

  bool validateAllFields() {
    // Validate plan name
    if (planNameController.text.isEmpty) {
      showErrorToast(message: "Plan name is required");
      return false;
    }

    // Validate plan duration for Daily Plan
    if (planTimeFrame.value == "Daily Plan") {
      if (daysController.text.isEmpty) {
        showErrorToast(message: "Days are required for Daily Plan");
        return false;
      }
      int? days = int.tryParse(daysController.text);
      if (days == null || days <= 0) {
        showErrorToast(message: "Please enter a valid number of days");
        return false;
      }
    }

    // Validate SIP amounts or prefixed amount
    if (isSipFieldsEnabled.value) {
      if (minSipAmountController.text.isEmpty ||
          maxSipAmountController.text.isEmpty) {
        showErrorToast(message: "Both Min and Max SIP amounts are required");
        return false;
      }

      double? minSip = double.tryParse(minSipAmountController.text);
      double? maxSip = double.tryParse(maxSipAmountController.text);

      if (minSip == null || maxSip == null) {
        showErrorToast(message: "Please enter valid SIP amounts");
        return false;
      }

      if (minSip >= maxSip) {
        showErrorToast(
          message: "Maximum SIP amount must be greater than minimum SIP amount",
        );
        return false;
      }
    } else if (isPrefixedFieldEnabled.value) {
      if (prefixedAmountController.text.isEmpty) {
        showErrorToast(message: "Prefixed amount is required");
        return false;
      }

      // Validate comma-separated values
      List<String> amounts = prefixedAmountController.text.split(',');
      if (amounts.length > 5) {
        showErrorToast(message: "Maximum 5 prefixed amounts are allowed");
        return false;
      }

      for (String amount in amounts) {
        if (int.tryParse(amount.trim()) == null) {
          showErrorToast(message: "Please enter valid prefixed amounts");
          return false;
        }
      }
    }

    // Validate plan benefits
    if (planBenefitsController.text.trim() == '•' ||
        planBenefitsController.text.isEmpty) {
      showErrorToast(message: "Plan benefits are required");
      return false;
    }

    return true;
  }

  Future<void> createJewelleryPlan() async {
    try {
      if (!validateAllFields()) {
        log('Failed validation');
        return;
      }

      isLoading.value = true;

      log('Getting controllers...');
      final benefitsController =
          Get.find<SetupJewelleryPlanBenefitsController>();
      final designController = Get.find<DesignSelectionController>();
      final termsConditionsController = Get.find<TermsConditionsController>();
      log('Controllers found');

      // Design validation
      log('Selected designs: ${designController.selectedDesignsList.length}');
      if (designController.selectedDesignsList.isEmpty) {
        showErrorToast(message: "Please select at least one design");
        return;
      }

      final stockHeadId = designController.selectedDesignsList[0].id;
      log('StockHeadId: $stockHeadId');
      if (stockHeadId == null || stockHeadId.isEmpty) {
        showErrorToast(message: "Invalid design selection");
        return;
      }

      // Terms validation
      final tcTemplateId = termsConditionsController.getSelectedTemplateId();
      log('Template ID: $tcTemplateId');
      if (tcTemplateId == null) {
        showErrorToast(message: "Please select a valid terms template");
        return;
      }

      // Benefits validation
      log(
        'Parsing installment bonus: ${benefitsController.installmentBonus.value}',
      );
      double installmentBonusValue;
      try {
        installmentBonusValue = double.parse(
          benefitsController.installmentBonus.value,
        );
      } catch (e) {
        log('Error parsing installment bonus: $e');
        showErrorToast(message: "Invalid installment bonus value");
        return;
      }

      log('Creating request object...');
      final request = CreateJewelleryPlanRequest(
        planName: planNameController.text,
        planType: _getApiPlanType(),
        planDuration: int.parse(planDuration.value),
        minSipAmount: minSipAmountController.text,
        maxSipAmount: maxSipAmountController.text,
        prefixedAmount: prefixedAmountController.text,
        paymentGatewayCharges: chargeGatewayFees.value,
        planBenifit: [planBenefitsController.text],
        vaBenefit: benefitsController.vaBenefitController.text,
        vaBenefitUpto: benefitsController.vaBenefitUptoController.text,
        mcBenefit: benefitsController.mcBenefitController.text,
        mcBenefitUpto: benefitsController.mcBenefitUptoController.text,
        stoneBenefitUpto: benefitsController.stoneBenefitController.text,
        stoneType: benefitsController.selectedStoneType.value?.id ?? '',
        stockHeadId: stockHeadId,
        stockHeadMetalType:
            benefitsController.selectedStockHeadMetalType.value?.id ?? '',
        installmentBonus: installmentBonusValue.toInt(),
        collectGst: benefitsController.gstType.value == 'Charge GST',
        termsAndCondition:
            termsConditionsController.planTermsAndConditionController.text,
        tcTemplateId: tcTemplateId,
        designIds:
            designController.selectedDesignsList
                .map((design) => design.id ?? '')
                .where((id) => id.isNotEmpty)
                .toList(),
      );

      log('Request object created: ${jsonEncode(request.toJson())}');

      log('Calling API...');
      final response = await _estimationRepository.createJewelleryPlan(request);
      log('API Response: $response');

      log('Updating UI after successful response');
      final sidebarController = Get.find<SidebarController>();
      sidebarController.navigateToWidget(
        newChild: const SetupPlanListingPage(),
      );
      showSuccessToast(message: "Jewellery plan created successfully");
      Get.find<SetupPlanController>().loadPlans();
      update();
    } catch (e, stackTrace) {
      log('Error creating jewellery plan: $e');
      log('Stack trace: $stackTrace');
      showErrorToast(
        message: "Failed to create jewellery plan: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    planNameController.clear();
    minSipAmountController.clear();
    maxSipAmountController.clear();
    prefixedAmountController.clear();
    planBenefitsController.clear();
    planDuration.value = "3";
    planType.value = "In Weight";
    chargeGatewayFees.value = true;
    isSipFieldsEnabled.value = true;
    isPrefixedFieldEnabled.value = true;
    daysController.clear();
    planTimeFrame.value = "Monthly Plan";
  }

  @override
  void onClose() {
    // Remove listeners before disposing
    minSipAmountController.removeListener(_updateFieldStates);
    maxSipAmountController.removeListener(_updateFieldStates);
    prefixedAmountController.removeListener(_updateFieldStates);

    // Dispose controllers
    planNameController.dispose();
    minSipAmountController.dispose();
    maxSipAmountController.dispose();
    prefixedAmountController.dispose();
    planBenefitsController.dispose();
    daysController.dispose();
    super.onClose();
  }
}
