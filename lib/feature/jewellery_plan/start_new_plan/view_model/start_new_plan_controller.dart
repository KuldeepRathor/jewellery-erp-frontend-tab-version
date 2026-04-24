import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_installment_data_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_savings_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/view_model/party_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class StartNewPlanController extends GetxController {
  final JewelleryPlanRepository inventoryRepository = JewelleryPlanRepository();
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final searchController = TextEditingController();
  final Rx<int?> selectedPlanId = Rx<int?>(null);
  final formKey = GlobalKey<FormState>();
  final PartyDetailsController partyDetailsController =
      Get.put<PartyDetailsController>(PartyDetailsController());

  // final Rx<MetalTypeResponse?> selectedMetalType = Rx<MetalTypeResponse?>(null);

  final RxList<GetSavingsPlanValue> planTypes = <GetSavingsPlanValue>[].obs;

  final Rx<GetSavingsPlanValue?> selectedPlanType = Rx<GetSavingsPlanValue?>(
    null,
  );

  void validateForm() {
    formKey.currentState!.validate();
  }

  void setSelectedPlanType(GetSavingsPlanValue? value) {
    selectedPlanType.value = value;
  }

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMorePages = true.obs;

  final isVerified = false.obs;

  final sipAmountController = TextEditingController();

  final getSavingsPlanResponse = Rx<ApiResponse<List<GetSavingsPlanValue>>>(
    ApiResponse.initial("Initial"),
  );

  final jewelleryPlanResponse = Rx<ApiResponse<GetJewelleryPlanResponseModel>>(
    ApiResponse.initial("INITIAL"),
  );
  final installmentDataResponse = Rx<ApiResponse<GetInstallmentDataResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  @override
  void onInit() {
    super.onInit();
    getSavingsPlan();
    _setupSearchListener();
  }

  void _setupSearchListener() {
    searchController.addListener(() {
      setSearchQuery(searchController.text);
    });
  }

  void setInitialConditions({required bool isSearch}) {
    currentPage.value = 1;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getJewelleryPlanDetails(resetList: true, isSearch: true);
    });
  }

  String? getActivePlanAmount() {
    return jewelleryPlanResponse.value.data?.results?.firstOrNull?.code;
  }

  bool hasPlanDetails() {
    return jewelleryPlanResponse.value.data?.results?.isNotEmpty ?? false;
  }

  Future<void> getJewelleryPlanDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    try {
      if (resetList) {
        setInitialConditions(isSearch: isSearch);
        jewelleryPlanResponse.value = ApiResponse.loading("LOADING");
      } else {
        if (!hasMorePages.value) return;
        isLoadingMore.value = true;
      }

      final response = await inventoryRepository.getJewelleryPlans(
        page: currentPage.value,
        search: searchQuery.value,
        status: "",
        ordering: "-id",
      );

      if (response.results?.isNotEmpty ?? false) {
        jewelleryPlanResponse.value = ApiResponse.completed(response);
        isVerified.value = true;

        final firstResult = response.results?.first;
        if (firstResult != null) {
          final code = firstResult.code;
          // Convert planId string to integer
          selectedPlanId.value = int.tryParse(firstResult.planId ?? "0");

          if (code != null) {
            await getInstallmentData(code);
          }
        }

        log("Plan verified successfully");
        showSuccessToast(message: "Plan verified successfully");
      } else {
        showErrorToast(message: "No active plan found");
        isVerified.value = false;
      }
    } catch (e) {
      if (resetList) {
        jewelleryPlanResponse.value = ApiResponse.error(e.toString());
      }
      isVerified.value = false;
      showErrorToast(message: "Error fetching jewellery plans");
      log("Error fetching jewellery plans: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> getInstallmentData(String subscriptionCode) async {
    try {
      installmentDataResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getInstallmentData(
        subscription_code: subscriptionCode,
      );
      installmentDataResponse.value = ApiResponse.completed(response);
      // showSuccessToast(message: "Installment data fetched successfully");

      // // NewPlanPaymentDetailsController? paymentController;
      // try {
      //   paymentController = Get.find<NewPlanPaymentDetailsController>();
      // } catch (_) {
      //   paymentController = Get.put<NewPlanPaymentDetailsController>(
      //       NewPlanPaymentDetailsController());
      // }

      // // Update on next frame to ensure controller is ready
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   paymentController?.installmentAmountController.text =
      //       response.amount ?? '0';
      // });
    } catch (e) {
      installmentDataResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Error fetching installment data");
      log("Error fetching installment data: $e");
    }
  }

  Future<void> getSavingsPlan() async {
    try {
      getSavingsPlanResponse.value = ApiResponse.loading("Loading");
      final response = await inventoryRepository.getSavingsPlan();
      final plans = response.plans ?? [];

      // Update both Rx variables
      planTypes.clear();
      planTypes.addAll(plans);
      getSavingsPlanResponse.value = ApiResponse.completed(plans);
    } catch (e) {
      getSavingsPlanResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Error fetching savings plans");
      log('Error fetching savings plans: $e');
    }
  }

  @override
  void onClose() {
    sipAmountController.dispose();
    super.onClose();
  }

  void resetFields() {
    planTypes.clear();
    selectedPlanType.value = null;
    searchController.text = "";
    isVerified.value = false;
    selectedPlanId.value = null;
    partyDetailsController.searchController.value.text = "";
    sipAmountController.clear();
    isVerified.value = false;
  }
}
