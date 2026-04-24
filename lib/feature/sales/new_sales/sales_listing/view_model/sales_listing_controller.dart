import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/base/utils/custom_debouncer.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/models/global_old_gold_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/sidebar_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/reports_filter/view_model/base_filter_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_listing_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/sales_listing_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/ledger_invoice_pdf.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_invoice_pdf_generator.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_invoice_pdf_generator_reprint.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/view_sales/view/view_sales_invoice_page.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/latest_widgets/cancel_payment_dialog.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/pos_printer/pos_thermal_printer.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/permission_function_gaurd.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/role_based_permission/rbac_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/textstyle.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_popup_menu_button_widget.dart';

import 'package:pdf/pdf.dart' show PdfPageFormat;

import 'package:printing/printing.dart';

class SalesListingController extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();

  final AggregateRepository aggregateRepository = AggregateRepository();

  final BaseFilterController filterController = Get.put(BaseFilterController());
  SalesListingRequest? _currentFilterRequest;
  RxInt selectedTabIndex = 0.obs;

  final formKey = GlobalKey<FormState>();

  void validateForm() {
    formKey.currentState!.validate();
  }

  final headers =
      [
        "Sn",
        "Date",
        "Invoice No",
        "Customer Name/ No.",
        "Pcs",
        "Sales weight",
        "Sales amount",
        "Old Gold Wt",
        "Old Gold Amt.",
        "Purchase Invoice",
        "Payment Status",
        "",
      ].obs;

  final columnWidths = [
    0.1,
    0.3,
    0.5,
    0.6,
    0.1,
    0.3,
    0.3,
    0.3,
    0.3,
    0.5,
    0.3,
    0.1,
  ];

  final _debouncer = CustomDebouncer(milliseconds: 500);

  final getApprovalListingResponse = Rx<ApiResponse<GetSalesPaginatedResponse>>(
    ApiResponse.initial("Initial"),
  );

  void applyMetalTypeFilter(int metalType) {
    final request = SalesListingRequest(
      filters: SalesFilters(metalType: [metalType.toString()]),
    );

    _currentFilterRequest = request;

    getSalesListing(resetList: true, requestBody: request);
  }

  SidebarController sidebarController = Get.find();

  final searchQuery = ''.obs;
  String? lastOffsetId;
  final isLoadingMore = false.obs;
  final hasMorePages = true.obs;
  final itemsPerPage = 10;
  bool isInvoice = false;

  @override
  void onInit() {
    log("Sales Listing Initialized");
    super.onInit();

    filterController.resetAllFilters();

    filterController.fetchAllDropdownData(
      filterTypes: [
        // 'metalType',
        'stockHead',
        'design',
        'branch',
        'dateRange',
        'itemStatus',
        'paymentStatus',
        'invoiceStatus',
        'vendor',
      ],
    );
  }

  SalesListingRequest createRequestFromFilters() {
    return SalesListingRequest(
      filters: SalesFilters(
        // Metal types
        // metalType: filterController.selectedMetalTypes.isNotEmpty
        //     ? filterController.selectedMetalTypes
        //         .where((item) => item.id != null)
        //         .map((item) => item.id!)
        //         .toList()
        //     : null,

        // Stock heads
        stockHead:
            filterController.selectedStockHeads.isNotEmpty
                ? filterController.selectedStockHeads
                    .where((item) => item.id != null)
                    .map((item) => item.id!)
                    .toList()
                : null,

        // Designs
        design:
            filterController.selectedDesigns.isNotEmpty
                ? filterController.selectedDesigns
                    .where((item) => item.id != null)
                    .map((item) => item.id!)
                    .toList()
                : null,

        // Branches
        branch:
            filterController.selectedBranches.isNotEmpty
                ? filterController.selectedBranches
                    .where((item) => item.id != null)
                    .map((item) => item.id!)
                    .toList()
                : null,

        // Party/Vendor IDs
        partyId:
            filterController.selectedVendors.isNotEmpty
                ? filterController.selectedVendors
                    .where((item) => item.id != null)
                    .map((item) => item.id!)
                    .toList()
                : null,

        // Date range
        dateFrom: filterController.dateFrom.value,
        dateTo: filterController.dateTo.value,
        itemStatus: filterController.selectedItemStatus.value?.value,
        invoiceStatus: filterController.selectedInvoiceStatus.value?.value,
        paymentStatus: filterController.selectedPaymentStatus.value?.value,
      ),
    );
  }

  void applyFilters() {
    // Create request from filters
    final requestBody = createRequestFromFilters();

    _currentFilterRequest = requestBody;

    // Call API with the filter request
    getSalesListing(isSearch: false, resetList: true, requestBody: requestBody);
  }

  TableRow buildTableHeaders() {
    List<Widget> cells = [];

    for (var i = 0; i < headers.length; i++) {
      cells.add(
        Row(
          children: [
            Flexible(
              child: CustomText(
                text: headers.elementAt(i),
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRows(BuildContext context) {
    return List.generate(
      getApprovalListingResponse.value.data?.values?.length ?? 0,
      (index) => buildTableRow(index),
    );
  }

  // UPDATED: Build popup menu items based on user permissions
  List<String> _buildPopupMenuItems() {
    final rbacController = Get.find<RBACController>();
    List<String> menuItems = [];

    // View action - 1052: view_invoice_details
    if (rbacController.hasAction(1052)) {
      menuItems.add("View");
    }

    // Print action - 1054: download (using download permission for print)
    if (rbacController.hasAction(1054)) {
      menuItems.add("Print");
      menuItems.add("Print Ledger");
      menuItems.add("Reprint");
    }

    // Cancel action - 1053: cancel_invoice
    menuItems.add("Cancel");
    if (rbacController.hasAction(1053)) {}
    return menuItems;
  }

  String formatDate(dynamic dateInput) {
    if (dateInput == null) return "-";

    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (e) {
        log('Error parsing date string: $e');
        return dateInput;
      }
    }

    if (date != null) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return "-";
    }
  }

  TableRow buildTableRow(int index) {
    List<Widget> cells = [];
    final approvalDetails = getApprovalListingResponse.value.data?.values
        ?.elementAt(index);

    log("The value is : ${approvalDetails?.toJson()}");
    for (int i = 0; i < headers.length; i++) {
      String cellContent = "-";
      TextDecoration? textDecoration;
      VoidCallback? onTapFunction;

      switch (i) {
        case 0:
          cellContent = (index + 1).toString();
          break;
        case 1:
          cellContent = formatDate(approvalDetails?.createdAt);
          break;
        case 2:
          cellContent = approvalDetails?.salesNumber ?? "-";
          textDecoration = TextDecoration.underline;
          onTapFunction = () {
            log("View sales open");
            // CORRECTED: Changed from 1053 to 1052 (view_invoice_details)
            PermissionGuardUtil.withActionPermission(
              1052, // sales > listing > view_invoice_details
              () {
                sidebarController.navigateToWidget(
                  newChild: ViewSalesInvoicePage(id: approvalDetails?.id ?? ""),
                );
              },
            );
          };
          break;
        case 3:
          cellContent =
              "${approvalDetails?.name}/${approvalDetails?.phoneNumber}";
          break;
        case 4:
          cellContent = approvalDetails?.pieces.toString() ?? "-";
          break;
        case 5: // sales weight
          cellContent = "${approvalDetails?.netWeight ?? "-"} gms";
          break;
        case 6: // sales amount
          cellContent = "₹${approvalDetails?.finalInvoiceAmount ?? "-"}";
          break;
        case 7: // Old gold weight
          cellContent = "${approvalDetails?.oldGoldGrossWeight ?? "-"} gms";
          break;
        case 8: // Old gold amount
          cellContent = "₹${approvalDetails?.oldGoldAmount ?? "-"}";
          break;
        case 9: // purchase invoice
          if (approvalDetails?.purchaseInvoices != null &&
              approvalDetails!.purchaseInvoices!.isNotEmpty) {
            cellContent = approvalDetails.purchaseInvoices!
                .map((invoice) => invoice.invoiceNumber ?? "-")
                .where((number) => number != "-" && number.isNotEmpty)
                .join(", ");

            // If no valid invoice numbers found, show "-"
            if (cellContent.isEmpty) {
              cellContent = "-";
            }
          } else {
            cellContent = "-";
          }
          // cellContent = approvalDetails?.purchaseInvoices?.invoiceNumber ?? "-";
          break;
        case 10: // payment status
          cellContent = approvalDetails?.paymentStatus.toString() ?? "";
          break;
        case 11: // action menu
          // UPDATED: Build dynamic popup menu based on permissions
          final popUpValues = _buildPopupMenuItems();

          // If user has no permissions for any action, don't show the menu
          if (popUpValues.isEmpty) {
            return TableRow(
              children: [
                ...cells,
                Column(
                  children: [
                    const SizedBox(height: 8),
                    const SizedBox(height: 7),
                    CustomDashedLineWidget(width: Get.width),
                  ],
                ),
              ],
            );
          }

          return TableRow(
            children: [
              ...cells,
              Column(
                children: [
                  const SizedBox(height: 8),
                  Theme(
                    data: ThemeData(
                      focusColor: greyTextColor,
                      tooltipTheme: const TooltipThemeData(
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),
                    ),
                    child: CustomPopupMenuButtonWidget<String>(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            ...popUpValues.map((element) {
                              return PopupMenuItem<String>(
                                value: element,
                                height: 0,
                                child: SizedBox(
                                  width: 98,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        element,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (element != popUpValues.last)
                                        CustomDashedLineWidget(
                                          width: Get.width,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                      onSelected: (String value) {
                        switch (value) {
                          case 'View':
                            // CORRECTED: Changed from 1053 to 1052 (view_invoice_details)
                            PermissionGuardUtil.withActionPermission(
                              1052, // sales > listing > view_invoice_details
                              () {
                                sidebarController.navigateToWidget(
                                  newChild: ViewSalesInvoicePage(
                                    id: approvalDetails?.id ?? "",
                                  ),
                                );
                              },
                            );
                            break;
                          case 'Print':
                            PermissionGuardUtil.withActionPermission(
                              1054, // sales > listing > download
                              () {
                                printInvoice(approvalDetails!);
                              },
                            );
                            break;
                          case 'Print Ledger':
                            PermissionGuardUtil.withActionPermission(1054, () {
                              printLedgerInvoice(approvalDetails!);
                            });
                            break;
                          case 'Reprint':
                            PermissionGuardUtil.withActionPermission(1054, () {
                              reprintInvoice(approvalDetails!);
                            });
                            break;
                          case 'Cancel':
                            // CORRECTED: Changed from 1054 to 1053 (cancel_invoice)
                            PermissionGuardUtil.withActionPermission(
                              1053, // sales > listing > cancel_invoice
                              () {
                                Get.dialog(
                                  CancelPaymentDialog(
                                    subtitle:
                                        'Are you sure you want to delete this sale?',
                                    onYesPressed: () async {
                                      await deleteSales(approvalDetails!.id!);
                                    },
                                  ),
                                );
                              },
                            );
                            break;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 7),
                  CustomDashedLineWidget(width: Get.width),
                ],
              ),
            ],
          );
      }

      // Create the cell widget with proper structure
      Widget cellWidget;

      if (onTapFunction != null) {
        // For clickable cells (like invoice number)
        cellWidget = GestureDetector(
          onTap: onTapFunction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Tooltip(
              message: cellContent,
              child: CustomText(
                text: cellContent,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                color: getActionIconColor(approvalDetails?.paymentStatus),
                decoration: textDecoration,
              ),
            ),
          ),
        );
      } else {
        // For non-clickable cells
        cellWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Tooltip(
            message: cellContent,
            child: CustomText(
              text: cellContent,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
              color: getPaymentStatusColor(cellContent),
              decoration: textDecoration,
            ),
          ),
        );
      }

      cells.add(
        Column(
          children: [
            Row(
              children: [
                if (i != 0) const SizedBox(width: 4),
                Flexible(child: cellWidget),
              ],
            ),
            CustomDashedLineWidget(width: Get.width),
          ],
        ),
      );
    }

    return TableRow(children: cells);
  }

  Color getPaymentStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Color getActionIconColor(String? status) {
    return status?.toLowerCase() == 'cancelled' ? Colors.red : Colors.blue;
  }

  final getSalesRecordByIdAggregateResponse =
      Rx<ApiResponse<GetSalesRecordByIdAggregateResponse>>(
        ApiResponse.initial("Initial"),
      );

  Future<void> getSalesRecordByIdAggregate({required String id}) async {
    try {
      getSalesRecordByIdAggregateResponse.value = ApiResponse.loading(
        "Loading",
      );
      final response = await aggregateRepository.getSalesRecordById(id: id);
      getSalesRecordByIdAggregateResponse.value = ApiResponse.completed(
        response,
      );
    } catch (e) {
      getSalesRecordByIdAggregateResponse.value = ApiResponse.error(
        e.toString(),
      );
      log(e.toString());
      showErrorToast(message: "$e");
    }
  }

  Future<void> printInvoice(GetSalesPaginatedResponseValue sale) async {
    try {
      // Get the global settings controller
      final globalSettingsController = Get.find<GlobalSettingsViewModel>();

      // First fetch the detailed sales record
      await getSalesRecordByIdAggregate(id: sale.id ?? "");

      if (getSalesRecordByIdAggregateResponse.value.status ==
              Status.COMPLETED &&
          getSalesRecordByIdAggregateResponse.value.data != null) {
        // Get global settings data
        GetGlobalSettingsResponse? globalSettings;
        if (globalSettingsController.getGlobalSettingsResponse.value.status ==
            Status.COMPLETED) {
          globalSettings =
              globalSettingsController.getGlobalSettingsResponse.value.data;
        }

        // Get the sales print template
        SalePrintTemplate? salePrintTemplate;
        if (globalSettings?.salePrintTemplates != null &&
            globalSettings!.salePrintTemplates!.isNotEmpty) {
          try {
            salePrintTemplate = globalSettings.salePrintTemplates!.firstWhere(
              (template) => template.templateNumber == 1,
            );
          } catch (e) {
            // If template number 1 not found, use first template
            salePrintTemplate = globalSettings.salePrintTemplates!.first;
          }
        }

        // Get the estimate print template (note: singular, not plural)
        final estimatePrintTemplate = globalSettings?.estimatePrintTemplate;

        // Check if estimate slip should be printed
        final shouldPrintEstimateSlip =
            salePrintTemplate?.printEstimate ?? false;

        final shouldPrintItemDifferenceSlip =
            salePrintTemplate?.itemDifferenceSlip ?? false;

        // Generate and print main invoice PDF
        final pdfBytes = await SalesInvoicePdfGenerator.generateInvoice(
          getSalesRecordByIdAggregateResponse.value.data!,
          globalSettings: globalSettings,
        );

        var availablePrinters = await Printing.listPrinters();
        for (var element in availablePrinters) {
          log("The available printers are ${element.url}");
        }

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: 'invoice_${sale.salesNumber}.pdf',
        );

        if (shouldPrintEstimateSlip) {
          log("Printing sales estimate slip...");
          // PosThermalPrinter thermalPrinter = PosThermalPrinter();
          // await thermalPrinter.printSalesEstimateSlip(
          //   salesRecord: getSalesRecordByIdAggregateResponse.value.data!,
          //   estimatePrintTemplate: estimatePrintTemplate,
          // );
          log("Sales estimate slip printed successfully");
        } else {
          log(
            "Sales estimate slip printing skipped - Enabled: $shouldPrintEstimateSlip",
          );
        }
        // Print old gold valuation if enabled
        await _printOldGoldValuationIfEnabled(
          getSalesRecordByIdAggregateResponse.value.data!,
          globalSettings,
        );

        if (shouldPrintItemDifferenceSlip) {
          log("Printing item difference slip...");
          // PosThermalPrinter thermalPrinter = PosThermalPrinter();
          // await thermalPrinter.printItemDifferenceSlip(
          //   salesRecord: getSalesRecordByIdAggregateResponse.value.data!,
          // );
          log("Item difference slip printed successfully");
        } else {
          log(
            "Item difference slip printing skipped - Enabled: $shouldPrintItemDifferenceSlip",
          );
        }
      } else {
        showErrorToast(message: 'Failed to fetch sales record details');
      }
    } catch (e) {
      log('Error generating PDF: $e');
      showErrorToast(message: 'Failed to generate invoice: ${e.toString()}');
    }
  }

  Future<void> _printOldGoldValuationIfEnabled(
    GetSalesRecordByIdAggregateResponse salesRecord,
    GetGlobalSettingsResponse? globalSettings,
  ) async {
    try {
      // Check if old_details_slip is enabled in global settings
      SalePrintTemplate? salePrintTemplate;
      if (globalSettings?.salePrintTemplates != null &&
          globalSettings!.salePrintTemplates!.isNotEmpty) {
        try {
          salePrintTemplate = globalSettings.salePrintTemplates!.firstWhere(
            (template) => template.templateNumber == 1,
          );
        } catch (e) {
          // If template number 1 not found, use first template
          salePrintTemplate = globalSettings.salePrintTemplates!.first;
        }
      }

      final shouldPrintOldGoldSlip = salePrintTemplate?.oldDetailsSlip ?? false;

      // Check if there are old golds and if printing is enabled
      if (!shouldPrintOldGoldSlip ||
          salesRecord.oldGolds == null ||
          salesRecord.oldGolds!.isEmpty) {
        log(
          "Old gold valuation slip printing skipped - Enabled: $shouldPrintOldGoldSlip, Has old golds: ${salesRecord.oldGolds?.isNotEmpty ?? false}",
        );
        return;
      }

      log(
        "Printing old gold valuation slip for ${salesRecord.oldGolds!.length} items",
      );

      // Convert sales record old golds to PostGlobalOldGoldResponse format
      final oldGoldResponse = _convertToPostGlobalOldGoldResponse(
        salesRecord.oldGolds!,
        salesRecord.purchaseInvoiceNumber,
      );

      // Print the valuation slip using thermal printer
      // PosThermalPrinter thermalPrinter = PosThermalPrinter();
      // await thermalPrinter.printOldGoldValuationSlip(
      //   oldGoldData: oldGoldResponse,
      //   InvoiceNo: salesRecord.saleNumber ?? "",
      // );

      log("Old gold valuation slip printed successfully");
    } catch (e, stackTrace) {
      log("Error printing old gold valuation slip: $e");
      log("Stack trace: $stackTrace");
      // Don't throw error - just log it so invoice printing isn't affected
      showErrorToast(
        message:
            "Invoice printed but failed to print old gold slip: ${e.toString()}",
      );
    }
  }

  PostGlobalOldGoldResponse _convertToPostGlobalOldGoldResponse(
    List<GetSalesRecordByIdAggregateOldGold> oldGolds,
    String? purchaseInvoiceNumber,
  ) {
    final values =
        oldGolds.map((oldGold) {
          return PostGlobalOldGoldResponseValue(
            id: oldGold.id,
            oldGoldEstimateNumber:
                oldGold.oldGoldEstimateNumber ?? purchaseInvoiceNumber,
            organizationId: oldGold.organizationId,
            shopId: oldGold.shopId,
            code: oldGold.code,
            description: oldGold.description,
            pieces: oldGold.pieces,
            grossWeight: oldGold.grossWeight,
            netWeight: oldGold.netWeight,
            less: oldGold.less,
            purityType: oldGold.purityType,
            ornamentId: oldGold.ornamentId,
            rate: oldGold.rate,
            amount: oldGold.amount,
            roundOff: oldGold.roundOff,
            total: oldGold.total,
            isReceived: oldGold.isReceived,
          );
        }).toList();

    return PostGlobalOldGoldResponse(values: values);
  }

  void setInitialConditions({required bool isSearch}) {
    lastOffsetId = null;
    hasMorePages.value = true;
    if (!isSearch) {
      searchQuery.value = '';
    }
  }

  Future<void> getSalesListing({
    bool resetList = false,
    bool isSearch = false,
    SalesListingRequest? requestBody,
  }) async {
    if (resetList) {
      setInitialConditions(isSearch: isSearch);
      getApprovalListingResponse.value = ApiResponse.loading("Loading");
    } else {
      isLoadingMore.value = true;
    }
    try {
      final effectiveRequestBody =
          requestBody ?? _currentFilterRequest ?? SalesListingRequest();

      final response = await _estimationRepository.getSalesPaginated(
        requestBody: effectiveRequestBody,
        offsetId: lastOffsetId,
        limit: itemsPerPage,
        query: searchQuery.value,
      );
      if (resetList) {
        getApprovalListingResponse.value = ApiResponse.completed(response);
      } else {
        final currentData = getApprovalListingResponse.value.data?.values ?? [];
        List<GetSalesPaginatedResponseValue> newData = [
          ...currentData,
          ...response.values ?? [],
        ];
        response.values = newData;
        getApprovalListingResponse.value = ApiResponse.completed(response);
      }
      hasMorePages.value = response.pagination?.next != null;
      if (hasMorePages.value && response.values?.isNotEmpty == true) {
        lastOffsetId = response.pagination?.next;
      }
    } catch (e) {
      getApprovalListingResponse.value = ApiResponse.error(e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> reprintInvoice(GetSalesPaginatedResponseValue sale) async {
    try {
      // First fetch the detailed sales record
      await getSalesRecordByIdAggregate(id: sale.id ?? "");

      if (getSalesRecordByIdAggregateResponse.value.status ==
              Status.COMPLETED &&
          getSalesRecordByIdAggregateResponse.value.data != null) {
        // Generate and print ledger PDF
        final pdfBytes = await SalesInvoiceReprintPdfGenerator.generateInvoice(
          getSalesRecordByIdAggregateResponse.value.data!,
        );

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: 'ledger_${sale.salesNumber}.pdf',
        );

        showSuccessToast(message: 'Ledger invoice printed successfully');
      } else {
        showErrorToast(message: 'Failed to fetch sales record details');
      }
    } catch (e) {
      log('Error generating ledger PDF: $e');
      showErrorToast(message: 'Failed to generate ledger: ${e.toString()}');
    }
  }

  Future<void> printLedgerInvoice(GetSalesPaginatedResponseValue sale) async {
    try {
      // First fetch the detailed sales record
      await getSalesRecordByIdAggregate(id: sale.id ?? "");

      if (getSalesRecordByIdAggregateResponse.value.status ==
              Status.COMPLETED &&
          getSalesRecordByIdAggregateResponse.value.data != null) {
        // Generate and print ledger PDF
        final pdfBytes = await LedgerInvoicePdfGenerator.generateLedger(
          getSalesRecordByIdAggregateResponse.value.data!,
        );

        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: 'ledger_${sale.salesNumber}.pdf',
        );

        showSuccessToast(message: 'Ledger invoice printed successfully');
      } else {
        showErrorToast(message: 'Failed to fetch sales record details');
      }
    } catch (e) {
      log('Error generating ledger PDF: $e');
      showErrorToast(message: 'Failed to generate ledger: ${e.toString()}');
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _debouncer.run(() {
      getSalesListing(resetList: true, isSearch: true);
    });
  }

  Future<void> loadMoreItems() async {
    if (!isLoadingMore.value && hasMorePages.value) {
      await getSalesListing();
    }
  }

  void resetFields() {}

  Future<void> deleteSales(String id) async {
    try {
      await _estimationRepository.deleteSales(id: id);
      // Refresh the list after successful cancellation
      await getSalesListing(resetList: true);
    } catch (e) {
      log("Error cancelling Sales $e");
      showErrorToast(message: 'Failed to cancel Sales: ${e.toString()}');
    }
  }
}
