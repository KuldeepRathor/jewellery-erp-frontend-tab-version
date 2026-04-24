// Feature View Model
// ignore_for_file: unused_field, avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_exceptions.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_error_models/purchase_invoice_error_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_request_models/purchase_invoice_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/purchase_invoice_response_models/purchase_invoice_paginated_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/purchase_invoice_repository.dart';

class PurchaseInvoiceViewmodel extends GetxController {
  // Initialize the required variables with model
  final PurchaseInvoiceRepository _purchaseInvoiceRepository =
      PurchaseInvoiceRepository();
  final postPurchaseInvoiceResponse = Rx<ApiResponse<PurchaseInvoiceModel>>(
    ApiResponse.initial('Empty data'),
  );
  final getPurchaseInvoiceResponse =
      Rx<ApiResponse<PaginatedGetPurchaseListingResponse>>(
        ApiResponse.initial('Empty data'),
      );

  // Make necessary Functions

  ApiResponse<PurchaseInvoiceModel> handlePurchaseInvoiceResponseErrors(
    Object error,
  ) {
    String message = "Something went wrong :";
    if (error is BadRequestException) {
      BadRequestException err = error;
      print(err.message.runtimeType);
      print(err.message);
      log("Bad Request Exception");
      PurchaseInvoiceErrorResponse errorResponse =
          PurchaseInvoiceErrorResponse.fromJson(err.message);
      for (Detail element in errorResponse.detail ?? []) {
        message = "$message\n${element.msg}";
      }
    }
    return ApiResponse.error(message);
  }

  Future<void> postPurchaseInvoice({
    required PurchaseInvoiceRequestModel purchaseInvoiceRequest,
  }) async {
    postPurchaseInvoiceResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await _purchaseInvoiceRepository.addPurchaseInvoice(
        purchaseInvoiceRequest: purchaseInvoiceRequest,
      );
      postPurchaseInvoiceResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in postPurchaseInvoice $e \n $s");
      postPurchaseInvoiceResponse.value = handlePurchaseInvoiceResponseErrors(
        e,
      );
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

  Future<void> getPurchaseInvoice({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getPurchaseInvoiceResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _purchaseInvoiceRepository.getPurchaseInvoice(
        query: searchQuery.value,
        limit: itemsPerPage,
        offsetId: lastOffsetId,
      );

      if (resetList) {
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
      } else {
        // Add to the end of the list
        final currentData = getPurchaseInvoiceResponse.value.data?.values ?? [];
        List<PurchaseInvoiceModel> newData = [
          ...currentData,
          ...response.values ?? [],
        ];

        response.values = newData;
        getPurchaseInvoiceResponse.value = ApiResponse.completed(response);
      }

      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        if (response.pagination?.next != null) {
          lastOffsetId = response.pagination?.next;
        }
      }
    } catch (e) {
      if (resetList) {
        getPurchaseInvoiceResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}
