import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/post_estimate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/digital_coin/estimation_digital_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_estimate/quick_estimate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/quick_old_gold/quick_old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/get_sale_by_estimation_number_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/create_sales_invoice/models/post_sales_request_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/metal_type_constants.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/pos_printer/pos_thermal_printer.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:jewellery_erp_frontend_tab_version/base/networks/api_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/estimation_record_request.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/advance_booking/advance_booking_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_search_party_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/jewellery_plan/jewellery_plan_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/old_gold/old_gold_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/customer_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/party_details_search_model/vendor_search_model.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/estimation_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

import 'estimation_payment_details_controller.dart';

class EstimationViewModel extends GetxController {
  final EstimationRepository _estimationRepository = EstimationRepository();
  final RxBool isFastMode = true.obs;

  final RxBool includeGstInPrint = true.obs;
  final RxBool vaInPercent = true.obs;

  final EstimationItemDetailsController controller = Get.put(
    EstimationItemDetailsController(),
  );

  void toggleFastMode() => isFastMode.toggle();

  final RxInt selectedMetalType = MetalTypeUtils.gold.obs;

  TextEditingController jewellerDiscount = TextEditingController();
  FocusNode jewellerDiscountFocusNode = FocusNode();

  VoidCallback? onResetTab;

  void setMetalType(int metalType) {
    selectedMetalType.value = metalType;

    final RateCaratInputController rateController =
        Get.find<RateCaratInputController>();
    rateController.setCaratForMetalType(metalType);

    final EstimationItemDetailsController itemDetailsController =
        Get.find<EstimationItemDetailsController>();
    final String caratValue = rateController.getPurityFromCarat(
      rateController.selectedCarat.value,
    );
    final double rate = double.tryParse(rateController.currentRate) ?? 0;

    itemDetailsController.onRateChanged(rate, caratValue);

    log(
      'Metal type changed to: ${MetalTypeUtils.getName(metalType)} ($metalType)',
    );
  }

  void resetToDefaultTab() {
    selectedMetalType.value = MetalTypeUtils.gold;
    onResetTab?.call();
  }

  bool get isRateInvalid {
    final controller = Get.find<EstimationItemDetailsController>();

    return controller.controllers.any((item) {
      final rate = item.rate.text.trim();
      return rate.isEmpty || rate == "0" || rate == "null" || rate == "-";
    });
  }

  Future<void> printEstimate(
    PostEstimateResponse estimate, {
    bool? includeGStInPrint,
  }) async {
    RateCaratInputController rateCaratInputController = Get.find();
    final globalSettingsViewModel = Get.find<GlobalSettingsViewModel>();
    await globalSettingsViewModel.getGlobalSettings();

    final estimatePrintTemplate =
        globalSettingsViewModel
            .getGlobalSettingsResponse
            .value
            .data
            ?.estimatePrintTemplate;

    PosThermalPrinter thermalPrinter = PosThermalPrinter();
    await thermalPrinter.printEstimateSlip(
      estimate: controller.controllers,
      responseEstimate: estimate,
      rateController: rateCaratInputController,
      includeGstInPrint: includeGStInPrint ?? includeGstInPrint.value,
      estimatePrintTemplate: estimatePrintTemplate,
    );

    update();
  }

