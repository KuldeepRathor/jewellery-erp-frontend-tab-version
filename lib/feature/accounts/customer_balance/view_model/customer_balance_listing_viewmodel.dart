import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/accounts/customer_balance/models/customer_balances_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class CustomerBalanceListingViewmodel extends GetxController {
  final AggregateRepository _aggregateRepository = AggregateRepository();
  final headers =
      [
        'Sr',
        "Customer ID",
        'Name',
        'Phone',
        'Invoice No',
        'Date',
        "Balance Amount",
        "Due Date",
        "Item Status",
        "Payment Status",
        // ''
      ].obs;
  final columnWidths =
      [0.1, 0.43, 0.43, 0.43, 0.43, 0.43, 0.43, 0.43, 0.43, 0.43].obs;
  final _debouncer = CustomDebouncer(milliseconds: 500);

  final customerListingResponse =
      Rx<ApiResponse<CustomerBalancesAggregateResponse>>(
        ApiResponse.initial("INITIAL"),
      );

  final selectedStatusFilter = "Pending".obs;
  final statusFilterOptions = ["All", "Pending", "Completed"].obs;

  final filteredValues = <CustomerBalancesAggregateResponseValue>[].obs;
  final totalBalanceAmount = "0.00".obs;

  final searchQuery = ''.obs;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  String? lastOffsetId;

  final RxInt selectedRowIndex = (-1).obs;

  final RxString selectedAddress = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxString selectedItemsonHold = ''.obs;
  void updateSelectedRow(
    int index,
    CustomerBalancesAggregateResponseValue? rowData,
  ) {
    selectedRowIndex.value = index;

    if (rowData?.customerAddress?.address?.isNotEmpty ?? false) {
      selectedAddress.value =
          '${rowData?.customerAddress?.address?.first.addressLine1 ?? ''}, '
          '${rowData?.customerAddress?.address?.first.city ?? ''}, '
          '${rowData?.customerAddress?.address?.first.state ?? ''}';
    } else {
      selectedAddress.value = 'No address available';
    }

    if (rowData?.paymentCompletionDate != null) {
      selectedStatus.value =
          "Completed on ${convertDateTimeToString(rowData?.paymentCompletionDate)}";

      // Only add receipt info if either payment code exists
      if ((rowData?.lastPaymentCode != null &&
              rowData!.lastPaymentCode!.isNotEmpty) ||
          (rowData?.lastUniversalPaymentCode != null &&
              rowData!.lastUniversalPaymentCode!.isNotEmpty)) {
        selectedStatus.value +=
            "\nReceipt no: ${rowData.lastPaymentCode ?? ''} (${rowData.lastUniversalPaymentCode ?? ''})";
      }
    } else {
      selectedStatus.value = '';
    }

    if (rowData?.remainingItems?.isNotEmpty ?? false) {
      selectedItemsonHold.value = rowData!.remainingItems!
          .where((item) => item.text != null && item.text!.trim().isNotEmpty)
          .map((item) => item.text!)
          .join(', ');

      if (selectedItemsonHold.value.isEmpty) {
        selectedItemsonHold.value = '';
      }
    } else {
      selectedItemsonHold.value = '';
    }
  }

  void selectPreviousRow() {
    if (selectedRowIndex.value > 0) {
      final previousIndex = selectedRowIndex.value - 1;
      final previousRow = filteredValues[previousIndex];
      updateSelectedRow(previousIndex, previousRow);
    }
  }

  void selectNextRow() {
    final maxIndex = filteredValues.length - 1;
    if (selectedRowIndex.value < maxIndex) {
      final nextIndex = selectedRowIndex.value + 1;
      final nextRow = filteredValues[nextIndex];
      updateSelectedRow(nextIndex, nextRow);

      // Scroll to keep selected row visible
      if (nextIndex > (itemsPerPage / 2)) {
        loadMoreItems();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    log("Customer Listing viewmodel initiated");
    getCustomerListingDetails(resetList: true);
  }

  @override
  void onClose() {
    log("Customer Listing viewmodel Deleted");
    super.onClose();
  }

  void calculateTotalBalanceAmount() {
    try {
      double total = 0.0;
      final values = customerListingResponse.value.data?.values;

      if (values != null && values.isNotEmpty) {
        for (var item in values) {
          if (item.balanceAmount != null && item.balanceAmount != "-") {
            // Remove any currency symbols and commas
            String cleanedAmount = item.balanceAmount!.replaceAll(
              RegExp(r'[^0-9.]'),
              '',
            );

            try {
              double amount = double.parse(cleanedAmount);
              total += amount;
            } catch (e) {
              log("Error parsing balance amount: ${item.balanceAmount}");
            }
          }
        }
      }

      // Format total to 2 decimal places
      totalBalanceAmount.value = total.toStringAsFixed(2);
    } catch (e) {
      log("Error calculating total balance: $e");
      totalBalanceAmount.value = "0.00";
    }
  }

  TableRow buildTableHeaders() {
    log("The controllers length : ${headers.length} ");
    List<Widget> cells = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers.elementAt(i);
      cells.add(
        Row(
          children: [
            if (header != "Sr") const SizedBox(width: 4),
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (isSearch == false) {
      searchQuery.value = '';
    }
  }

  void applyStatusFilter(String status) {
    selectedStatusFilter.value = status;

    if (status == "All") {
      // Show all items
      filteredValues.value = customerListingResponse.value.data?.values ?? [];
    } else {
      // Filter by selected status
      filteredValues.value =
          customerListingResponse.value.data?.values
              ?.where((item) => item.paymentStatus == status)
              .toList() ??
          [];
    }

    // Recalculate total for filtered items
    calculateFilteredTotalBalanceAmount();
    if (filteredValues.isEmpty) {
      selectedRowIndex.value = -1;
    } else if (selectedRowIndex.value >= filteredValues.length) {
      selectedRowIndex.value = 0;
    }
  }

  void calculateFilteredTotalBalanceAmount() {
    try {
      double total = 0.0;
      final values = filteredValues;

      if (values.isNotEmpty) {
        for (var item in values) {
          if (item.balanceAmount != null && item.balanceAmount != "-") {
            // Remove any currency symbols and commas
            String cleanedAmount = item.balanceAmount!.replaceAll(
              RegExp(r'[^0-9.]'),
              '',
            );

            try {
              double amount = double.parse(cleanedAmount);
              total += amount;
            } catch (e) {
              log("Error parsing balance amount: ${item.balanceAmount}");
            }
          }
        }
      }

      // Format total to 2 decimal places
      totalBalanceAmount.value = total.toStringAsFixed(2);
    } catch (e) {
      log("Error calculating total balance: $e");
      totalBalanceAmount.value = "0.00";
    }
  }

  Future<void> getCustomerListingDetails({
    bool resetList = false,
    bool isSearch = false,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      customerListingResponse.value = ApiResponse.loading("LOADING");
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response =
          await _aggregateRepository.getCustomerBalancesAggregate();

      if (resetList) {
        customerListingResponse.value = ApiResponse.completed(response);

        // Initialize filtered list with all values
        filteredValues.value = response.values ?? [];

        // Apply any existing status filter
        if (selectedStatusFilter.value != "All") {
          applyStatusFilter(selectedStatusFilter.value);
        } else {
          calculateFilteredTotalBalanceAmount();
        }

        if (filteredValues.isNotEmpty) {
          selectedRowIndex.value = 0;
        } else {
          selectedRowIndex.value = -1;
        }
      } else {
        // Handle pagination if needed
      }

      hasMorePages.value = false;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = null;
      }
    } catch (e) {
      if (resetList) {
        customerListingResponse.value = ApiResponse.error(e.toString());
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    log("Loading more ${!isLoadingMore.value} : ${hasMorePages.value}");
    if (!isLoadingMore.value && hasMorePages.value) {
      log("Loading more called");
      await getCustomerListingDetails();
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    log("Setting search query ${searchQuery.value}");
    _debouncer.run(() async {
      await getCustomerListingDetails(resetList: true, isSearch: true);
    });
  }
}
