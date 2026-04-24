import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/post_estimate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/view_model/global_settings_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_create/model/stone_details_table_model.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/repository/inventory_repository.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class BarcodeScannerDialogController extends GetxController {
  final InventoryRepository _inventoryRepository = InventoryRepository();
  final TextEditingController barcodeController = TextEditingController();
  final FocusNode barcodeFocusNode = FocusNode();
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    barcodeController.dispose();
    super.onClose();
  }

  Future<void> scanAndPrintBarcode() async {
    if (!formKey.currentState!.validate()) {
      showErrorToast(message: "Please enter a valid barcode");
      return;
    }

    try {
      isLoading.value = true;
      final barcode = barcodeController.text.trim();

      if (barcode.isEmpty) {
        showErrorToast(message: "Barcode cannot be empty");
        return;
      }

      // Fetch item details using the barcode
      final response = await _inventoryRepository.getTaggingLineItemByBarcode(
        barcode,
      );

      if (response.status?.toLowerCase() != "available") {
        showErrorToast(message: "Item not found or not available!");
        return;
      }

      //. Get the rate and validate it before proceeding
      final GoldRateController rateController = Get.find<GoldRateController>();
      final purity = response.purity;
      final String rate;

      if (response.design?.makingChargeType?.id == "1") {
        rate = rateController.getRateForPurity(purity ?? "22k");
      } else {
        rate = response.rate ?? "0";
      }

      // NEW: Validate rate before printing
      final rateValue = double.tryParse(rate) ?? 0;
      if (rateValue <= 0) {
        showErrorToast(message: "Rates unavailable. Kindly Update");
        return;
      }

      // Print the item details
      await _printItemDetails(response);

      // Clear the barcode and close the dialog
      barcodeController.clear();
      // Get.back();
      Future.delayed(const Duration(milliseconds: 100), () {
        barcodeFocusNode.requestFocus();
      });
      showSuccessToast(message: "Item printed successfully!");
    } catch (e) {
      log("Error scanning barcode: $e");
      // log("Stack trace: $s");
      showErrorToast(message: "Error scanning barcode: ${e.toString()}");

      Future.delayed(const Duration(milliseconds: 100), () {
        barcodeFocusNode.requestFocus();
      });
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _printItemDetails(
    GetTaggingLineItemCodeTagResponse itemResponse,
  ) async {
    try {
      // PosThermalPrinter printer = PosThermalPrinter();

      // Create an EstimationItemDetailsTableData for printing
      EstimationItemDetailsTableData estimationData =
          EstimationItemDetailsTableData(
            sn: "1",
            code: TextEditingController(text: itemResponse.code ?? ""),
            tagNo: TextEditingController(
              text: itemResponse.tagNumber?.toString() ?? "",
            ),
            item_description: TextEditingController(
              text: itemResponse.design?.name ?? "",
            ),
            pcs: TextEditingController(
              text: itemResponse.pieces?.toString() ?? "1",
            ),
            gwt: TextEditingController(text: itemResponse.grossWeight ?? "0"),
            nwt: TextEditingController(text: itemResponse.netWeight ?? "0"),
            va: TextEditingController(text: itemResponse.va ?? "0"),
            mc: TextEditingController(text: itemResponse.mc ?? "0"),
            stone: TextEditingController(text: "0"),
            hallMark: TextEditingController(text: "0"),
            costDiscount: TextEditingController(text: "0"),
            salesAmount: "0",
            total: "0",
            originalMc: double.tryParse(itemResponse.mc ?? "0") ?? 0,
            originalVa: double.tryParse(itemResponse.va ?? "0") ?? 0,
            barcode: itemResponse.tagBarcode ?? "",
            rate: TextEditingController(text: "0"),
          );

      // Calculate stone cost
      if (itemResponse.lineStones?.isNotEmpty ?? false) {
        double totalStoneCost = 0;
        for (var stone in itemResponse.lineStones!) {
          totalStoneCost += double.tryParse(stone.total ?? "0") ?? 0;
        }
        estimationData.stone.text = totalStoneCost.toString();
      }

      // Set the item response
      estimationData.itemResponse = itemResponse;

      // Set up images
      List<String> combinedImages = [
        ...(itemResponse.images?.map((image) => image.presignedUrl ?? '') ??
            []),
        ...(itemResponse.design?.images?.map(
              (image) => image.presignedUrl ?? '',
            ) ??
            []),
      ];
      estimationData.images =
          combinedImages.where((element) => element.isNotEmpty).toList();

      // Set up stone details
      estimationData.stoneDetailsTableData =
          itemResponse.lineStones
              ?.map(
                (e) => StoneDetailsTableData(
                  id: e.id,
                  name: TextEditingController(text: e.name),
                  carat_weight: TextEditingController(
                    text: e.carat ?? e.weight,
                  ),
                  pcs: TextEditingController(text: e.pieces.toString()),
                  rate: TextEditingController(text: e.rate),
                  total: TextEditingController(text: e.total),
                  weightUnitFromBackend: e.carat == null ? "GM" : "CT",
                ),
              )
              .toList() ??
          [];

      // Get the rate for the item
      final GoldRateController rateController = Get.find<GoldRateController>();
      final purity = itemResponse.purity;
      final String rate;
      if (itemResponse.design?.makingChargeType?.id == "1") {
        rate = rateController.getRateForPurity(purity ?? "22k");
      } else {
        rate = itemResponse.rate ?? "0";
      }
      log("The rate for was $rate");
      estimationData.rate.text = rate;

      // Calculate sales amount and total using the jewelry calculator
      String? wastageType = itemResponse.designLineItem?.wastageType;
      String? mcType = itemResponse.designLineItem?.makingChargesType;

      VAType vaType = getVAType(wastageType);
      MCType mcTypeEnum = getMCType(mcType);

      double nettWeight = double.tryParse(itemResponse.netWeight ?? "0") ?? 0;
      double grossWeight =
          double.tryParse(itemResponse.grossWeight ?? "0") ?? 0;
      double vaValue = double.tryParse(itemResponse.va ?? "0") ?? 0;
      double rateValue = double.tryParse(rate) ?? 0;
      double mcValue = double.tryParse(itemResponse.mc ?? "0") ?? 0;
      double stoneValue = double.tryParse(estimationData.stone.text) ?? 0;
      // double hallMarkValue = double.tryParse(
      //         itemResponse.design?.stockHead?.hallmarkExtraCharge ?? "0") ??
      //     0;
      double costDiscount = 0; // No discount applied in quick scan

      // Get GST information
      bool isGstApplicable = true;
      double gstPercentage =
          double.tryParse(itemResponse.designLineItem?.ornament?.gst ?? "0") ??
          0;

      // Create calculator instance
      JewelryCalculator calculator = JewelryCalculator(
        nettWeight: nettWeight,
        vaType: vaType,
        vaValue: vaValue,
        metalRate: rateValue,
        grossWeight: grossWeight,
        mcType: mcTypeEnum,
        mcValue: mcValue,
        stoneCost: stoneValue,
        isGstApplicable: isGstApplicable,
        gstPercentage: gstPercentage,
        printGstInVA: false,
        costDiscount: costDiscount,
      );

      // Generate the calculation report
      JewelryCalculationReport report = calculator.generateReport();

      // Calculate GST as 3% of subtotal and use ceil
      double subTotalRaw = report.calculations.subTotal;
      double subTotalValue = subTotalRaw.ceilToDouble();

      double gstRaw = subTotalValue * 0.03;
      double gstAmount = gstRaw.ceilToDouble(); // Ceil to next integer
      double totalWithGst = subTotalValue + gstAmount;

      // Set the sales amount and total from the calculation report
      // estimationData.salesAmount =
      //     report.calculations.subTotal.toStringAsFixed(2);
      // estimationData.total = report.calculations.total.toStringAsFixed(2);
      estimationData.salesAmount = subTotalValue.toStringAsFixed(2);
      estimationData.total = totalWithGst.toStringAsFixed(2);
      // Create a billing summary for printing with proper values from the calculator
      PostEstimateResponseBillingSummary billingSummary =
          PostEstimateResponseBillingSummary(
            subTotal: report.calculations.subTotal.toStringAsFixed(2),
            gst: gstAmount.toStringAsFixed(2),
            total: totalWithGst.toStringAsFixed(2),
            oldGoldAmount: "0",
          );

      final GlobalSettingsViewModel globalSettingsViewModel =
          Get.find<GlobalSettingsViewModel>();
      final estimatePrintTemplate =
          globalSettingsViewModel
              .getGlobalSettingsResponse
              .value
              .data
              ?.estimatePrintTemplate;

      // Print the item
      // await printer.printSingleQuickEstimate(
      //   estimate: [estimationData],
      //   responseEstimate: PostEstimateResponse(
      //     billingSummary: billingSummary,
      //     estimateNumber: estimationData.barcode,
      //   ),
      //   rateController: rateController,
      //   estimatePrintTemplate: estimatePrintTemplate,
      // );
    } catch (e) {
      log("Error printing item: $e");
      throw Exception("Failed to print item: ${e.toString()}");
    }
  }

  String? validateBarcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a barcode';
    }
    return null;
  }
}