  final postEstimateResponse = Rx<ApiResponse<PostEstimateResponse>>(
    ApiResponse.initial('Empty data'),
  );
  Future<void> validateAndSubmitEstimateRecord() async {
    // await Get.dialog(EstimateDialogPrinter());
    EstimationItemDetailsController itemDetailsController =
        Get.find<EstimationItemDetailsController>();

    // EstimationSearchPartyController partyController =
    //     Get.find<EstimationSearchPartyController>();

    // Create a list to store all validation errors
    bool hasValidationErrors = checkForValidationErrors(itemDetailsController);
    if (hasValidationErrors) {
      return;
    }
    PostEstimateRequestModel invoiceModel = getConvertedRequestModel();
    log("The  details are here to send ${jsonEncode(invoiceModel.toJson())}");
    try {
      final response = await submitEstimateRecord(
        estimation_record_request: invoiceModel,
      );
      // await Get.dialog(
      //   EstimateDialogPrinter(
      //     estimate: response,
      //   ),
      //   barrierDismissible: false,
      // );
      await printEstimate(response);

      clearAllControllers(invoiceType: "invoice_number_vendor");

      resetToDefaultTab();

      itemDetailsController.controllers.last.tableFocusNodes.first
          .requestFocus();
      showSuccessToast(message: 'Estimation added successfully !');
    } catch (e, s) {
      log("Error in validateAndPostPurchaseInvoice: $e \n $s");
    }
  }

  bool checkForValidationErrors(
    EstimationItemDetailsController itemDetailsController,
  ) {
    final GlobalSettingsViewModel globalSettingsViewModel =
        Get.find<GlobalSettingsViewModel>();

    final askSalesPersonDetails =
        globalSettingsViewModel
            .getGlobalSettingsResponse
            .value
            .data
            ?.estimatePreference
            ?.askSalesPersonDetails ??
        false;
    // Create a list to store all validation errors
    List<String> validationErrors = [];

    // Check all validation conditions and collect errors
    if (itemDetailsController.validateRow() == false) {
      validationErrors.add("Invalid Item Data");
    }

    // if (partyController.selectedParty.value == null) {
    //   validationErrors.add("Select a Party");
    // }

    if (askSalesPersonDetails) {
      if (itemDetailsController.hasNoSalesPerson() == true) {
        validationErrors.add("Select the Sale Person ");
      }
    }

    if (itemDetailsController.hasSoldItems() == true) {
      validationErrors.add("Estimation contains sold items");
    }
    if (itemDetailsController.hasInvalidRates()) {
      validationErrors.add("Rates unavailable. Kindly Update");
    }

    // If there are any validation errors, show them all and return
    if (validationErrors.isNotEmpty) {
      for (var element in validationErrors) {
        showErrorToast(message: element);
      }
      return true;
    }
    return false;
  }

  Future<PostEstimateResponse> submitEstimateRecord({
    required PostEstimateRequestModel estimation_record_request,
  }) async {
    postEstimateResponse.value = ApiResponse.loading("Loading");
    try {
      final response = await _estimationRepository.submitEstimationRecord(
        estimation_record_request: estimation_record_request,
      );
      postEstimateResponse.value = ApiResponse.completed(response);
      return response;
    } catch (e, s) {
      log("Error in postPurchaseInvoice $e \n $s");
      final handledResponse = handleDTOResponseErrors(e);
      postEstimateResponse.value = ApiResponse.error(handledResponse.message);
      showErrorToast(
        message: handledResponse.message ?? "Something went wrong ",
      );
      rethrow;
    }
  }

