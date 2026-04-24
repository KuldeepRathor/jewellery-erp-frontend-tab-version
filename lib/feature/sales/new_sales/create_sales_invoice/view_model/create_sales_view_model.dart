import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/models/global_old_gold_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart'
    hide MetalType;
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sequences_dropdown_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/advance_booking/sales_advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_payment_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/create_sales_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/jewellery_plan/sales_jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/view_model/old_gold/sales_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_listing_paginated_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart'
    hide MetalType;

import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/view_model/sales_invoice_pdf_generator.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/aggregate_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/error_handler.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/pos_printer/pos_thermal_printer.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';
import 'package:printing/printing.dart';

class CreateSalesViewModel extends GetxController {
  final EstimationRepository estimationRepository = EstimationRepository();
  final AggregateRepository _aggregateRepository = AggregateRepository();

  final RxBool isFastMode = true.obs;
  final RxBool isStoreSale = true.obs;
  final RxString salesNumber = ''.obs;

  final TextEditingController estimateNumberTextController =
      TextEditingController();
  final TextEditingController referenceInvoicTextController =
      TextEditingController();

  final sequencesDropdownResponse =
      Rx<ApiResponse<GetSequencesDropdownResponse>>(
        ApiResponse.initial("INITIAL"),
      );
  final sequencesDropdownList = <GetSequencesDropdownValue>[].obs;
  final selectedSequence = Rx<GetSequencesDropdownValue?>(null);
  final sequencesDropdownController = TextEditingController();
  final sequencesDropdownFocusNode = FocusNode();

