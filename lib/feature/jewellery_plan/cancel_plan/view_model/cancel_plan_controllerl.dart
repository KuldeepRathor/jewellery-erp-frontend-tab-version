import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/add_installment/view_model/add_installment_paymnet_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/cancel_plan/model/cancel_plan_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/customer_ledger_listing/model/get_jewellery_plan_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/jewellery_plan/start_new_plan/model/get_installment_data_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/jewellery_plan_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CancelPlanController extends GetxController {
  // final CustomerListingRepository _customerListingRepository =
  //     CustomerListingRepository();
  final JewelleryPlanRepository _inventoryRepository =
      JewelleryPlanRepository();

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final jewelleryPlanResponse = Rx<ApiResponse<GetJewelleryPlanResponseModel>>(
    ApiResponse.initial("INITIAL"),
  );
  final installmentDataResponse = Rx<ApiResponse<GetInstallmentDataResponse>>(
    ApiResponse.initial("INITIAL"),
  );
  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  final isVerified = false.obs;

  final isSubmitting = false.obs;
  String? planId;
  final amountCollectedController = TextEditingController();
  final dedcutionsController = TextEditingController();
  final amountPayableController = TextEditingController();
  final paymentModeController = TextEditingController();
  final bankController = TextEditingController();
  final addNoteController = TextEditingController();

  final cancelDateController = TextEditingController();
  final paymentDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    log("Add Installment viewmodel initiated");
    getJewelleryPlanDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Customer Listing viewmodel Deleted");
    super.onClose();
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void setInitialConditions({required bool isSearch}) {
    currentPage.value = 1;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  bool validateFields() {
    if (amountCollectedController.text.isEmpty ||
        dedcutionsController.text.isEmpty ||
        amountPayableController.text.isEmpty ||
        cancelDateController.text.isEmpty ||
        paymentModeController.text.isEmpty ||
        paymentDateController.text.isEmpty) {
      showErrorToast(message: "Please fill all required fields");
      return false;
    }
    return true;
  }

  Future<void> cancelPlan() async {
    if (!validateFields()) return;

    try {
      isSubmitting.value = true;

      final request = CancelPlanRequest(
        planId: jewelleryPlanResponse.value.data?.results?.first.code,
        deduction: int.tryParse(dedcutionsController.text) ?? 0,
        amountPayable: int.tryParse(amountPayableController.text) ?? 0,
        cancelDate: _parseDate(cancelDateController.text),
        paymentMode: int.tryParse(paymentModeController.text) ?? 0,
        bank: bankController.text,
        paymentDate: _parseDate(paymentDateController.text),
        comments: addNoteController.text,
      );

      await _inventoryRepository.cancelPlan(request);
      showSuccessToast(message: "Plan cancelled successfully");

      // Navigate back
      SidebarController sidebarController = Get.find();
      sidebarController.popBackSelectedWidget();
    } catch (e) {
      showErrorToast(message: "Failed to cancel plan: ${e.toString()}");
      log("Error cancelling plan: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      log("Error parsing date: $e");
    }
    return null;
  }

  Future<void> getJewelleryPlanDetails({
    bool resetList = false,
    bool isSearch = false,
    String? phoneNumber,
  }) async {
    try {
      if (resetList) {
        setInitialConditions(isSearch: isSearch);
        jewelleryPlanResponse.value = ApiResponse.loading("LOADING");
      } else {
        if (!hasMorePages.value) return;
        isLoadingMore.value = true;
      }

      final response = await _inventoryRepository.getJewelleryPlans(
        page: currentPage.value,
        search: phoneNumber ?? searchQuery.value,
        status: "",
        ordering: "-id",
      );

      if (response.results?.isNotEmpty ?? false) {
        jewelleryPlanResponse.value = ApiResponse.completed(response);
        isVerified.value = true;

        final firstResult = response.results?.first;
        if (firstResult != null) {
          final code = firstResult.code;
          if (code != null) {
            await getInstallmentData(code: code);
          }
        }

        log("Plan verified successfully");
        showSuccessToast(message: "Plan verified successfully");
      } else {
        showErrorToast(message: "No active plan found");
        isVerified.value = false;
      }

      hasMorePages.value = response.next != null;
      if (hasMorePages.value) {
        currentPage.value++;
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

  Future<void> getInstallmentData({required String code}) async {
    try {
      installmentDataResponse.value = ApiResponse.loading("Loading");
      final response = await _inventoryRepository.getInstallmentData(
        subscription_code: code,
      );
      installmentDataResponse.value = ApiResponse.completed(response);
      showSuccessToast(message: "Installment data fetched successfully");

      // Put controller creation first
      AddInstallmentPaymentDetailsController paymentController;
      try {
        paymentController = Get.find<AddInstallmentPaymentDetailsController>();
      } catch (_) {
        paymentController = Get.put(AddInstallmentPaymentDetailsController());
      }

      // Use the amount directly from response, not accessing through controller
      if (response.amount != null) {
        paymentController.installmentAmountController.text = response.amount!;
        // Force UI refresh
        paymentController.update();
        log("Response amount: ${response.amount}");
      }

      // Update jewellery plan data
      paymentController.jewelleryPlanResponse.value =
          jewelleryPlanResponse.value;
    } catch (e) {
      installmentDataResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: "Error fetching installment data");
      log("Error fetching installment data: $e");
    }
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more items - Page: ${currentPage.value}");
      await getJewelleryPlanDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() async {
      await getJewelleryPlanDetails(
        resetList: true,
        isSearch: true,
        phoneNumber: query,
      );
    });
  }
}