  PostEstimateRequestModel getConvertedRequestModel() {
    EstimationItemDetailsController itemDetailsController =
        Get.find<EstimationItemDetailsController>();

    EstimationSearchPartyController partyController =
        Get.find<EstimationSearchPartyController>();
    OldGoldController oldGoldController = Get.find<OldGoldController>();
    JewelleryPlanController jewelleryPlanController =
        Get.find<JewelleryPlanController>();

    AdvanceBookingController advanceBookingController =
        Get.find<AdvanceBookingController>();

    EstimationPaymentDetailsController estimationPaymentDetailsController =
        Get.find<EstimationPaymentDetailsController>();

    String subTotal =
        itemDetailsController.totalHeadersValue[itemDetailsController
                .totalHeadersValue
                .length -
            3];
    // String total = itemDetailsController
    //     .totalHeadersValue[itemDetailsController.totalHeadersValue.length - 2];
    // Calculate GST as 3% of subtotal and use ceil
    double gstRaw = double.parse(subTotal) * 0.03;
    String gst = gstRaw.ceil().toString(); // Ceil to next integer
    // String gst =
    //     (double.parse(total) - double.parse(subTotal)).toStringAsFixed(2);
    String total = (double.parse(subTotal) + double.parse(gst)).toStringAsFixed(
      2,
    );

    List<PostLineItemRequestModel>? lineItems =
        itemDetailsController.controllers.toList().mapIndexed((index, element) {
          // Use the calculated values in the PostLineItemRequestModel
          return PostLineItemRequestModel(
            shopId: element.itemResponse?.shopId,
            code: element.itemResponse?.code,
            taggingId: element.itemResponse?.id,
            tag: element.itemResponse?.tagNumber.toString(),
            description: element.itemResponse?.design?.name,
            salesPersonId: element.employeeDetails?.id,
            taggingVa: element.itemResponse?.va,
            finalVa: element.va.text,
            taggingMc: element.itemResponse?.mc,
            finalMc: element.mc.text,
            stoneCost: element.stone.text,
            hallMark: element.hallMark.text,
            salesAmount: element.salesAmount,
            totalAmount: element.total,
            taggingGrossWeight: element.itemResponse?.grossWeight,
            taggingNetWeight: element.itemResponse?.netWeight,
            taggingPieces: element.itemResponse?.pieces,
            costDiscount: element.costDiscount.text,
            discount: element.costDiscount.text,
            finalGrossWeight: element.gwt.text,
            finalNetWeight: element.nwt.text,
            finalPieces: element.itemResponse?.pieces,
            rate: element.rate.text,
          );
        }).toList();

    String partyId = "";
    String partyType = "";

    if (partyController.selectedParty.value is CustomerSearchValue &&
        partyController.searchController.value.text.isNotEmpty) {
      final CustomerSearchValue customerSearchValue =
          partyController.selectedParty.value;

      partyId = customerSearchValue.id ?? '';
      partyType = "customer";
    } else if (partyController.selectedParty.value is VendorSearchValue &&
        partyController.searchController.value.text.isNotEmpty) {
      final VendorSearchValue vendorSearchValue =
          partyController.selectedParty.value;

      partyId = vendorSearchValue.id ?? '';
      partyType = "vendor";
    }

    List<PostOldGoldRequestModel>? oldGolds =
        oldGoldController.controllers
            .where(
              (e) =>
                  e.total_amount.text.isNotEmpty && e.total_amount.text != "0",
            )
            .map(
              (element) => PostOldGoldRequestModel(
                isReceived: true,
                code: element.code.text.isEmpty ? null : element.code.text,
                description:
                    element.description.text.isEmpty
                        ? null
                        : element.description.text,
                pieces: element.pcs.text.isEmpty ? null : element.pcs.text,
                grossWeight:
                    element.gross_wtt.text.isEmpty
                        ? null
                        : element.gross_wtt.text,
                netWeight:
                    element.net_wtt.text.isEmpty ? null : element.net_wtt.text,
                less: element.less.text.isEmpty ? "0" : element.less.text,
                purity:
                    element.purity.text.isEmpty ? "100" : element.purity.text,
                ornamentId: element.ornamentId,
                rate: element.rate.text.isEmpty ? null : element.rate.text,
                amount:
                    element.amount.text.isEmpty ? null : element.amount.text,
                roundOff:
                    element.round_off.text.isEmpty
                        ? "0"
                        : element.round_off.text,
                total:
                    element.total_amount.text.isEmpty
                        ? "0"
                        : element.total_amount.text,
                purityType: element.selectedPurityType ?? "22k",
                metalType:
                    element.selectedMetalType?.id ??
                    (element.ornamentId != null ? "1" : null),
              ),
            )
            .toList();
    final jewelleryplanElementList =
        jewelleryPlanController.selectedJewelleryPlans.toList();
    List<PostJewelleryPlanRequestModel>? jewelleryPlans =
        jewelleryplanElementList
            .map(
              (jewelleryplanElement) => PostJewelleryPlanRequestModel(
                id: jewelleryplanElement.id,
                installments: jewelleryplanElement.installments,
                subscriptionId: jewelleryplanElement.code,
                duration: jewelleryplanElement.planDuration,
                planId: jewelleryplanElement.id,
                redeemableAmount:
                    jewelleryplanElement.redeemableAmount?.toStringAsFixed(2) ??
                    "0",
                startDate: convertStringToDateTime(
                  jewelleryplanElement.startDate ?? "",
                  formatSent: DateFormat("dd/MM/yyyy"),
                ),
                totalWeight: jewelleryplanElement.totalWeight,
                type: jewelleryplanElement.type,
              ),
            )
            .toList();

    final advanceBookingElementList =
        advanceBookingController.selectedAdvanceBookings.toList();
    List<PostAdvanceBookingRequestModel>? advanceBookingDetails =
        advanceBookingElementList
            .map(
              (advanceBookingElement) => PostAdvanceBookingRequestModel(
                advancePaid: advanceBookingElement.cost?.toStringAsFixed(2),
                bookingId: advanceBookingElement.bookingId,
                rate: advanceBookingElement.rateValue?.toStringAsFixed(2),
                status: advanceBookingElement.status,
                weight: advanceBookingElement.quantity?.toStringAsFixed(3),
              ),
            )
            .toList();

    final oldGoldDiscount =
        oldGoldController
            .totalHeadersValue[oldGoldController.totalHeadersValue.length - 2];
    final jewelleryPlanDiscount = jewelleryPlanController
        .totalRedeemableAmount
        .value
        .toStringAsFixed(2);

    final advanceBookingDiscount = advanceBookingController.totalAdvancePaid
        .toStringAsFixed(2);

    final finalTotal =
        double.parse(total) -
        (double.tryParse(advanceBookingDiscount) ?? 0) -
        (double.tryParse(jewelleryPlanDiscount) ?? 0) -
        (double.tryParse(oldGoldDiscount) ?? 0);
    estimationPaymentDetailsController.controllers.removeWhere(
      (element) => element.amount.text.isEmpty || element.amount.text == "0",
    );
    List<PostSalePaymentMethodDetailRequest> paymentMethodDetails =
        estimationPaymentDetailsController.controllers
            .toList()
            .map(
              (element) => PostSalePaymentMethodDetailRequest(
                amount: (element.amount.text),
                date: convertStringToDateTime(element.date.text),
                method: element.method.text,
                paymentCode: element.upi_utr_cn.text,
                pos: element.pos_bank.text,
                // salesPaymentDetailsId: ""
              ),
            )
            .toList();
    PostSalePaymentDetailRequest
    paymentDetailsModel = PostSalePaymentDetailRequest(
      // Handling balance amount - return "0" if empty
      balanceAmount:
          estimationPaymentDetailsController.balanceAmountController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController.balanceAmountController.text
                  .trim(),

      // Tax values
      cgst: estimationPaymentDetailsController.CGStValue.value,
      sgst: estimationPaymentDetailsController.SGSTValue.value,
      igst: estimationPaymentDetailsController.IGStValue.value,

      subTotal: subTotal,

      // TCS - return "0" if empty instead of null
      tcs:
          estimationPaymentDetailsController.tcsController.text.trim().isEmpty
              ? null
              : estimationPaymentDetailsController.tcsController.text.trim(),
      tds:
          estimationPaymentDetailsController.tdsController.text.trim().isEmpty
              ? null
              : estimationPaymentDetailsController.tdsController.text.trim(),

      paymentMethodDetails: paymentMethodDetails,

      // Received amount - return "0" if empty instead of null
      receivedAmount:
          estimationPaymentDetailsController.paidAmountController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController.paidAmountController.text
                  .trim(),

      amount: estimationPaymentDetailsController.totalPrice.value,

      // Advance - return "0" if empty
      advance:
          estimationPaymentDetailsController.advanceAmountController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController.advanceAmountController.text
                  .trim(),

      // Bank charges - return "0" if empty
      bankCharges:
          estimationPaymentDetailsController.bankChargesAmountController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController
                  .bankChargesAmountController
                  .text
                  .trim(),

      finalAmount: estimationPaymentDetailsController.totalPrice.value,
      nettGst: estimationPaymentDetailsController.gstNet.toStringAsFixed(2),
      nettTdsTcs: estimationPaymentDetailsController.taxDeductionNet
          .toStringAsFixed(2),

      // Purchase old gold - return "0" if empty
      purchaseOldGold:
          estimationPaymentDetailsController.purchaseAmountController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController.purchaseAmountController.text
                  .trim(),

      rateDiscount: estimationPaymentDetailsController.rateDisct
          .toStringAsFixed(2),

      // Round off - already handled but simplified
      roundOff:
          estimationPaymentDetailsController.roundOffController.text
                  .trim()
                  .isEmpty
              ? "0"
              : estimationPaymentDetailsController.roundOffController.text
                  .trim(),

      salesAmount: estimationPaymentDetailsController.salesAmount
          .toStringAsFixed(2),

      schemeDiscount: estimationPaymentDetailsController.schemeDisct
          .toStringAsFixed(2),

      // Advanced booking - return 0 if null/empty
      advance_booking_amount: advanceBookingController.totalAdvancePaid.value,

      // Jewellery plan - already handled
      jewellery_plan_base_amount: double.tryParse(jewelleryPlanDiscount) ?? 0,

      // Optional: Add order amount if needed
      // order_amount_used: salesAddOrdersDialogController.totalAdvancePaid.value ?? 0,
    );
    PostEstimateRequestModel invoiceModel = PostEstimateRequestModel(
      shopId:
          itemDetailsController.controllers.firstOrNull?.itemResponse?.shopId,
      customerId: partyId.isEmpty ? null : partyId,
      partyType: partyType.isEmpty ? null : partyType,
      estimateNumber: partyController.estimationNumber.value,
      remarks: "",
      lineItems: lineItems,
      advanceBookingDetails: advanceBookingDetails,
      jewelleryPlans: jewelleryPlans,
      oldGolds: oldGolds,
      subTotal: subTotal,
      gst: gst,
      oldGoldAmount: oldGoldDiscount,
      advanceBookingAmount: advanceBookingDiscount,
      digitalGoldAmount: "0",
      jewelleryPlanAmount: jewelleryPlanDiscount,
      total: finalTotal.toStringAsFixed(2),
      additional_less: estimationPaymentDetailsController.additional_less.value
          .toStringAsFixed(2),
      jewellerDiscount: double.tryParse(jewellerDiscount.text),
      paymentDetails: [paymentDetailsModel],
      metalType: selectedMetalType.value.toString(),
    );

    try {
      log(
        "The value for jewellery plan is ${invoiceModel.jewelleryPlans?.firstOrNull?.duration}",
      );
      log("The details are here ${jsonEncode(invoiceModel.toJson())}");
    } catch (e, s) {
      log(s.toString());
      log(e.toString());
    }
    return invoiceModel;
  }

