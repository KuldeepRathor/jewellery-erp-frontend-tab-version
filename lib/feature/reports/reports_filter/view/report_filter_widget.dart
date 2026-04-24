import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/item_statement_report/view_model/item_statement_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view/generic_filter_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_and_value_statement/view_model/stock_and_value_statement_report_view_model.dart'
    hide DropdownItem;

class ReportFilterWidget extends StatefulWidget {
  final BaseFilterController controller;
  final List<String> visibleFilters;
  final Function() onApplyFilters;
  final List<Widget>? additionalFilters;

  const ReportFilterWidget({
    super.key,
    required this.controller,
    required this.visibleFilters,
    required this.onApplyFilters,
    this.additionalFilters,
  });

  @override
  State<ReportFilterWidget> createState() => _ReportFilterWidgetState();
}

class _ReportFilterWidgetState extends State<ReportFilterWidget> {
  late BaseFilterController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  List<FilterGroup> _buildFilterGroups() {
    final filterGroups = <FilterGroup>[];

    if (widget.visibleFilters.contains('metalType')) {
      filterGroups.add(
        FilterGroup(
          title: 'Metal Type',
          options: _convertDropdownItemsToFilterItems(
            controller.metalTypeResponse.value.data ?? [],
            controller.selectedMetalTypes, // Changed to use the list
          ),
          isLoading:
              controller.metalTypeResponse.value.status == Status.LOADING,
          error:
              controller.metalTypeResponse.value.status == Status.ERROR
                  ? controller.metalTypeResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('ornament')) {
      filterGroups.add(
        FilterGroup(
          title: 'Ornament',
          options: _convertDropdownItemsToFilterItems(
            controller.ornamentResponse.value.data ?? [],
            controller.selectedOrnaments, // Changed to use the list
          ),
          isLoading: controller.ornamentResponse.value.status == Status.LOADING,
          error:
              controller.ornamentResponse.value.status == Status.ERROR
                  ? controller.ornamentResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('weightGroup')) {
      filterGroups.add(
        FilterGroup(
          title: 'Weight Group',
          options: _convertDropdownItemsToFilterItems(
            controller.weightGroupResponse.value.data ?? [],
            controller.selectedWeightGroups, // Changed to use the list
          ),
          isLoading:
              controller.weightGroupResponse.value.status == Status.LOADING,
          error:
              controller.weightGroupResponse.value.status == Status.ERROR
                  ? controller.weightGroupResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('stockHead')) {
      filterGroups.add(
        FilterGroup(
          title: 'Stock Head',
          options: _convertDropdownItemsToFilterItems(
            controller.stockHeadResponse.value.data ?? [],
            controller.selectedStockHeads, // Changed to use the list
          ),
          isLoading:
              controller.stockHeadResponse.value.status == Status.LOADING,
          error:
              controller.stockHeadResponse.value.status == Status.ERROR
                  ? controller.stockHeadResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('design')) {
      filterGroups.add(
        FilterGroup(
          title: 'Design',
          options: _convertDropdownItemsToFilterItems(
            controller.designResponse.value.data ?? [],
            controller.selectedDesigns, // Changed to use the list
          ),
          isLoading: controller.designResponse.value.status == Status.LOADING,
          error:
              controller.designResponse.value.status == Status.ERROR
                  ? controller.designResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('purity')) {
      filterGroups.add(
        FilterGroup(
          title: 'Purity',
          options: _convertDropdownItemsToFilterItems(
            controller.purityResponse.value.data ?? [],
            controller.selectedPurities, // Changed to use the list
          ),
          isLoading: controller.purityResponse.value.status == Status.LOADING,
          error:
              controller.purityResponse.value.status == Status.ERROR
                  ? controller.purityResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('counter')) {
      filterGroups.add(
        FilterGroup(
          title: 'Counter',
          options: _convertDropdownItemsToFilterItems(
            controller.counterResponse.value.data ?? [],
            controller.selectedCounters, // Changed to use the list
          ),
          isLoading: controller.counterResponse.value.status == Status.LOADING,
          error:
              controller.counterResponse.value.status == Status.ERROR
                  ? controller.counterResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('vendor')) {
      filterGroups.add(
        FilterGroup(
          title: 'Vendor',
          options: _convertDropdownItemsToFilterItems(
            controller.vendorResponse.value.data ?? [],
            controller.selectedVendors, // Changed to use the list
          ),
          isLoading: controller.vendorResponse.value.status == Status.LOADING,
          error:
              controller.vendorResponse.value.status == Status.ERROR
                  ? controller.vendorResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('taggedBy')) {
      filterGroups.add(
        FilterGroup(
          title: 'Tagged By',
          options: _convertDropdownItemsToFilterItems(
            controller.taggedByResponse.value.data ?? [],
            controller.selectedTaggedBys, // Changed to use the list
          ),
          isLoading: controller.taggedByResponse.value.status == Status.LOADING,
          error:
              controller.taggedByResponse.value.status == Status.ERROR
                  ? controller.taggedByResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('branch')) {
      filterGroups.add(
        FilterGroup(
          title: 'Branch',
          options: _convertDropdownItemsToFilterItems(
            controller.branchResponse.value.data ?? [],
            controller.selectedBranches, // Changed to use the list
          ),
          isLoading: controller.branchResponse.value.status == Status.LOADING,
          error:
              controller.branchResponse.value.status == Status.ERROR
                  ? controller.branchResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('size')) {
      filterGroups.add(
        FilterGroup(
          title: 'Size',
          options: _convertDropdownItemsToFilterItems(
            controller.sizeResponse.value.data ?? [],
            controller.selectedSizes, // Changed to use the list
          ),
          isLoading: controller.sizeResponse.value.status == Status.LOADING,
          error:
              controller.sizeResponse.value.status == Status.ERROR
                  ? controller.sizeResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('status')) {
      filterGroups.add(
        FilterGroup(
          title: 'Status',
          options: _convertDropdownItemsToFilterItems(
            controller.statusResponse.value.data ?? [],
            controller.selectedStatuses, // Changed to use the list
          ),
          isLoading: controller.statusResponse.value.status == Status.LOADING,
          error:
              controller.statusResponse.value.status == Status.ERROR
                  ? controller.statusResponse.value.message
                  : null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('itemStatus')) {
      filterGroups.add(
        FilterGroup(
          title: 'Item Status',
          options: _convertDropdownItemsToFilterItems(
            controller.itemStatusList,
            controller.selectedItemStatuses,
          ),
          isLoading: false,
          error: null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('invoiceStatus')) {
      filterGroups.add(
        FilterGroup(
          title: 'Invoice Status',
          options: _convertDropdownItemsToFilterItems(
            controller.invoiceStatusList,
            controller.selectedInvoiceStatuses,
          ),
          isLoading: false,
          error: null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('paymentStatus')) {
      filterGroups.add(
        FilterGroup(
          title: 'Payment Status',
          options: _convertDropdownItemsToFilterItems(
            controller.paymentStatusList,
            controller.selectedPaymentStatuses,
          ),
          isLoading: false,
          error: null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('transactionTypes')) {
      filterGroups.add(
        FilterGroup(
          title: 'Transaction Types',
          options: _convertDropdownItemsToFilterItems(
            controller.transactionTypesList,
            controller.selectedTransactionTypeses,
          ),
          isLoading: false,
          error: null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('other')) {
      filterGroups.add(
        FilterGroup(
          title: 'Other',
          options: _convertDropdownItemsToFilterItems(
            controller.otherList,
            controller.selectedOthers,
          ),
          isLoading: false,
          error: null,
          controller: controller,
        ),
      );
    }

    if (widget.visibleFilters.contains('grossWeight')) {
      filterGroups.add(
        FilterGroup(
          title: 'Gross Weight',
          options: [], // Empty options as we're using a range input
          filterType: FilterType.range,
          rangeValues: RangeFilterValues(
            min: controller.minGrossWeight.value?.toString(),
            max: controller.maxGrossWeight.value?.toString(),
          ),
        ),
      );
    }

    if (widget.visibleFilters.contains('netWeight')) {
      filterGroups.add(
        FilterGroup(
          title: 'Net Weight',
          options: [], // Empty options as we're using a range input
          filterType: FilterType.range,
          rangeValues: RangeFilterValues(
            min: controller.minNetWeight.value?.toString(),
            max: controller.maxNetWeight.value?.toString(),
          ),
        ),
      );
    }

    if (widget.visibleFilters.contains('pendingAmount')) {
      filterGroups.add(
        FilterGroup(
          title: 'Pending Amount',
          options: [], // Empty options as we're using a range input
          filterType: FilterType.range,
          rangeValues: RangeFilterValues(
            min: controller.minPendingAmount.value?.toString(),
            max: controller.maxPendingAmount.value?.toString(),
          ),
        ),
      );
    }

    if (widget.visibleFilters.contains('dateRange')) {
      filterGroups.add(
        FilterGroup(
          title: 'Date Range',
          options: [], // Empty options as we're using a date range input
          filterType: FilterType.dateRange, // Add this new filter type
          dateRangeValues: DateRangeFilterValues(
            from: controller.dateFrom.value,
            to: controller.dateTo.value,
          ),
        ),
      );
    }

    if (widget.visibleFilters.contains('recordNumber')) {
      filterGroups.add(
        FilterGroup(
          title: 'Rec No',
          options: [], // Empty options as we're using a range input
          filterType: FilterType.range,
          rangeValues: RangeFilterValues(
            min: controller.minRecordNumber.value,
            max: controller.maxRecordNumber.value,
          ),
        ),
      );
    }

    if (widget.visibleFilters.contains('lotNumber')) {
      filterGroups.add(
        FilterGroup(
          title: 'Lot No',
          options: [], // Empty options as we're using a range input
          filterType: FilterType.range,
          rangeValues: RangeFilterValues(
            min: controller.minLotNumber.value,
            max: controller.maxLotNumber.value,
          ),
        ),
      );
    }
    if (widget.visibleFilters.contains('incGrossWeight')) {
      // Check which view model is active to get the correct toggle state
      bool isEnabled = false;
      if (Get.isRegistered<ItemStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<ItemStatementReportViewModel>();
          isEnabled = viewModel.inclusiveGrossWeight;
        } catch (e) {
          // If ItemStatementReportViewModel is not found, use controller value
          isEnabled = controller.inclusiveGrossWeight.value;
        }
      } else {
        // Use base controller value
        isEnabled = controller.inclusiveGrossWeight.value;
      }

      filterGroups.add(
        FilterGroup(
          title: 'Inc Gr.wt',
          options: [], // Empty options as we're using a toggle
          filterType: FilterType.toggle,
          toggleValue: ToggleFilterValue(isEnabled: isEnabled),
        ),
      );
    }

    if (widget.visibleFilters.contains('incAmount')) {
      // Check which view model is active to get the correct toggle state
      bool isEnabled = false;
      if (Get.isRegistered<StockAndValueStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<StockAndValueStatementReportViewModel>();
          isEnabled = viewModel.inclusiveAmount;
        } catch (e) {
          // If StockAndValueStatementReportViewModel is not found, use controller value
          isEnabled = controller.inclusiveAmount.value;
        }
      } else {
        // Use base controller value
        isEnabled = controller.inclusiveAmount.value;
      }

      filterGroups.add(
        FilterGroup(
          title: 'Inc Amount',
          options: [], // Empty options as we're using a toggle
          filterType: FilterType.toggle,
          toggleValue: ToggleFilterValue(isEnabled: isEnabled),
        ),
      );
    }

    return filterGroups;
  }

  // Updated method to handle lists instead of single values
  List<FilterItem> _convertDropdownItemsToFilterItems(
    List<DropdownItem> items,
    List<DropdownItem> selectedItems,
  ) {
    return items
        .where((item) => item.id != null) // Filter out null items
        .map(
          (item) => FilterItem(
            id: item.id!,
            name: item.name ?? '',
            isSelected: selectedItems.any((selected) => selected.id == item.id),
          ),
        )
        .toList();
  }

  void _handleFiltersApplied(
    Map<String, List<String>> selectedFilters,
    Map<String, RangeFilterValues> rangeFilters,
    Map<String, DateRangeFilterValues> dateRangeFilters,
    Map<String, bool> toggleFilters,
  ) {
    // Handle enum filters explicitly
    if (selectedFilters.containsKey('Item Status')) {
      final values = selectedFilters['Item Status'];
      if (values!.isNotEmpty) {
        controller.setItemStatus(values.first);
      } else if (widget.visibleFilters.contains('itemStatus')) {
        controller.setItemStatus(null);
      }
    } else if (widget.visibleFilters.contains('itemStatus')) {
      controller.setItemStatus(null);
    }

    if (selectedFilters.containsKey('Payment Status')) {
      final values = selectedFilters['Payment Status'];
      if (values!.isNotEmpty) {
        controller.setPaymentStatus(values.first);
      } else if (widget.visibleFilters.contains('paymentStatus')) {
        controller.setPaymentStatus(null);
      }
    } else if (widget.visibleFilters.contains('paymentStatus')) {
      controller.setPaymentStatus(null);
    }

    if (selectedFilters.containsKey('Invoice Status')) {
      final values = selectedFilters['Invoice Status'];
      if (values!.isNotEmpty) {
        controller.setInvoiceStatus(values.first);
      } else if (widget.visibleFilters.contains('invoiceStatus')) {
        controller.setInvoiceStatus(null);
      }
    } else if (widget.visibleFilters.contains('invoiceStatus')) {
      controller.setInvoiceStatus(null);
    }

    if (selectedFilters.containsKey('Transaction Types')) {
      final values = selectedFilters['Transaction Types'];
      if (values!.isNotEmpty) {
        controller.setTransactionTypes(values.first);
      } else if (widget.visibleFilters.contains('transactionTypes')) {
        controller.setTransactionTypes(null);
      }
    } else if (widget.visibleFilters.contains('transactionTypes')) {
      controller.setTransactionTypes(null);
    }

    if (selectedFilters.containsKey('Other')) {
      final values = selectedFilters['Other'];
      if (values!.isNotEmpty) {
        controller.setOther(values.first);
      } else if (widget.visibleFilters.contains('other')) {
        controller.setOther(null);
      }
    } else if (widget.visibleFilters.contains('other')) {
      controller.setOther(null);
    }

    // Since the controller is already being updated through the toggle methods
    // in the generic_filter_widget, we don't need to do anything here for
    // checkbox filters. The controller already has the correct selected values.

    // The generic_filter_widget is calling the toggle methods directly,
    // so the controller's lists are already updated.

    // Handle range filters
    // Handle Gross Weight - explicitly set to null if not in rangeFilters
    if (rangeFilters.containsKey('Gross Weight')) {
      final values = rangeFilters['Gross Weight']!;
      int? minValue =
          values.min != null && values.min!.isNotEmpty
              ? int.tryParse(values.min!)
              : null;
      int? maxValue =
          values.max != null && values.max!.isNotEmpty
              ? int.tryParse(values.max!)
              : null;
      controller.setGrossWeightRange(minValue, maxValue);
    } else if (widget.visibleFilters.contains('grossWeight')) {
      // If grossWeight was a visible filter but not in rangeFilters, it was cleared
      controller.setGrossWeightRange(null, null);
    }

    // Handle Net Weight - explicitly set to null if not in rangeFilters
    if (rangeFilters.containsKey('Net Weight')) {
      final values = rangeFilters['Net Weight']!;
      int? minValue =
          values.min != null && values.min!.isNotEmpty
              ? int.tryParse(values.min!)
              : null;
      int? maxValue =
          values.max != null && values.max!.isNotEmpty
              ? int.tryParse(values.max!)
              : null;
      controller.setNetWeightRange(minValue, maxValue);
    } else if (widget.visibleFilters.contains('netWeight')) {
      // If netWeight was a visible filter but not in rangeFilters, it was cleared
      controller.setNetWeightRange(null, null);
    }

    if (rangeFilters.containsKey('Pending Amount')) {
      final values = rangeFilters['Pending Amount']!;
      String? minValue =
          values.min != null && values.min!.isNotEmpty ? values.min : null;
      String? maxValue =
          values.max != null && values.max!.isNotEmpty ? values.max : null;
      controller.setPendingAmountRange(minValue, maxValue);
    } else if (widget.visibleFilters.contains('pendingAmount')) {
      // If grossWeight was a visible filter but not in rangeFilters, it was cleared
      controller.setPendingAmountRange(null, null);
    }

    // Handle Date Range - explicitly set to null if not in dateRangeFilters
    if (dateRangeFilters.containsKey('Date Range')) {
      final values = dateRangeFilters['Date Range']!;
      controller.setDateRange(values.from, values.to);
    } else if (widget.visibleFilters.contains('dateRange')) {
      // If dateRange was a visible filter but not in dateRangeFilters, it was cleared
      controller.setDateRange(null, null);
    }

    // Handle Record Number Range
    if (rangeFilters.containsKey('Rec No')) {
      final values = rangeFilters['Rec No']!;
      String? minValue = values.min;
      String? maxValue = values.max;
      controller.setRecordNumberRange(minValue, maxValue);
    } else if (widget.visibleFilters.contains('recordNumber')) {
      // If recordNumber was a visible filter but not in rangeFilters, it was cleared
      controller.setRecordNumberRange(null, null);
    }

    // Handle Lot Number Range
    if (rangeFilters.containsKey('Lot No')) {
      final values = rangeFilters['Lot No']!;
      String? minValue = values.min;
      String? maxValue = values.max;
      controller.setLotNumberRange(minValue, maxValue);
    } else if (widget.visibleFilters.contains('lotNumber')) {
      // If lotNumber was a visible filter but not in rangeFilters, it was cleared
      controller.setLotNumberRange(null, null);
    }

    if (toggleFilters.containsKey('Inc Gr.wt')) {
      controller.setInclusiveGrossWeight(toggleFilters['Inc Gr.wt']!);

      // Update the specific view model if it exists
      if (Get.isRegistered<ItemStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<ItemStatementReportViewModel>();
          viewModel.inclusiveGrossWeight = toggleFilters['Inc Gr.wt']!;
          viewModel.update();
        } catch (e) {
          // Handle error silently
        }
      }

      if (Get.isRegistered<StockAndValueStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<StockAndValueStatementReportViewModel>();
          viewModel.inclusiveGrossWeight = toggleFilters['Inc Gr.wt']!;
          viewModel.update();
        } catch (e) {
          // Handle error silently
        }
      }
    }

    if (toggleFilters.containsKey('Inc Amount')) {
      controller.setInclusiveAmount(toggleFilters['Inc Amount']!);

      // Update the specific view model if it exists
      if (Get.isRegistered<ItemStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<ItemStatementReportViewModel>();
          viewModel.inclusiveAmount = toggleFilters['Inc Amount']!;
          viewModel.update();
        } catch (e) {
          // Handle error silently
        }
      }

      if (Get.isRegistered<StockAndValueStatementReportViewModel>()) {
        try {
          final viewModel = Get.find<StockAndValueStatementReportViewModel>();
          viewModel.inclusiveAmount = toggleFilters['Inc Amount']!;
          viewModel.update();
        } catch (e) {
          // Handle error silently
        }
      }
    }

    widget.onApplyFilters();
  }

  void _handleReset() {
    controller.resetAllFilters();
    widget.onApplyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Obx(
            () => FilterButton(
              filterGroups: _buildFilterGroups(),
              onFiltersApplied: _handleFiltersApplied,
              isLoading: controller.isAnyFilterLoading,
              onReset: _handleReset,
              controller: controller, // Pass the controller to FilterButton
            ),
          ),
        ],
      ),
    );
  }
}