  final RxInt selectedMetalType = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchSalesNumber();
    loadSequencesDropdown();
  }

  @override
  void onClose() {
    sequencesDropdownController.dispose();
    sequencesDropdownFocusNode.dispose();
    sequencesDropdownList.clear();
    loadSequencesDropdown();
    super.onClose();
  }

  void toggleFastMode() => isFastMode.toggle();
  void toggleStoreSale() => isStoreSale.toggle();

  void clearControllers() {
    isFastMode.value = true;
    selectedMetalType.value = 1;
    estimateNumberTextController.text = "";
    sequencesDropdownList.clear();
    selectedSequence.value = null;
    loadSequencesDropdown();
  }

  bool get isRateInvalid {
    final controller = Get.find<CreateSalesItemDetailsController>();

    return controller.controllers.any((item) {
      final rate = item.rate.text.trim();
      return rate.isEmpty || rate == "0" || rate == "null" || rate == "-";
    });
  }

  void setMetalType(int metalType) {
    selectedMetalType.value = metalType;
    loadSequencesDropdown();

    // Update the rate/carat input based on metal type
    final RateCaratInputController rateController =
        Get.find<RateCaratInputController>();
    rateController.setCaratForMetalType(metalType);

    // Update all items with the new rate
    final CreateSalesItemDetailsController itemDetailsController =
        Get.find<CreateSalesItemDetailsController>();
    final String caratValue = rateController.getPurityFromCarat(
      rateController.selectedCarat.value,
    );
    final double rate = double.tryParse(rateController.currentRate) ?? 0;

    // Update rates for all items
    itemDetailsController.onRateChanged(rate, caratValue);
    log('Metal type changed to: $metalType');
  }

  Future<void> loadSequencesDropdown({
    String? voucherType = "1",
    String? voucherSection,
  }) async {
    try {
      sequencesDropdownResponse.value = ApiResponse.loading(
        "Loading sequences...",
      );
      final section = voucherSection ?? selectedMetalType.value.toString();

      final response = await estimationRepository.getSequencesDropdown(
        voucherType: voucherType,
        voucherSection: section,
      );

      if (response.values != null && response.values!.isNotEmpty) {
        sequencesDropdownList.assignAll(response.values!);
        sequencesDropdownResponse.value = ApiResponse.completed(response);

        // Auto-select the first item
        final defaultSequence =
            response.values!.firstWhereOrNull((seq) => seq.isDefault == true) ??
            response.values!.first;
        setSelectedSequence(defaultSequence);
      } else {
        // Clear the list and selected sequence when no sequences are available
        sequencesDropdownList.clear();
        selectedSequence.value = null;
        sequencesDropdownController.clear();
        sequencesDropdownResponse.value = ApiResponse.error(
          'No sequences available',
        );
        showErrorToast(
          message:
              'No sequences available for this metal type. Please select a different metal type or contact administrator.',
        );
      }
    } catch (e) {
      log('Error loading sequences dropdown: $e');
      sequencesDropdownList.clear();
      selectedSequence.value = null;
      sequencesDropdownController.clear();
      sequencesDropdownResponse.value = ApiResponse.error(e.toString());
      showErrorToast(message: 'Failed to load sequences: ${e.toString()}');
    }
  }

  void setSelectedSequence(GetSequencesDropdownValue sequence) {
    selectedSequence.value = sequence;
    sequencesDropdownController.text = sequence.value ?? '';
    salesNumber.value = sequence.value ?? '';
  }

  Future<void> fetchSalesNumber() async {
    try {
      final recordNumber = await estimationRepository.salesNumber();
      salesNumber.value = recordNumber;
    } catch (e) {
      log('Error fetching tagging record number: $e');
      salesNumber.value = 'Error';
    }
  }

  final postSalesResponse =
      Rx<ApiResponse<GetSalesRecordByIdAggregateResponse>>(
        ApiResponse.initial('Empty data'),
      );

  Future<void> addSalesInvoice({
    required PostSalesRequestModel salesRequest,
  }) async {
    postSalesResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await estimationRepository.addSalesInvoice(
        salesRequest: salesRequest,
      );
      postSalesResponse.value = ApiResponse.completed(response);
      GetSalesPaginatedResponseValue sale = GetSalesPaginatedResponseValue(
        id: response.id,
      );
      await printInvoice(sale);

      await loadSequencesDropdown();
      final CreateSalesEstimationSearchPartyController
      createSalesEstimationSearchPartyController =
          Get.find<CreateSalesEstimationSearchPartyController>();
      createSalesEstimationSearchPartyController.partySearchFocusNode
          .requestFocus();
    } catch (e, s) {
      ErrorHandler.logError(e, s, context: 'addSalesInvoice');

      final errorMessage = ErrorHandler.getErrorMessage(e);
      postSalesResponse.value = ApiResponse.error(errorMessage);
      // showErrorToast(message: errorMessage);

      rethrow;
    }
  }

  final getSaleByEstimationNumberResponse =
      Rx<ApiResponse<GetSaleByEstimateResponse>>(
        ApiResponse.initial('Empty data'),
      );

  // Modified code section in create_sales_view_model.dart
  Future<void> getSaleByEstimateNumber({required String estimateNumber}) async {
    if (estimateNumber.isEmpty) return;
    CreateSalesItemDetailsController createSalesItemDetailsController =
        Get.find<CreateSalesItemDetailsController>();

    SalesOldGoldController salesOldGoldController =
        Get.find<SalesOldGoldController>();
    SalesJewelleryPlanController salesJewelleryPlanController =
        Get.find<SalesJewelleryPlanController>();
    SalesAdvanceBookingController salesAdvanceBookingController =
        Get.find<SalesAdvanceBookingController>();

    final CreateSalesEstimationSearchPartyController
    createSalesEstimationSearchPartyController =
        Get.find<CreateSalesEstimationSearchPartyController>();

    final SalesPaymentDetailsController salesPaymentDetailsController =
        Get.find<SalesPaymentDetailsController>();

    getSaleByEstimationNumberResponse.value = ApiResponse.loading("Loading");

    try {
      createSalesItemDetailsController.clearControllers();
      final response = await estimationRepository.getSaleByEstimationNumber(
        estimateNumber: estimateNumber,
        metalType: selectedMetalType.value.toString(),
      );
      createSalesItemDetailsController.addToControllersFromEstimateNumberApi(
        response: response,
      );

      // Check if a customer is already selected
      bool customerAlreadySelected =
          createSalesEstimationSearchPartyController.selectedParty.value !=
          null;

      // Only update customer details if no customer is already selected
      if (!customerAlreadySelected) {
        createSalesEstimationSearchPartyController.selectedParty.value =
            response.partyDetails;
        createSalesEstimationSearchPartyController.searchController.value.text =
            response.partyDetails?.name ?? "";
        createSalesEstimationSearchPartyController.getPartyBalance(
          partyId: response.partyDetails?.id ?? "",
        );
      }

      salesOldGoldController.prefillOldGoldValues(oldGolds: response.oldGolds);
      await salesJewelleryPlanController.prefillJewelleryPlan(
        jewelleryPlans: response.jewelleryPlans,
      );
      await salesAdvanceBookingController.prefillAdvanceBookingDetails(
        advanceBookingDetails: response.advanceBookingDetails,
      );
      salesPaymentDetailsController.prefillSalesPaymentValues(
        additionalLess: double.tryParse(response.additionalLess ?? ""),
        jewelleryDiscount: response.jewellerDiscount,
        paymentDetails: response.paymentDetails,
      );
      getSaleByEstimationNumberResponse.value = ApiResponse.completed(response);
    } catch (e, s) {
      log("Error in postPurchaseInvoice $e \n $s");
      // final handledResponse = handleDTOResponseErrors(e);
      getSaleByEstimationNumberResponse.value = ApiResponse.error(e.toString());
      createSalesItemDetailsController.clearControllers();

      salesOldGoldController.clearTextController();
      salesJewelleryPlanController.clearControllers();
      salesAdvanceBookingController.clearControllers();
      String errorString = e.toString();
      if (errorString.contains("estimate_number not found")) {
        showErrorToast(message: "Estimate not found");
      } else if (errorString.contains("estimation record is expired")) {
        showErrorToast(message: "Estimation record is expired");
      } else {
        showErrorToast(message: e.toString());
      }
      // rethrow;
    }
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
      // await Future.delayed(const Duration(seconds: 1));
      final response = await _aggregateRepository.getSalesRecordById(id: id);
      getSalesRecordByIdAggregateResponse.value = ApiResponse.completed(
        response,
      );
    } catch (e) {
      getSalesRecordByIdAggregateResponse.value = ApiResponse.error(
        e.toString(),
      );
      log(e.toString());
      // Get.snackbar("Error", "$e");
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

        // Print estimate slip if enabled
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

        // Print item difference slip if enabled
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
            purity: oldGold.purity,
            metalType:
                oldGold.metalType != null
                    ? MetalType(id: oldGold.metalType?.id)
                    : null,
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
}
