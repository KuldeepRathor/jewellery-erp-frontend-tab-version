import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/customer/customer_dashboard/model/customer_dashboard_detail_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/customer_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CustomerDashboardViewmodel extends GetxController {
  final AggregateRepository aggregateRepository = AggregateRepository();
  final CustomerRepository customerRepository = CustomerRepository();

  final getCustomerDashboardDetailsResponse =
      Rx<ApiResponse<CustomerDashboardDetailsResponse>>(
        ApiResponse.initial("Initial"),
      );

  final isUpdatingForcedKyc = false.obs;

  Future<void> getCustomerDashboardDetails({required String id}) async {
    try {
      getCustomerDashboardDetailsResponse.value = ApiResponse.loading(
        "Loading",
      );
      final response = await aggregateRepository.getCustomerDashboardDetails(
        id: id,
      );
      getCustomerDashboardDetailsResponse.value = ApiResponse.completed(
        response,
      );
    } catch (e) {
      getCustomerDashboardDetailsResponse.value = ApiResponse.error(
        e.toString(),
      );
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }

  Future<void> toggleForcedKycPan(String customerId, bool newValue) async {
    try {
      isUpdatingForcedKyc.value = true;

      // Call the actual API
      await customerRepository.updateForcedKycPan(
        customerId: customerId,
        isForcedKycPan: newValue,
      );

      // Update local state after successful API call
      if (getCustomerDashboardDetailsResponse.value.data?.customerDetails !=
          null) {
        getCustomerDashboardDetailsResponse
            .value
            .data!
            .customerDetails!
            .isForcedKycPan = newValue;
        getCustomerDashboardDetailsResponse.value = ApiResponse.completed(
          getCustomerDashboardDetailsResponse.value.data!,
        );
      }

      showSuccessToast(
        message:
            newValue ? "PAN KYC forced enabled" : "PAN KYC forced disabled",
      );
    } catch (e) {
      log('Error updating forced KYC PAN: $e');
      showErrorToast(message: "Failed to update PAN KYC enforcement: $e");

      // Optionally: Refresh data to ensure UI is in sync with backend
      if (getCustomerDashboardDetailsResponse.value.data?.customerDetails?.id !=
          null) {
        await getCustomerDashboardDetails(
          id:
              getCustomerDashboardDetailsResponse
                  .value
                  .data!
                  .customerDetails!
                  .id!,
        );
      }
    } finally {
      isUpdatingForcedKyc.value = false;
    }
  }

  Future<void> toggleForcedKycAadhaar(String customerId, bool newValue) async {
    try {
      isUpdatingForcedKyc.value = true;

      // Call the actual API
      await customerRepository.updateForcedKycAadhaar(
        customerId: customerId,
        isForcedKycAadhaar: newValue,
      );

      // Update local state after successful API call
      if (getCustomerDashboardDetailsResponse.value.data?.customerDetails !=
          null) {
        getCustomerDashboardDetailsResponse
            .value
            .data!
            .customerDetails!
            .isForcedKycAadhaar = newValue;
        getCustomerDashboardDetailsResponse.value = ApiResponse.completed(
          getCustomerDashboardDetailsResponse.value.data!,
        );
      }

      showSuccessToast(
        message:
            newValue
                ? "Aadhaar KYC forced enabled"
                : "Aadhaar KYC forced disabled",
      );
    } catch (e) {
      log('Error updating forced KYC Aadhaar: $e');
      showErrorToast(message: "Failed to update Aadhaar KYC enforcement: $e");

      // Optionally: Refresh data to ensure UI is in sync with backend
      if (getCustomerDashboardDetailsResponse.value.data?.customerDetails?.id !=
          null) {
        await getCustomerDashboardDetails(
          id:
              getCustomerDashboardDetailsResponse
                  .value
                  .data!
                  .customerDetails!
                  .id!,
        );
      }
    } finally {
      isUpdatingForcedKyc.value = false;
    }
  }
}
