import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_in_listing/model/branch_in_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/branch_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BranchInReportViewModel extends GetxController {
  final BranchReportRepository branchReportServices = BranchReportRepository();
  final ScrollController scrollController = ScrollController();

  final RxString searchQuery = "".obs;
  final RxInt currentPage = 1.obs;
  final RxInt nextOffsetId = 0.obs;
  final RxBool hasMoreData = false.obs;
  final RxBool isInitialized = false.obs;
  final RxBool itemDetailsShow = false.obs;
  RxList<ValueLineItem>? selectedLineItem = RxList<ValueLineItem>();

  final headers =
      [
        "Code",
        "Branch Name",
        "Branch Transfer No.",
        "Total Items",
        "Total Weight(Gms)",
        " ",
      ].obs;

  final columnWidths = [0.45, 1.28, 0.70, 0.45, 0.65, 0.1];

  final getBranchInReportResponse = Rx<ApiResponse<BranchInReportResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    _initializeData();
    super.onInit();
  }

  Future<void> _initializeData() async {
    await getBranchInReportListing();
    isInitialized.value = true;
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> cancelBranchInRecord(
    String branchInNumber,
    String branchTransferFrom,
  ) async {
    try {
      await branchReportServices.cancelBranchInRecord(
        branchInNumber,
        branchTransferFrom,
      );
      await getBranchInReportListing();
      showSuccessToast(message: 'Branch in record cancelled successfully');
    } catch (e) {
      log("Error cancelling branch in record: $e");
      showErrorToast(
        message: 'Failed to cancel branch in record: ${e.toString()}',
      );
    }
  }

  void showCancelConfirmationDialog({
    required String branchTransferFrom,
    required String branchInNumber,
  }) {
    Get.dialog(
      CancelPaymentDialog(
        subtitle: 'Are you sure you want to cancel this branch in record?',
        onYesPressed: () async {
          await cancelBranchInRecord(branchInNumber, branchTransferFrom);
        },
      ),
    );
  }

  Future<void> getBranchInReportListing({
    bool loadMore = false,
    String? stockHeadName,
  }) async {
    try {
      if (!loadMore) {
        getBranchInReportResponse.value = ApiResponse.loading("Loading");
        currentPage.value = 1;
        nextOffsetId.value = 0;
      }

      final BranchInReportResponse response = await branchReportServices
          .getBranchInList(
            offsetId: loadMore ? nextOffsetId.value.toString() : null,
            query: stockHeadName ?? searchQuery.value,
          );

      if (!loadMore) {
        getBranchInReportResponse.value = ApiResponse.completed(
          BranchInReportResponse(
            values: response.values,
            pagination: response.pagination,
          ),
        );
      } else {
        final currentData = getBranchInReportResponse.value.data;
        if (currentData != null) {
          currentData.values.addAll(response.values);
          getBranchInReportResponse.value = ApiResponse.completed(currentData);
        } else {
          getBranchInReportResponse.value = ApiResponse.completed(response);
        }
      }

      nextOffsetId.value = response.pagination.next ?? 0;
      hasMoreData.value = response.pagination.next != null;
      currentPage.value++;
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack trace: $stackTrace');
      getBranchInReportResponse.value = ApiResponse.error(e.toString());
    } finally {
      isInitialized.value = true;
      update();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getBranchInReportListing();
  }

  Future<void> loadMoreData() async {
    if (hasMoreData.value) {
      await getBranchInReportListing(loadMore: true);
    }
  }

  String convertDateTimeToString(DateTime? dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (dateTime == null) return "-";
    return formatter.format(dateTime);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
