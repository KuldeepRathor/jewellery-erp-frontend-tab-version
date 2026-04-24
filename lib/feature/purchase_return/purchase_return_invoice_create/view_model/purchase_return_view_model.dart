import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_error_models/purchase_invoice_error_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_resturn_response_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_invoice_create/models/post_purchase_return_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_listing/models/get_paginated_purchase_return_listing_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';

class PurchaseReturnInvoiceViewmodel extends GetxController {
  // Initialize the required variables with model
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();

  final postPurchaseReturnInvoiceResponse =
      Rx<ApiResponse<PurchaseReturnResponseModel>>(
        ApiResponse.initial('Empty data'),
      );

  final getPurchaseReturnInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseReturnListingResponse>>(
        ApiResponse.initial('Empty data'),
      );

  // Make necessary Functions

  ApiResponse<PurchaseReturnResponseModel>
  handlePurchaseReturnInvoiceResponseErrors(Object error) {
    String message = "Something went wrong: ";
    if (error is BadRequestException) {
      BadRequestException err = error;
      log("Bad Request Exception: ${err.message}");

      try {
        PurchaseInvoiceErrorResponse errorResponse =
            PurchaseInvoiceErrorResponse.fromJson(err.message);
        for (Detail element in errorResponse.detail ?? []) {
          message = "$message\n${element.msg}";
        }
      } catch (e) {
        message = "${err.message}";
      }
    }
    return ApiResponse.error(message);
  }

  Future<void> postPurchaseReturnInvoice({
    required PurchaseReturnRequestModel purchaseReturnRequestModel,
  }) async {
    postPurchaseReturnInvoiceResponse.value = ApiResponse.loading("Loading");

    try {
      final response = await _purchaseInvoiceRepository
          .addPurchaseReturnInvoice(
            purchaseReturnRequestModel: purchaseReturnRequestModel,
          );
      postPurchaseReturnInvoiceResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in postPurchaseReturnInvoice: $e\n$s");
      postPurchaseReturnInvoiceResponse
          .value = handlePurchaseReturnInvoiceResponseErrors(e);
      rethrow;
    }
  }

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;
  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  Future<void> getPurchaseReturnInvoice({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPurchaseReturnInvoiceResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _purchaseInvoiceRepository
          .getPurchaseReturnInvoices(
            query: searchQuery.value,
            limit: itemsPerPage,
            offsetId: lastOffsetId,
          );

      if (resetList) {
        getPurchaseReturnInvoiceResponse.value = ApiResponse.completed(
          response,
        );
      } else {
        // Add to the end of the list
        final currentData =
            getPurchaseReturnInvoiceResponse.value.data?.values ?? [];
        List<PurchaseReturnResponseModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getPurchaseReturnInvoiceResponse.value = ApiResponse.completed(
          response,
        );
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.values?.last.id;
      }
    } catch (e) {
      if (resetList) {
        getPurchaseReturnInvoiceResponse.value = ApiResponse.error(
          e.toString(),
        );
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}