  void clearAllControllers({required String invoiceType}) {
    EstimationItemDetailsController itemDetailsController =
        Get.find<EstimationItemDetailsController>();

    EstimationSearchPartyController partyController =
        Get.find<EstimationSearchPartyController>();
    final OldGoldController oldGoldController = Get.find<OldGoldController>();
    final AdvanceBookingController advanceBookingController =
        Get.find<AdvanceBookingController>();
    final JewelleryPlanController jewelleryPlanController =
        Get.find<JewelleryPlanController>();
    final QuickEstimateController quickEstimateController =
        Get.find<QuickEstimateController>();
    final QuickOldGoldController quickOldGoldController =
        Get.find<QuickOldGoldController>();
    final EstimationDigitalGoldController estimationDigitalGoldController =
        Get.find<EstimationDigitalGoldController>();
    final EstimationPaymentDetailsController
    estimationPaymentDetailsController =
        Get.find<EstimationPaymentDetailsController>();

    jewellerDiscount.clear();
    // additional_less.value = 0.0;

    itemDetailsController.clearControllers();

    partyController.clearControllers();
    partyController.fetchestimationNumber();

    oldGoldController.clearTextController();
    jewelleryPlanController.clearControllers();
    advanceBookingController.clearControllers();
    quickEstimateController.clearControllers();
    quickOldGoldController.clearControllers();
    estimationDigitalGoldController.clearControllers();
    estimationPaymentDetailsController.clearControllers();

    selectedMetalType.value = MetalTypeUtils.gold;
    onResetTab?.call();
  }

