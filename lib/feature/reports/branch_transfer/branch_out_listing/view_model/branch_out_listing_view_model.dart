import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/branch_transfer/branch_out_listing/model/branch_out_report_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/branch_report_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BranchOutReportViewModel extends GetxController {
  final BranchReportRepository branchReportServices = BranchReportRepository();
  final ScrollController scrollController = ScrollController();

  final RxString searchQuery = "".obs;
  final RxInt currentPage = 1.obs;
  final RxInt nextOffsetId = 0.obs;
  final RxBool hasMoreData = false.obs;
  final RxBool isInitialized = false.obs;
  final RxBool itemDetailsShow = false.obs;
  RxList<LineItem>? selectedLineItem = RxList<LineItem>();

  final headers =
      [
        "Sn",
        "Transfer Code",
        "Transfer to",
        "Transfer By",
        "Date",
        "No of Items",
        " ",
      ].obs;

  final columnWidths = [0.45, 0.75, 0.75, 0.65, 0.65, 0.45, 0.1];

  final getBranchOutReportResponse = Rx<ApiResponse<BranchOutReportResponse>>(
    ApiResponse.initial("Initial"),
  );

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    _initializeData();
    super.onInit();
  }

  Future<void> _initializeData() async {
    await getBranchOutReportListing();
    isInitialized.value = true;
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> cancelBranchOutRecord(String recordId) async {
    try {
      await branchReportServices.cancelBranchOutRecord(recordId);
      await getBranchOutReportListing();
      showSuccessToast(message: 'Branch out record cancelled successfully');
    } catch (e) {
      log("Error cancelling branch out record: $e");
      showErrorToast(
        message: 'Failed to cancel branch out record: ${e.toString()}',
      );
    }
  }

  Future<void> getBranchOutReportListing({
    bool loadMore = false,
    String? stockHeadName,
  }) async {
    try {
      if (!loadMore) {
        getBranchOutReportResponse.value = ApiResponse.loading("Loading");
        currentPage.value = 1;
        nextOffsetId.value = 0;
      }

      final BranchOutReportResponse response = await branchReportServices
          .getBranchOutList(
            offsetId: loadMore ? nextOffsetId.value.toString() : null,
            query: stockHeadName ?? searchQuery.value,
          );

      if (!loadMore) {
        getBranchOutReportResponse.value = ApiResponse.completed(
          BranchOutReportResponse(
            values: response.values,
            pagination: response.pagination,
          ),
        );
      } else {
        final currentData = getBranchOutReportResponse.value.data;
        if (currentData != null && currentData.values != null) {
          currentData.values!.addAll(response.values ?? []);
          getBranchOutReportResponse.value = ApiResponse.completed(currentData);
        } else {
          getBranchOutReportResponse.value = ApiResponse.completed(response);
        }
      }

      nextOffsetId.value = response.pagination?.next ?? 0;
      hasMoreData.value = response.pagination?.next != null;
      currentPage.value++;
    } catch (e, stackTrace) {
      log('Error: $e');
      log('Stack trace: $stackTrace');
      getBranchOutReportResponse.value = ApiResponse.error(e.toString());
    } finally {
      isInitialized.value = true;
      update();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    getBranchOutReportListing();
  }

  Future<void> loadMoreData() async {
    if (hasMoreData.value) {
      await getBranchOutReportListing(loadMore: true);
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