  final GlobalKey<FormState> quickEstimateFormKey = GlobalKey<FormState>();
  final estimateNumberTextController = TextEditingController();
  final getEstimateByEstimationNumberResponse =
      Rx<ApiResponse<GetSaleByEstimateResponse>>(
        ApiResponse.initial('Empty data'),
      );

  Future<void> fetchEstimateByEstimateNumber() async {
    final estimateNumber = estimateNumberTextController.text;

    if (estimateNumber.isEmpty) {
      getEstimateByEstimationNumberResponse.value = ApiResponse.error(
        "Please enter a valid estimate number",
      );
      showErrorToast(message: "Please enter a valid estimate number");
      return;
    }

    try {
      getEstimateByEstimationNumberResponse.value = ApiResponse.loading(
        "Loading",
      );

      final response = await _estimationRepository.getSaleByEstimationNumber(
        estimateNumber: estimateNumber,
      );

      getEstimateByEstimationNumberResponse.value = ApiResponse.completed(
        response,
      );

      // // Clear existing controllers
      // EstimationItemDetailsController itemDetailsController =
      //     Get.find<EstimationItemDetailsController>();
      // // itemDetailsController.clearControllers();

      // // Add each line item to the controllers
      // if (response.lineItems != null) {
      //   for (var lineItem in response.lineItems!) {
      //     final tableData = EstimationItemDetailsTableData(
      //       sn: (itemDetailsController.controllers.length + 1).toString(),
      //       code: TextEditingController(text: lineItem.code ?? ""),
      //       tagNo: TextEditingController(text: lineItem.tag ?? ""),
      //       item_description: lineItem.description ?? "",
      //       pcs: lineItem.pieces?.toString() ?? '',
      //       gwt: lineItem.grossWeight ?? '',
      //       nwt: lineItem.netWeight ?? '',
      //       va: TextEditingController(text: lineItem.finalVa ?? ''),
      //       mc: TextEditingController(text: lineItem.finalMc ?? ''),
      //       stone: lineItem.stoneCost ?? '0',
      //       hallMark: lineItem.hallMark ?? '',
      //       costDiscount:
      //           TextEditingController(text: lineItem.costDiscount ?? "0"),
      //       salesAmount: lineItem.salesAmount ?? "",
      //       total: lineItem.totalAmount ?? "",
      //       gst: response.billingSummary?["gst"]?.toString() ?? "0",
      //       originalMc: double.tryParse(lineItem.taggingMc ?? "0") ?? 0,
      //       originalVa: double.tryParse(lineItem.taggingVa ?? "0") ?? 0,
      //       currentRateSet:
      //           0, // You might want to set this based on your requirement
      //     );

      //     itemDetailsController.controllers.add(tableData);
      //   }

      //   // Update UI
      //   itemDetailsController.updateTotals();
      //   itemDetailsController.controllers.refresh();

      //   showSuccessToast(message: "Estimate details fetched successfully!");
      // } else {
      //   showErrorToast(message: "No items found in the estimate");
      // }
    } catch (e, s) {
      log("Error in fetchEstimateByEstimateNumber: $e\n$s");
      getEstimateByEstimationNumberResponse.value = ApiResponse.error(
        e.toString(),
      );
      showErrorToast(message: "Failed to fetch estimate details");
    }
  }
}
