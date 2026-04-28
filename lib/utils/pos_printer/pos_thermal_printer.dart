import 'dart:developer';

import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/barcode.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_column.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/model/post_estimate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_item_details_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/estimation/add_new_estimate/view_model/estimation_rate_carat_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/global_quick_old_gold/models/global_old_gold_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/approvals/approval_issue/model/get_tagging_line_item_code_tag_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales/sales_listing/models/get_sales_record_by_id_aggregate_response.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/tagging/tagging_entry/view_model/printer_setting_class.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/home/model/get_global_settings_response.dart';
import 'package:jewellery_erp_frontend_tab_version/global_controllers/gold_rate_controller.dart';
import 'package:jewellery_erp_frontend_tab_version/model/printer/printer_connect_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/calculator/estimation_calculator.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/string_manipulate.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/utils.dart';

class PosThermalPrinter {
  String formatNumber(String? value) {
    if (value == null) return '';
    try {
      final double number = double.parse(value);
      return StringUtils.trimDecimal(number.toStringAsFixed(2));
    } catch (e) {
      return StringUtils.trimDecimal(value);
    }
  }

  final printerManager = PrinterManager.instance;
  PrinterConnectModel? printer;

  Future<void> loadPrinter() async {
    PrinterSettings printerSettings = PrinterSettings();
    await printerSettings.loadSettings();
    printer = printerSettings.createThermalPrinterModel();
    log("The printer is loaded ${printer?.input.toString()}");
  }

  // Helper method to format VA display based on template settings
  static String _formatVADisplay({
    required double vaPercentage,
    required double vaGrams,
    required double vaAmount,
    required String displayType,
    required String wastageType,
  }) {
    switch (displayType) {
      case 'percentage':
        return '${vaPercentage.toStringAsFixed(1)}%';
      case 'grams':
        return '${vaGrams.toStringAsFixed(3)}g';
      case 'both':
        return '${vaGrams.toStringAsFixed(3)}(${vaPercentage.toStringAsFixed(1)}%)';
      case 'amount':
        return vaAmount.toStringAsFixed(0);
      case 'none':
        return '';
      default:
        // Default to showing based on wastageType
        return wastageType == '%'
            ? '${vaPercentage.toStringAsFixed(1)}%'
            : '${vaGrams.toStringAsFixed(3)}g';
    }
  }

  Future<void> printEstimateSlip({
    required List<EstimationItemDetailsTableData> estimate,
    required PostEstimateResponse responseEstimate,
    required RateCaratInputController rateController,
    EstimatePrintTemplate? estimatePrintTemplate,
    bool includeGstInPrint = true,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Determine VA display format from template settings
    // Default to percentage if template is not available
    String vaDisplayFormat = estimatePrintTemplate?.percentVa ?? 'percentage';

    // Header for both formats
    if (estimate.length == 1 && (responseEstimate.oldGolds?.isEmpty ?? true)) {
      bytes += _generateSingleItemEstimate(
        generator: generator,
        singleEstimate: estimate.first,
        billingSummary: responseEstimate.billingSummary,
        rateController: rateController,
        oldGolds: responseEstimate.oldGolds ?? [],
        includeGstInPrint: includeGstInPrint,
        estimatePrintTemplate: estimatePrintTemplate,
        vaDisplayFormat: vaDisplayFormat,
      );
    } else {
      bytes += generator.text(
        'ROUGH ESTIMATE',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
        ),
      );

      bytes += _generateMultipleItemsEstimate(
        generator,
        estimate,
        rateController,
        responseEstimate.billingSummary,
        responseEstimate.oldGolds ?? [],
        includeGstInPrint,
        estimatePrintTemplate,
        vaDisplayFormat,
      );
    }

    bytes += _generateFooter(
      generator,
      responseEstimate,
      estimatePrintTemplate,
    );

    await sendDataToPrint(bytes);
  }

  Future<void> printSingleQuickEstimate({
    required List<EstimationItemDetailsTableData> estimate,
    required PostEstimateResponse responseEstimate,
    required GoldRateController rateController,
    EstimatePrintTemplate? estimatePrintTemplate,
    bool includeGstInPrint = true,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Determine VA display format from template settings
    String vaDisplayFormat = estimatePrintTemplate?.percentVa ?? 'percentage';

    if (estimate.length == 1) {
      bytes += generateQuickEstimateBytes(
        generator: generator,
        singleEstimate: estimate.first,
        billingSummary: responseEstimate.billingSummary,
        rateController: rateController,
        oldGolds: responseEstimate.oldGolds ?? [],
        includeGstInPrint: includeGstInPrint,
        estimatePrintTemplate: estimatePrintTemplate,
        vaDisplayFormat: vaDisplayFormat,
      );
    }

    bytes += _generateFooter(
      generator,
      responseEstimate,
      estimatePrintTemplate,
    );

    await sendDataToPrint(bytes);
  }

  double getCaratConvertedToGramsForTotal(
    GetTaggingLineItemCodeTagResponseLineStone row,
  ) {
    if (row.carat != null) {
      return (double.tryParse(row.carat ?? "0") ?? 0) * 0.2;
    } else {
      return (double.tryParse(row.weight ?? "0") ?? 0);
    }
  }

  List<int> _generateSingleItemEstimate({
    required Generator generator,
    required EstimationItemDetailsTableData singleEstimate,
    required PostEstimateResponseBillingSummary? billingSummary,
    required RateCaratInputController rateController,
    required List<PostEstimateResponseOldGold> oldGolds,
    required bool includeGstInPrint,
    EstimatePrintTemplate? estimatePrintTemplate,
    required String vaDisplayFormat,
  }) {
    List<int> bytes = [];

    log("========== REGULAR ESTIMATE CALCULATION START ==========");
    log("Input salesAmount: ${singleEstimate.salesAmount}");
    log("VA Display Format: $vaDisplayFormat");

    double nettWeight = double.tryParse(singleEstimate.nwt.text) ?? 0;
    double metalRate = double.tryParse(singleEstimate.rate.text) ?? 0;
    double vaValue = double.tryParse(singleEstimate.va.text) ?? 0;

    String? wastageType =
        singleEstimate.itemResponse?.designLineItem?.wastageType;
    bool isInputVaPercent = wastageType == '%';

    // Calculate VA in both formats
    double vaPercentage = 0;
    double vaGrams = 0;
    double vaAmount = 0;

    if (isInputVaPercent) {
      vaPercentage = vaValue;
      vaGrams = (nettWeight * vaPercentage) / 100;
      vaAmount = vaGrams * metalRate;
    } else {
      vaGrams = vaValue;
      vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
      vaAmount = vaGrams * metalRate;
    }

    // Adjust VA if GST should be included in VA display but not printed separately
    if (!includeGstInPrint && billingSummary?.gst != null) {
      try {
        double gstAmount = double.parse(billingSummary!.gst!);
        double gstAsVaGrams = gstAmount / metalRate;
        vaGrams += gstAsVaGrams;
        vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
        vaAmount += gstAmount;
      } catch (e) {
        log("Error adjusting VA for GST: $e");
      }
    }

    // Format VA display based on template settings
    String vaDisplay = _formatVADisplay(
      vaPercentage: vaPercentage,
      vaGrams: vaGrams,
      vaAmount: vaAmount,
      displayType: vaDisplayFormat,
      wastageType: wastageType ?? '%',
    );

    log("VA Display: $vaDisplay");

    // Header
    bytes += generator.text(
      'ROUGH ESTIMATE',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    // Date and Rate on same line
    bytes += generator.row([
      PosColumn(
        width: 6,
        text:
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      ),
      PosColumn(
        width: 6,
        text: 'Rate: ${singleEstimate.rate.text}',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr();

    // Tag and Item Details
    bytes += generator.row([
      PosColumn(width: 4, text: 'Tag'),
      PosColumn(width: 1, text: ':'),
      PosColumn(
        width: 7,
        text: '${singleEstimate.code.text}-${singleEstimate.tagNo.text}',
      ),
    ]);

    // // Add Vendor Code if enabled
    // if (estimatePrintTemplate?.vendorCode == true) {
    //   String vendorCode = singleEstimate.itemResponse?.vendorCode ?? '';
    //   if (vendorCode.isNotEmpty) {
    //     bytes += generator.row([
    //       PosColumn(width: 4, text: 'Vendor'),
    //       PosColumn(width: 1, text: ':'),
    //       PosColumn(width: 7, text: vendorCode),
    //     ]);
    //   }
    // }

    bytes += generator.row([
      PosColumn(width: 4, text: 'Design'),
      PosColumn(width: 1, text: ':'),
      PosColumn(
        width: 7,
        text:
            "${singleEstimate.itemResponse?.design?.name} (${singleEstimate.itemResponse?.purity})",
      ),
    ]);

    // // Add Stock Age if enabled
    // if (estimatePrintTemplate?.stockAge == true) {
    //   // Calculate stock age based on createdAt or other date field
    //   // This is a placeholder - adjust based on your actual data structure
    //   bytes += generator.row([
    //     PosColumn(width: 4, text: 'Stock Age'),
    //     PosColumn(width: 1, text: ':'),
    //     PosColumn(width: 7, text: 'X days'), // Replace with actual calculation
    //   ]);
    // }

    // Weight Details
    bytes += generator.text(''); // Add a blank line
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Gross Wt.'),
      PosColumn(
        width: 4,
        text: singleEstimate.gwt.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // Stone weight
    if (singleEstimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
      double stoneWeight =
          singleEstimate.itemResponse?.lineStones?.fold<double>(
            0,
            (sum, stone) => sum + getCaratConvertedToGramsForTotal(stone),
          ) ??
          0;
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'Stn.Wt.'),
        PosColumn(
          width: 4,
          text: stoneWeight.toStringAsFixed(3),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.text(''); // Blank line
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Nett Wt.'),
      PosColumn(
        width: 4,
        text: singleEstimate.nwt.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'V.Addn'),
      PosColumn(
        width: 4,
        text: vaDisplay,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Rate/Gm.'),
      PosColumn(
        width: 4,
        text: singleEstimate.rate.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: ''),
      PosColumn(width: 4, text: '---------------'),
      PosColumn(width: 2, text: ''),
    ]);

    // Calculate subtotal (metal cost)
    double subtotal = 0;
    try {
      double nwt = double.parse(singleEstimate.nwt.text);
      double va = double.parse(singleEstimate.va.text);
      double rate = double.parse(singleEstimate.rate.text);

      if (isInputVaPercent) {
        subtotal = (nwt + (nwt * va / 100)) * rate;
      } else {
        subtotal = (nwt + va) * rate;
      }
    } catch (e) {
      log("Error calculating subtotal: $e");
    }

    log("Subtotal: ${formatNumber(subtotal.ceil().toString())}");
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: ' '),
      PosColumn(
        width: 4,
        text: formatNumber(subtotal.ceil().toString()),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // Add MC
    if (singleEstimate.itemResponse?.mc != null) {
      String mcDisplay;

      if (estimatePrintTemplate?.mcTotal == true) {
        // Use mcTotal from backend
        mcDisplay = formatNumber(
          singleEstimate.itemResponse?.mcTotal ?? singleEstimate.mc.text,
        );
      } else {
        // Use mc per-gram from backend
        mcDisplay = formatNumber(singleEstimate.mc.text);
      }
      log("MC Display: $mcDisplay");
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'M C'),
        PosColumn(
          width: 4,
          text: mcDisplay,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    // Calculate and add Stone cost
    if (singleEstimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
      double totalStoneAmount = 0;
      for (var stone in singleEstimate.itemResponse?.lineStones ?? []) {
        try {
          totalStoneAmount += double.parse(stone.total ?? '0');
        } catch (e) {
          log("Error parsing stone amount: $e");
        }
      }
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'Stone'),
        PosColumn(
          width: 4,
          text: formatNumber(totalStoneAmount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: ''),
      PosColumn(width: 4, text: '---------------'),
      PosColumn(width: 2, text: ''),
    ]);

    // Total Amount
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Total.'),
      PosColumn(
        width: 4,
        text: formatNumber(singleEstimate.salesAmount),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // Calculate GST
    double salesAmountValue = double.tryParse(singleEstimate.salesAmount) ?? 0;
    double gstRaw = salesAmountValue * 0.03;
    double gstAmount = gstRaw.ceilToDouble();
    double netAmount = salesAmountValue + gstAmount;

    log("GST Amount: $gstAmount");
    log("Net Amount: $netAmount");
    log("========== REGULAR ESTIMATE CALCULATION END ==========");

    // Add GST row only if includeGstInPrint is true
    if (includeGstInPrint && billingSummary != null) {
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(
          width: 4,
          text:
              'GST ${singleEstimate.itemResponse?.designLineItem?.ornament?.gst}%',
        ),
        PosColumn(
          width: 4,
          text: formatNumber(gstAmount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Nett'),
      PosColumn(
        width: 4,
        text: formatNumber(netAmount.toString()),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // Print stone details if available
    if (singleEstimate.stoneDetailsTableData.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.text(
        'Stone Details :',
        styles: const PosStyles(align: PosAlign.left),
      );

      for (var stone in singleEstimate.itemResponse?.lineStones ?? []) {
        String weightDisplay =
            stone.carat?.isNotEmpty == true
                ? '${stone.carat}ctX'
                : '${stone.weight}gmsX';
        String pieces = stone.pieces?.toString() ?? '';

        // Format rate to remove unnecessary decimals (max 1 decimal)
        double rateValue = double.tryParse(stone.rate ?? '0') ?? 0;
        String rateDisplay =
            rateValue % 1 == 0
                ? rateValue
                    .toInt()
                    .toString() // No decimal if whole number
                : rateValue.toStringAsFixed(1); // Max 1 decimal

        log("Printing stone details...");
        log("Stone Name: ${stone.name}");
        log("Pieces: $pieces");
        log("Weight Display: $weightDisplay");
        log("Rate: $rateDisplay");
        log("Total: ${stone.total}");

        bytes += generator.row([
          PosColumn(width: 3, text: stone.name ?? ''),
          PosColumn(width: 4, text: '$pieces $weightDisplay'),
          PosColumn(width: 2, text: '$rateDisplay='),
          PosColumn(
            width: 3,
            text: stone.total ?? '',
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    return bytes;
  }

  List<int> generateQuickEstimateBytes({
    required Generator generator,
    required EstimationItemDetailsTableData singleEstimate,
    required PostEstimateResponseBillingSummary? billingSummary,
    required GoldRateController rateController,
    required List<PostEstimateResponseOldGold> oldGolds,
    required bool includeGstInPrint,
    EstimatePrintTemplate? estimatePrintTemplate,
    required String vaDisplayFormat,
  }) {
    List<int> bytes = [];

    log("========== QUICK ESTIMATE CALCULATION START ==========");
    log("Input salesAmount: ${singleEstimate.salesAmount}");
    log("VA Display Format: $vaDisplayFormat");

    double nettWeight = double.tryParse(singleEstimate.nwt.text) ?? 0;
    double grossWeight = double.tryParse(singleEstimate.gwt.text) ?? 0;
    double metalRate = double.tryParse(singleEstimate.rate.text) ?? 0;
    double vaValue = double.tryParse(singleEstimate.va.text) ?? 0;
    double mcValue = double.tryParse(singleEstimate.mc.text) ?? 0;
    double stoneCost = double.tryParse(singleEstimate.stone.text) ?? 0;
    double hallMarkCost = double.tryParse(singleEstimate.hallMark.text) ?? 0;

    String? wastageType =
        singleEstimate.itemResponse?.designLineItem?.wastageType;
    VAType vaType = getVAType(wastageType);
    bool isInputVaPercent = wastageType == '%';

    String? mcType =
        singleEstimate.itemResponse?.designLineItem?.makingChargesType;
    MCType mcTypeEnum = getMCType(mcType);

    bool isGstApplicable = true;
    double gstPercentage =
        double.tryParse(
          singleEstimate.itemResponse?.designLineItem?.ornament?.gst ?? "0",
        ) ??
        0;

    JewelryCalculator calculator = JewelryCalculator(
      nettWeight: nettWeight,
      vaType: vaType,
      vaValue: vaValue,
      metalRate: metalRate,
      grossWeight: grossWeight,
      mcType: mcTypeEnum,
      mcValue: mcValue,
      stoneCost: stoneCost + hallMarkCost,
      isGstApplicable: isGstApplicable,
      gstPercentage: gstPercentage,
      printGstInVA: false,
      costDiscount: double.tryParse(singleEstimate.costDiscount.text) ?? 0,
    );

    JewelryCalculationReport report = calculator.generateReport();

    // Calculate VA in both formats
    double vaPercentage = 0;
    double vaGrams = 0;
    double vaAmount = 0;

    if (isInputVaPercent) {
      vaPercentage = vaValue;
      vaGrams = (nettWeight * vaPercentage) / 100;
      vaAmount = vaGrams * metalRate;
    } else {
      vaGrams = vaValue;
      vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
      vaAmount = vaGrams * metalRate;
    }

    // Adjust VA if GST should be included in VA display
    if (!includeGstInPrint && billingSummary?.gst != null) {
      try {
        double gstAmount = double.parse(billingSummary!.gst!);
        double gstAsVaGrams = gstAmount / metalRate;
        vaGrams += gstAsVaGrams;
        vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
        vaAmount += gstAmount;
      } catch (e) {
        log("Error adjusting VA for GST: $e");
      }
    }

    // Format VA display based on template settings
    String vaDisplay = _formatVADisplay(
      vaPercentage: vaPercentage,
      vaGrams: vaGrams,
      vaAmount: vaAmount,
      displayType: vaDisplayFormat,
      wastageType: wastageType ?? '%',
    );

    log("VA Display: $vaDisplay");

    // Header
    bytes += generator.text(
      'ROUGH ESTIMATE',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    // Date and Rate on same line
    bytes += generator.row([
      PosColumn(
        width: 6,
        text:
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      ),
      PosColumn(
        width: 6,
        text: 'Rate: ${singleEstimate.rate.text}',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // // Add Rate Valid Till if enabled
    // if (estimatePrintTemplate?.rateValideTill == true) {
    //   DateTime validTill = DateTime.now().add(const Duration(days: 7));
    //   bytes += generator.text(
    //     'Rate Valid Till: ${validTill.day}-${validTill.month}-${validTill.year}',
    //     styles: const PosStyles(align: PosAlign.center),
    //   );
    // }

    bytes += generator.hr();

    // Tag and Item Details
    bytes += generator.row([
      PosColumn(width: 4, text: 'Tag'),
      PosColumn(width: 1, text: ':'),
      PosColumn(
        width: 7,
        text: '${singleEstimate.code.text}-${singleEstimate.tagNo.text}',
      ),
    ]);

    // Add Vendor Code if enabled
    if (estimatePrintTemplate?.vendorCode == true) {
      String vendorCode = singleEstimate.itemResponse?.vendorCode ?? '';
      if (vendorCode.isNotEmpty) {
        bytes += generator.row([
          PosColumn(width: 4, text: 'Vendor'),
          PosColumn(width: 1, text: ':'),
          PosColumn(width: 7, text: vendorCode),
        ]);
      }
    }

    bytes += generator.row([
      PosColumn(width: 4, text: 'Design'),
      PosColumn(width: 1, text: ':'),
      PosColumn(
        width: 7,
        text: singleEstimate.itemResponse?.design?.name ?? '',
      ),
    ]);

    // // Add Stock Age if enabled
    // if (estimatePrintTemplate?.stockAge == true) {
    //   bytes += generator.row([
    //     PosColumn(width: 4, text: 'Stock Age'),
    //     PosColumn(width: 1, text: ':'),
    //     PosColumn(width: 7, text: 'X days'),
    //   ]);
    // }

    // Weight Details
    bytes += generator.text('');
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Gross Wt.'),
      PosColumn(
        width: 4,
        text: singleEstimate.gwt.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    if (singleEstimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
      double stoneWeight =
          singleEstimate.itemResponse?.lineStones?.fold<double>(
            0,
            (sum, stone) => sum + getCaratConvertedToGramsForTotal(stone),
          ) ??
          0;
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'Stn.Wt.'),
        PosColumn(
          width: 4,
          text: stoneWeight.toStringAsFixed(3),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.text('');
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Nett Wt.'),
      PosColumn(
        width: 4,
        text: singleEstimate.nwt.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    log("Net Weight: ${singleEstimate.nwt.text}");
    log("Gross Weight: ${singleEstimate.gwt.text}");

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'V.Addn'),
      PosColumn(
        width: 4,
        text: vaDisplay,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Rate/Gm.'),
      PosColumn(
        width: 4,
        text: singleEstimate.rate.text,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: ''),
      PosColumn(width: 4, text: '---------------'),
      PosColumn(width: 2, text: ''),
    ]);

    // Calculate subtotal
    double subtotal = 0;
    try {
      double nwt = double.parse(singleEstimate.nwt.text);
      double va = double.parse(singleEstimate.va.text);
      double rate = double.parse(singleEstimate.rate.text);

      if (isInputVaPercent) {
        subtotal = (nwt + (nwt * va / 100)) * rate;
      } else {
        subtotal = (nwt + va) * rate;
      }
    } catch (e) {
      subtotal = report.calculations.metalCost;
    }
    log("Subtotal: ${formatNumber(subtotal.ceil().toString())}");

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: '  '),
      PosColumn(
        width: 4,
        text: formatNumber(subtotal.ceil().toString()),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // bytes += generator.row([
    //   PosColumn(width: 2, text: ''),
    //   PosColumn(width: 4, text: ''),
    //   PosColumn(
    //       width: 4,
    //       text: formatNumber(subtotal.toString()),
    //       // styles: const PosStyles(align: PosAlign.right)),
    //   ),
    //   PosColumn(width: 2, text: ''),
    // ]);

    // Add MC
    if (singleEstimate.itemResponse?.mc != null) {
      String mcDisplay;

      if (estimatePrintTemplate?.mcTotal == true) {
        log("=== MC TOTAL DEBUG ===");
        log("mcTotal setting enabled: ${estimatePrintTemplate?.mcTotal}");
        log("itemResponse.mc: ${singleEstimate.itemResponse?.mc}");
        log("itemResponse.mcTotal: ${singleEstimate.itemResponse?.mcTotal}");
        log("mc.text: ${singleEstimate.mc.text}");
        log(
          "makingChargesType: ${singleEstimate.itemResponse?.designLineItem?.makingChargesType}",
        );

        // Use mcTotal from backend
        String mcTotalValue =
            singleEstimate.itemResponse?.mcTotal ?? singleEstimate.mc.text;
        log("Selected mcTotalValue (before format): $mcTotalValue");

        mcDisplay = formatNumber(mcTotalValue);
        log("Final mcDisplay (after format): $mcDisplay");
        log("=== END MC TOTAL DEBUG ===");
      } else {
        // Use mc per-gram from backend
        mcDisplay = formatNumber(singleEstimate.mc.text);
      }

      log("MC Display: $mcDisplay");

      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'M C'),
        PosColumn(
          width: 4,
          text: mcDisplay,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }
    // Stone cost - NOW OUTSIDE THE MC IF BLOCK
    if (singleEstimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
      double totalStoneAmount = 0;
      for (var stone in singleEstimate.itemResponse?.lineStones ?? []) {
        try {
          totalStoneAmount += double.parse(stone.total ?? '0');
        } catch (e) {
          log("Error parsing stone total: $e");
        }
      }
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(width: 4, text: 'Stone'),
        PosColumn(
          width: 4,
          text: formatNumber(totalStoneAmount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: ''),
      PosColumn(width: 4, text: '---------------'),
      PosColumn(width: 2, text: ''),
    ]);

    // Total Amount
    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Total.'),
      PosColumn(
        width: 4,
        text: formatNumber(singleEstimate.salesAmount),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    double salesAmountValue = double.tryParse(singleEstimate.salesAmount) ?? 0;
    double gstRaw = salesAmountValue * 0.03;
    double gstAmount = gstRaw.ceilToDouble();
    double netAmount = salesAmountValue + gstAmount;

    log("GST Amount: $gstAmount");
    log("Net Amount: $netAmount");
    log("========== QUICK ESTIMATE CALCULATION END ==========");

    // Add GST row
    if (includeGstInPrint && billingSummary != null) {
      bytes += generator.row([
        PosColumn(width: 2, text: ''),
        PosColumn(
          width: 4,
          text:
              'GST ${singleEstimate.itemResponse?.designLineItem?.ornament?.gst}%',
        ),
        PosColumn(
          width: 4,
          text: formatNumber(gstAmount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(width: 2, text: ''),
      ]);
    }

    bytes += generator.row([
      PosColumn(width: 2, text: ''),
      PosColumn(width: 4, text: 'Nett'),
      PosColumn(
        width: 4,
        text: formatNumber(netAmount.toString()),
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(width: 2, text: ''),
    ]);

    // Print stone details
    if (singleEstimate.stoneDetailsTableData.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.text(
        'Stone Details :',
        styles: const PosStyles(align: PosAlign.left),
      );

      for (var stone in singleEstimate.itemResponse?.lineStones ?? []) {
        String weightDisplay =
            stone.carat?.isNotEmpty == true
                ? '${stone.carat}ctX'
                : '${stone.weight}gmsX';
        String pieces = stone.pieces?.toString() ?? '';
        bytes += generator.row([
          PosColumn(width: 3, text: stone.name ?? ''),
          PosColumn(width: 4, text: '$pieces $weightDisplay'),
          PosColumn(width: 2, text: '${formatDecimal(stone.rate)}='),
          PosColumn(
            width: 3,
            text: formatDecimal(stone.total),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    return bytes;
  }

  String formatDecimal(dynamic value) {
    if (value == null || value == '') return '';

    double number =
        value is String ? double.tryParse(value) ?? 0 : value.toDouble();

    // Check if it's a whole number
    if (number == number.truncate()) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(1);
    }
  }

  List<int> _generateMultipleItemsEstimate(
    Generator generator,
    List<EstimationItemDetailsTableData> estimates,
    RateCaratInputController rateController,
    PostEstimateResponseBillingSummary? billingSummary,
    List<PostEstimateResponseOldGold> oldGolds,
    bool includeGstInPrint,
    EstimatePrintTemplate? estimatePrintTemplate,
    String vaDisplayFormat,
  ) {
    List<int> bytes = [];

    log("========== MULTIPLE ITEMS ESTIMATE START ==========");
    log("Total estimates: ${estimates.length}");

    // Helper method for consistent purity retrieval
    String getPurityForEstimate(EstimationItemDetailsTableData estimate) {
      String purity =
          estimate.itemResponse?.purity ??
          estimate.itemResponse?.designLineItem?.purity ??
          "";
      return purity;
    }

    // Get unique purities and group items
    Map<String, List<EstimationItemDetailsTableData>> purityGroupedItems = {};

    for (int i = 0; i < estimates.length; i++) {
      var estimate = estimates[i];
      String purity = getPurityForEstimate(estimate);

      log("--- Item ${i + 1} ---");
      log("itemResponse?.purity: ${estimate.itemResponse?.purity}");
      log(
        "designLineItem?.purity: ${estimate.itemResponse?.designLineItem?.purity}",
      );
      log("Final purity used: $purity");

      if (purity.isNotEmpty) {
        if (!purityGroupedItems.containsKey(purity)) {
          purityGroupedItems[purity] = [];
          log("Created new purity group: $purity");
        }
        purityGroupedItems[purity]!.add(estimate);
      } else {
        log("WARNING: Item ${i + 1} has empty purity!");
      }
    }

    log("Total unique purities found: ${purityGroupedItems.length}");
    log("Purities: ${purityGroupedItems.keys.join(', ')}");

    // Display rates
    if (purityGroupedItems.isNotEmpty) {
      log("Displaying rates for purities...");

      List<String> rateLines = [];

      for (var purity in purityGroupedItems.keys) {
        log("Getting rate for purity: $purity");
        String rate = rateController.getRateForPurity(purity);
        log("Rate from getRateForPurity($purity): $rate");

        if (rate.isEmpty || rate == '0') {
          String normalizedPurity = purity.toLowerCase().replaceAll(' ', '_');
          log("Trying normalized purity: $normalizedPurity");
          rate = rateController.getRateForPurity(normalizedPurity);
          log("Rate from getRateForPurity($normalizedPurity): $rate");
        }

        if (rate.isNotEmpty && rate != '0') {
          rateLines.add('$purity: $rate');
          log("Added rate line: $purity: $rate");
        } else {
          log("WARNING: No valid rate found for purity: $purity");
        }
      }

      // Print rates
      if (rateLines.isNotEmpty) {
        if (rateLines.length == 1) {
          bytes += generator.text(
            'Gold Rate: ${rateLines[0]}',
            styles: const PosStyles(align: PosAlign.left),
          );
        } else {
          String ratesText = 'Gold Rates: ${rateLines.join(', ')}';
          log("Printing rates: $ratesText");
          bytes += generator.text(
            ratesText,
            styles: const PosStyles(align: PosAlign.left),
          );
        }
      }
    } else {
      log("No purity groups found, using default rates");
      bytes += generator.text(
        'Gold Rate(22K): ${rateController.getGoldRatesResponse.value.data?.price22k}',
        styles: const PosStyles(align: PosAlign.left),
      );

      bytes += generator.text(
        'Silver Rate: ${rateController.getGoldRatesResponse.value.data?.priceSilver}',
        styles: const PosStyles(align: PosAlign.left),
      );
    }

    bytes += generator.hr(ch: '-');

    // Table Header
    bytes += generator.row([
      PosColumn(width: 2, text: 'Item'),
      PosColumn(width: 2, text: 'Nwt'),
      PosColumn(
        width: 2,
        text: 'V.A',
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(width: 2, text: 'MC'),
      PosColumn(width: 2, text: 'Stn'),
      PosColumn(
        width: 2,
        text: 'Amount',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr(ch: '-');

    // Calculate GST per item if needed
    double? gstPerItem;
    if (!includeGstInPrint &&
        billingSummary?.gst != null &&
        estimates.isNotEmpty) {
      try {
        double totalGst = double.parse(billingSummary!.gst!);
        gstPerItem = totalGst / estimates.length;
      } catch (e) {
        log("Error calculating GST per item: $e");
      }
    }

    // Items
    int serialNumber = 1;
    for (var estimate in estimates) {
      String purity = getPurityForEstimate(estimate);
      log("Printing item $serialNumber with purity: $purity");

      double nettWeight = double.tryParse(estimate.nwt.text) ?? 0;
      double vaValue = double.tryParse(estimate.va.text) ?? 0;
      double metalRate = double.tryParse(estimate.rate.text) ?? 0;

      String? wastageType = estimate.itemResponse?.designLineItem?.wastageType;
      bool isInputVaPercent = wastageType == '%';

      // Calculate VA in both formats
      double vaPercentage = 0;
      double vaGrams = 0;
      double vaAmount = 0;

      if (isInputVaPercent) {
        vaPercentage = vaValue;
        vaGrams = (nettWeight * vaPercentage) / 100;
        vaAmount = vaGrams * metalRate;
      } else {
        vaGrams = vaValue;
        vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
        vaAmount = vaGrams * metalRate;
      }

      // Add GST to VA if needed
      if (!includeGstInPrint && gstPerItem != null && metalRate > 0) {
        double gstAsVaGrams = gstPerItem / metalRate;
        vaGrams += gstAsVaGrams;
        vaPercentage = nettWeight > 0 ? (vaGrams / nettWeight) * 100 : 0;
        vaAmount += gstPerItem;
      }

      // Format VA display
      String vaDisplay = _formatVADisplay(
        vaPercentage: vaPercentage,
        vaGrams: vaGrams,
        vaAmount: vaAmount,
        displayType: vaDisplayFormat,
        wastageType: wastageType ?? '%',
      );

      // Calculate stone amount
      double stoneAmount = 0;
      if (estimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
        stoneAmount = estimate.itemResponse!.lineStones!.fold(
          0.0,
          (sum, stone) => sum + (double.tryParse(stone.total ?? '0') ?? 0),
        );
      }

      // Print item details
      String serial = serialNumber.toString();
      serialNumber++;
      String itemName = StringUtils.restrictLength(
        estimate.item_description.text,
        20,
      );
      String tagNumber =
          "${(estimate.itemResponse?.code)} ${(estimate.itemResponse?.tagNumber?.toString() ?? "")}";
      String grossWeight = estimate.gwt.text;

      // FIXED: Now using the consistent purity from helper method
      bytes += generator.text(
        StringUtils.leftAlign("$serial. $tagNumber-$itemName ($purity)", 46),
      );
      log("Printed item line with purity: $purity");

      // Prepare MC display - use backend value
      String mcDisplay =
          estimatePrintTemplate?.mcTotal == true
              ? formatNumber(estimate.itemResponse?.mcTotal ?? estimate.mc.text)
              : estimate.mc.text;

      bytes += generator.row([
        PosColumn(
          width: 1,
          text: serial,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: estimate.nwt.text,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: vaDisplay,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: mcDisplay,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: formatNumber(stoneAmount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 3,
          text: formatNumber(estimate.salesAmount),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      // ============================================
      // FIX 1: Print stone details ONLY ONCE
      // Check lineStones first, then stoneDetailsTableData
      // ============================================
      bool hasPrintedStones = false;

      // Try printing from lineStones first
      if (estimate.itemResponse?.lineStones?.isNotEmpty ?? false) {
        log("Printing stones from lineStones for item $serialNumber");
        bool isFirst = true;
        for (var stone in estimate.itemResponse!.lineStones!) {
          String stoneName = StringUtils.restrictLength("${stone.name}:", 10);
          String weightDisplay =
              stone.carat?.isNotEmpty == true
                  ? 'Ct:${stone.carat}*'
                  : 'Gm:${stone.weight}*';
          String rate = '${formatNumber(stone.rate)}=';
          String total = formatNumber(stone.total);
          String gwDisplay =
              isFirst
                  ? '(GW:${grossWeight.toString()})'.padLeft(12)
                  : ''.padLeft(12);
          String pieces = stone.pieces?.toString() ?? '';

          String line =
              stoneName.padLeft(8) +
              (pieces + weightDisplay).padLeft(12) +
              rate.padLeft(1) +
              total.padLeft(1) +
              gwDisplay;

          bytes += generator.text(
            line,
            styles: const PosStyles(align: PosAlign.right),
          );
          isFirst = false;
        }
        hasPrintedStones = true;
      }

      // Only print from stoneDetailsTableData if we haven't printed from lineStones
      if (!hasPrintedStones && estimate.stoneDetailsTableData.isNotEmpty) {
        log(
          "Printing stones from stoneDetailsTableData for item $serialNumber",
        );
        bool isFirst = true;
        for (var stone in estimate.stoneDetailsTableData) {
          String stoneName = StringUtils.restrictLength(
            "${stone.name.text}:",
            10,
          );

          String weightDisplay =
              stone.weightUnitFromBackend == 'CT'
                  ? 'Ct:${stone.carat_weight.text}*'
                  : 'Gm:${stone.carat_weight.text}*';
          String rate = '${formatNumber(stone.rate.text)}=';
          String total = formatNumber(stone.total.text);
          String gwDisplay =
              isFirst
                  ? '(GW:${grossWeight.toString()})'.padLeft(12)
                  : ''.padLeft(12);
          String pieces = stone.pcs.text;

          String line =
              stoneName.padLeft(8) +
              (pieces + weightDisplay).padLeft(12) +
              rate.padLeft(1) +
              total.padLeft(1) +
              gwDisplay;

          bytes += generator.text(
            line,
            styles: const PosStyles(align: PosAlign.right),
          );
          isFirst = false;
        }
      }

      bytes += generator.text('');
    }

    log("========== MULTIPLE ITEMS ESTIMATE END ==========");

    bytes += generator.hr();

    // ============================================
    // FIX 2: Add total net weight in summary
    // ============================================
    if (billingSummary != null) {
      // Calculate total net weight from all items
      double totalNetWeight = 0;
      for (var estimate in estimates) {
        totalNetWeight += double.tryParse(estimate.nwt.text) ?? 0;
      }

      double subTotalValue =
          double.tryParse(billingSummary.subTotal ?? '0') ?? 0;
      double gstRaw = subTotalValue * 0.03;
      double gstAmount = gstRaw.ceilToDouble();
      double netTotal = subTotalValue + gstAmount;

      // Display items count with total net weight
      String itemsText =
          "${estimates.length} Items (${totalNetWeight.toStringAsFixed(3)}g)";
      log("Summary: $itemsText");

      bytes += generator.row([
        PosColumn(width: 5, text: itemsText),
        PosColumn(
          width: 7,
          text: formatNumber(billingSummary.subTotal ?? ''),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (includeGstInPrint) {
        bytes += generator.row([
          PosColumn(
            width: 8,
            text:
                'GST ${estimates.first.itemResponse?.designLineItem?.ornament?.gst ?? ""}%',
          ),
          PosColumn(
            width: 4,
            text: formatNumber(gstAmount.toString()),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.row([
        PosColumn(width: 5, text: "Total"),
        PosColumn(
          width: 7,
          text: netTotal.toStringAsFixed(2),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    // Old Gold Section
    if (oldGolds.isNotEmpty) {
      bytes += generator.hr();
      bytes += generator.text(
        'Valuation',
        styles: const PosStyles(align: PosAlign.left, bold: true),
      );

      bytes += generator.row([
        PosColumn(
          width: 2,
          text: 'Item Wt',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: 'Dust',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: 'Wst',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: 'Rate',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: 'Amt',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: '',
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      double totalGrossWeight = 0;
      for (var oldGold in oldGolds) {
        totalGrossWeight += double.tryParse(oldGold.grossWeight ?? '0') ?? 0;

        bytes += generator.row([
          PosColumn(
            width: 2,
            text: oldGold.grossWeight ?? '',
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            width: 2,
            text: oldGold.less ?? '',
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: "${oldGold.purityType ?? "-"}%",
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: formatNumber(oldGold.rate ?? ''),
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: formatNumber(oldGold.amount ?? ''),
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: '',
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.row([
        PosColumn(
          width: 8,
          text: 'Exch ${totalGrossWeight.toStringAsFixed(3)}g',
        ),
        PosColumn(
          width: 4,
          text: formatNumber(billingSummary?.oldGoldAmount ?? ''),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    generator.hr();

    bytes += generator.row([
      PosColumn(width: 8, text: 'Nett'),
      PosColumn(
        width: 4,
        text: formatNumber(billingSummary?.total ?? ''),
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    return bytes;
  }

  List<int> _generateFooter(
    Generator generator,
    PostEstimateResponse estimate,
    EstimatePrintTemplate? estimatePrintTemplate,
  ) {
    List<int> bytes = [];

    bytes += generator.hr();
    String time =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
    String estimateNumber = estimate.estimateNumber ?? "";
    String vendorCode = "X";
    String system = "X";
    String stockAge = "X";

    bytes += generator.text(
      '$time/$vendorCode/$system/$stockAge/$estimateNumber',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'SUBJECT TO BILLING ON APPROVAL..',
      styles: const PosStyles(align: PosAlign.center),
    );

    // Add Rate Valid Till if enabled
    if (estimatePrintTemplate?.rateValideTill == true) {
      DateTime validTill = DateTime.now();
      bytes += generator.text(
        'Rate Valid Till: ${validTill.day}-${validTill.month}-${validTill.year}',
        styles: const PosStyles(align: PosAlign.center),
      );
    }
    // Add additional message if enabled
    if (estimatePrintTemplate?.showAdditionalMessage == true &&
        estimatePrintTemplate?.additionalMessage?.isNotEmpty == true) {
      bytes += generator.text(
        estimatePrintTemplate!.additionalMessage!,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    if (estimate.estimateNumber != null) {
      bytes += generator.barcode(
        Barcode.code39(estimate.estimateNumber!.split('')),
        height: 50,
        width: 2,
        textPos: BarcodeText.none,
      );
    }

    bytes += generator.feed(1);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> _sendBytesToPrint(List<int> bytes, PrinterType type) async {
    await printerManager.send(type: type, bytes: bytes);
    await printerManager.disconnect(type: type);
  }

  Future<bool> _checkConnection({required BasePrinterInput input}) async {
    bool connected = false;
    try {
      connected = await printerManager.connect(
        type: input.printerType,
        model: input,
      );
      log("The connected is $connected");
    } catch (_) {
      log("Connection error _checkConnection ");
      connected = false;
    }
    return connected;
  }

  Future<void> printValuationSlip({
    required PostGlobalOldGoldResponse oldGoldData,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    log("Print valuation called onprint inside start");

    bytes += generator.text(
      'VALUATION SLIP',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    if (oldGoldData.values?.firstOrNull?.oldGoldEstimateNumber != null) {
      bytes += generator.text(
        'OG Estimate No: ${oldGoldData.values!.first.oldGoldEstimateNumber}',
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += generator.text(
      '    ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      styles: const PosStyles(align: PosAlign.left),
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(width: 2, text: 'Item'),
      PosColumn(width: 2, text: 'GWt'),
      PosColumn(width: 2, text: 'Dust'),
      PosColumn(width: 2, text: 'Wst'),
      PosColumn(width: 2, text: 'Rate'),
      PosColumn(
        width: 2,
        text: 'Amount',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr();

    double totalGrossWeight = 0;
    // double totalLess = 0;
    // double totalNetWeight = 0;
    double totalAmount = 0;

    for (var item in oldGoldData.values ?? <PostGlobalOldGoldResponseValue>[]) {
      // Parse and round the amount
      double amountValue = double.tryParse(item.amount ?? '0') ?? 0;
      String roundedAmount = amountValue.ceil().toStringAsFixed(
        0,
      ); // Use toStringAsFixed(0) instead

      // Parse and format rate to max 1 decimal
      double rateValue = double.tryParse(item.rate ?? '0') ?? 0;
      String formattedRate =
          rateValue % 1 == 0
              ? rateValue.toStringAsFixed(
                0,
              ) // Use toStringAsFixed(0) instead of toInt().toString()
              : rateValue.toStringAsFixed(1);

      // Format grossWeight and less to avoid scientific notation
      double grossWeightValue = double.tryParse(item.grossWeight ?? '0') ?? 0;
      String formattedGrossWeight =
          grossWeightValue % 1 == 0
              ? grossWeightValue.toStringAsFixed(0)
              : grossWeightValue.toStringAsFixed(3);

      double lessValue = double.tryParse(item.less ?? '0') ?? 0;
      String formattedLess = lessValue.toStringAsFixed(3);

      log("Formatted rate: $formattedRate");
      bytes += generator.row([
        PosColumn(
          width: 2,
          text: item.code ?? '-',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: formattedGrossWeight, // Use formatted value
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: formattedLess, // Use formatted value
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: "${item.purity ?? "-"}%",
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: formattedRate,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: roundedAmount,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (item.description != null && item.description!.isNotEmpty) {
        bytes += generator.text(
          '${item.description}'.padRight(46),
          styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
          ),
        );
      }

      totalGrossWeight += grossWeightValue;
      // totalLess += lessValue;
      // totalNetWeight += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalAmount += amountValue.ceilToDouble();
    }
    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(width: 2, text: 'Total'),
      PosColumn(width: 2, text: totalGrossWeight.toStringAsFixed(3)),
      PosColumn(width: 2, text: ""),
      PosColumn(width: 2, text: ""),
      PosColumn(
        width: 2,
        text: '',
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        width: 2,
        text: totalAmount.ceil().toString(),
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    double totalRoundOff = 0;
    bool hasRoundOff =
        oldGoldData.values?.any(
          (item) => double.tryParse(item.roundOff ?? '0') != 0,
        ) ??
        false;

    if (hasRoundOff) {
      for (var item in oldGoldData.values ?? []) {
        totalRoundOff += double.tryParse(item.roundOff ?? '0') ?? 0;
      }
      bytes += generator.row([
        PosColumn(width: 1, text: ''),
        PosColumn(width: 7, text: 'Round Off'),
        PosColumn(
          width: 4,
          text: formatNumber(totalRoundOff.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    double netTotal = totalAmount + totalRoundOff;
    bytes += generator.row([
      PosColumn(
        width: 8,
        text: 'Net Total',
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        width: 4,
        text: netTotal.round().toString(),
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    bytes += generator.hr();
    bytes += generator.text(
      'SUBJECT TO FINAL SETTLEMENT',
      styles: const PosStyles(align: PosAlign.center),
    );

    if (oldGoldData.values?.firstOrNull?.oldGoldEstimateNumber != null) {
      bytes += generator.barcode(
        Barcode.code39(
          oldGoldData.values!.first.oldGoldEstimateNumber!.split(''),
        ),
        height: 50,
        width: 2,
        textPos: BarcodeText.none,
      );
    }

    if (oldGoldData.values?.firstOrNull?.oldGoldEstimateNumber != null) {
      bytes += generator.text(
        oldGoldData.values?.first.oldGoldEstimateNumber ?? "",
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += generator.feed(1);
    bytes += generator.cut();

    await sendDataToPrint(bytes);
  }

  Future<void> printOldGoldValuationSlip({
    required PostGlobalOldGoldResponse oldGoldData,
    required String InvoiceNo,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    log("Print valuation called onprint inside start");

    bytes += generator.text(
      'Old Valuation',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
      ),
    );

    bytes += generator.text(
      '    ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      styles: const PosStyles(align: PosAlign.left),
    );

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(width: 2, text: 'Item'),
      PosColumn(width: 2, text: 'GWt'),
      PosColumn(width: 2, text: 'Dust'),
      PosColumn(width: 2, text: 'Wst'),
      PosColumn(width: 2, text: 'Rate'),
      PosColumn(
        width: 2,
        text: 'Amount',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr();

    double totalGrossWeight = 0;
    // double totalLess = 0;
    // double totalNetWeight = 0;
    double totalAmount = 0;

    for (var item in oldGoldData.values ?? <PostGlobalOldGoldResponseValue>[]) {
      // Parse and round the amount
      double amountValue = double.tryParse(item.amount ?? '0') ?? 0;
      String roundedAmount = amountValue.ceil().toString();

      // Parse and format rate to max 1 decimal
      double rateValue = double.tryParse(item.rate ?? '0') ?? 0;
      String formattedRate =
          rateValue % 1 == 0
              ? rateValue
                  .toInt()
                  .toString() // No decimal if whole number
              : rateValue.toStringAsFixed(1); // Max 1 decimal

      log("Formatted rate: $rateValue");

      bytes += generator.row([
        PosColumn(
          width: 2,
          text: item.code ?? '-',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: item.grossWeight ?? '0',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: item.less ?? '0',
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: "${item.purityType ?? "-"}%",
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: formattedRate, // Use formatted rate with max 1 decimal
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          width: 2,
          text: roundedAmount, // Use rounded amount
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (item.description != null && item.description!.isNotEmpty) {
        bytes += generator.text(
          '${item.description}'.padRight(46),
          styles: const PosStyles(
            align: PosAlign.left,
            width: PosTextSize.size1,
          ),
        );
      }

      totalGrossWeight += double.tryParse(item.grossWeight ?? '0') ?? 0;
      // totalLess += double.tryParse(item.less ?? '0') ?? 0;
      // totalNetWeight += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalAmount += amountValue.ceilToDouble(); // Use rounded value for total
    }

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(width: 2, text: 'Total'),
      PosColumn(width: 2, text: totalGrossWeight.toStringAsFixed(3)),
      PosColumn(width: 2, text: ""),
      PosColumn(width: 2, text: ""),
      PosColumn(
        width: 2,
        text: '',
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        width: 2,
        text: totalAmount.ceil().toString(), // Round total amount
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);

    // double totalRoundOff = 0;
    // bool hasRoundOff = oldGoldData.values
    //         ?.any((item) => double.tryParse(item.roundOff ?? '0') != 0) ??
    //     false;

    // if (hasRoundOff) {
    //   for (var item in oldGoldData.values ?? []) {
    //     totalRoundOff += double.tryParse(item.roundOff ?? '0') ?? 0;
    //   }
    //   bytes += generator.row([
    //     PosColumn(width: 1, text: ''),
    //     PosColumn(width: 7, text: 'Round Off'),
    //     PosColumn(
    //       width: 4,
    //       text: formatNumber(totalRoundOff.toString()),
    //       styles: const PosStyles(align: PosAlign.right),
    //     ),
    //   ]);
    // }

    // double netTotal = totalAmount + totalRoundOff;
    // bytes += generator.row([
    //   PosColumn(
    //       width: 8,
    //       text: 'Net Total',
    //       styles: const PosStyles(align: PosAlign.left)),
    //   PosColumn(
    //     width: 4,
    //     text: netTotal.round().toString(), // Round net total
    //     styles: const PosStyles(
    //       align: PosAlign.right,
    //       bold: true,
    //     ),
    //   ),
    // ]);

    String time =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    String invoiceNumber = InvoiceNo;
    String user = "X";
    String system = "X";

    bytes += generator.text(
      '$time/$user/$system/$invoiceNumber',
      styles: const PosStyles(align: PosAlign.left),
    );

    bytes += generator.feed(1);
    bytes += generator.cut();

    await sendDataToPrint(bytes);
  }

  Future<void> printSalesEstimateSlip({
    required GetSalesRecordByIdAggregateResponse salesRecord,
    EstimatePrintTemplate? estimatePrintTemplate,
  }) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    log("Print sales estimate called");

    String formatAddress(PartyDetails? partyDetails) {
      if (partyDetails?.address == null || partyDetails!.address!.isEmpty) {
        return '';
      }

      Address? addressInfo = partyDetails.address!.firstWhere(
        (addr) => addr.isDefault == true,
        orElse: () => partyDetails.address!.first,
      );

      List<String> addressParts = [];

      if (addressInfo.addressLine1 != null &&
          addressInfo.addressLine1!.isNotEmpty) {
        addressParts.add(addressInfo.addressLine1!);
      }

      if (addressInfo.addressLine2 != null &&
          addressInfo.addressLine2!.isNotEmpty) {
        addressParts.add(addressInfo.addressLine2!);
      }

      if (addressInfo.city != null && addressInfo.city!.isNotEmpty) {
        addressParts.add(addressInfo.city!);
      }

      return addressParts.join(', ');
    }

    // Customer Details
    if (salesRecord.partyDetails != null) {
      bytes += generator.text(
        '${salesRecord.partyDetails!.name ?? ""} ${salesRecord.partyDetails!.phoneNumber ?? ""}',
        styles: const PosStyles(align: PosAlign.left),
      );
      bytes += generator.text(
        formatAddress(salesRecord.partyDetails),
        styles: const PosStyles(align: PosAlign.left),
      );
    }

    String rateDisplay = '';
    if (salesRecord.lineItems != null && salesRecord.lineItems!.isNotEmpty) {
      Map<String, String> ratesByPurity = {};
      for (var item in salesRecord.lineItems!) {
        String purity = item.taggingRecord?.purity ?? '22K';
        String rate = item.rate ?? '';
        if (rate.isNotEmpty && !ratesByPurity.containsKey(purity)) {
          ratesByPurity[purity] = rate;
        }
      }

      if (ratesByPurity.length == 1) {
        var entry = ratesByPurity.entries.first;
        rateDisplay = 'Rate:${entry.value}';
      } else if (ratesByPurity.isNotEmpty) {
        rateDisplay = ratesByPurity.entries
            .map((e) => '${e.key}:${e.value}')
            .join(', ');
      }
    }

    bytes += generator.row([
      PosColumn(width: 6, text: rateDisplay.isNotEmpty ? rateDisplay : ''),
      PosColumn(
        width: 6,
        text:
            salesRecord.createdAt != null
                ? '${salesRecord.createdAt!.day}-${salesRecord.createdAt!.month}-${salesRecord.createdAt!.year}'
                : '',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr();

    // Table Header
    bytes += generator.row([
      PosColumn(width: 2, text: 'Item'),
      PosColumn(width: 2, text: 'Wt'),
      PosColumn(width: 2, text: 'VA'),
      PosColumn(width: 2, text: 'MC'),
      PosColumn(width: 2, text: 'Stn'),
      PosColumn(
        width: 2,
        text: 'Amount',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr();

    // Line Items
    double totalPieces = 0;
    double totalWeight = 0;
    double totalAmount = 0;

    for (var lineItem in salesRecord.lineItems ?? []) {
      // Item description and tag
      String itemDesc =
          '${lineItem.code ?? ""}-${lineItem.tag ?? ""} ${lineItem.description ?? ""}';
      bytes += generator.text(
        itemDesc,
        styles: const PosStyles(align: PosAlign.left),
      );

      // Parse numeric values
      double weight = double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0;
      double pieces = (lineItem.finalPieces ?? 0).toDouble();
      double amount = double.tryParse(lineItem.salesAmount ?? '0') ?? 0;

      // Format VA display based on wastage type
      String vaDisplay = '';
      if (lineItem.wastageType?.toLowerCase() == '%') {
        vaDisplay =
            '${double.tryParse(lineItem.finalVa ?? '0')?.toStringAsFixed(1) ?? '0'}%';
      } else {
        vaDisplay =
            '${double.tryParse(lineItem.finalVa ?? '0')?.toStringAsFixed(3) ?? '0'}g';
      }

      // Format MC display - use backend value
      String mcDisplay =
          estimatePrintTemplate?.mcTotal == true
              ? formatNumber(lineItem.finalMc ?? lineItem.finalMc ?? '0')
              : (lineItem.finalMc ?? '0');

      // Stone cost
      String stoneDisplay = formatNumber(
        double.tryParse(lineItem.stoneCost ?? '0').toString(),
      );

      // Item details row
      bytes += generator.row([
        PosColumn(width: 2, text: pieces.toInt().toString()),
        PosColumn(width: 2, text: weight.toStringAsFixed(3)),
        PosColumn(width: 2, text: vaDisplay),
        PosColumn(width: 2, text: mcDisplay),
        PosColumn(width: 2, text: stoneDisplay),
        PosColumn(
          width: 2,
          text: formatNumber(amount.toString()),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      // Stone details if available
      if (lineItem.taggingRecord?.lineStones?.isNotEmpty ?? false) {
        for (var stone in lineItem.taggingRecord!.lineStones!) {
          String weightDisplay =
              stone.carat?.isNotEmpty == true
                  ? 'Ct:${stone.carat}*'
                  : 'Gm:${stone.weight}*';
          String pieces = stone.pieces?.toString() ?? '';

          // Format rate to remove unnecessary decimals
          double rateValue = double.tryParse(stone.rate ?? '0') ?? 0;
          String rateDisplay =
              rateValue % 1 == 0
                  ? rateValue.toInt().toString()
                  : rateValue.toStringAsFixed(1);

          bytes += generator.text(
            '  ${stone.name ?? ""} $pieces$weightDisplay$rateDisplay=${stone.total ?? ""}',
            styles: const PosStyles(
              align: PosAlign.left,
              width: PosTextSize.size1,
            ),
          );
        }
      }

      bytes += generator.text(''); // Blank line

      // Accumulate totals
      totalPieces += pieces;
      totalWeight += weight;
      totalAmount += amount;
    }

    bytes += generator.hr();

    // Totals
    bytes += generator.row([
      PosColumn(width: 4, text: '${totalPieces.toInt()}'),
      PosColumn(width: 4, text: totalWeight.toStringAsFixed(3)),
      PosColumn(
        width: 4,
        text: formatNumber(totalAmount.toString()),
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // Payment details
    if (salesRecord.paymentDetails?.isNotEmpty ?? false) {
      final payment = salesRecord.paymentDetails!.first;

      // // Subtotal (blank line then amount on right)
      // bytes += generator.row([
      //   PosColumn(width: 8, text: ''),
      //   PosColumn(
      //       width: 4,
      //       text: formatNumber(payment.subTotal ?? '0'),
      //       styles: const PosStyles(align: PosAlign.right)),
      // ]);

      // GST
      if (payment.igst != null &&
          double.tryParse(payment.igst!) != null &&
          double.parse(payment.igst!) == 0) {
        bytes += generator.row([
          PosColumn(width: 6, text: ''),
          PosColumn(width: 3, text: 'CGST 1.5%'),
          PosColumn(
            width: 3,
            text: formatNumber(payment.cgst ?? '0'),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        bytes += generator.row([
          PosColumn(width: 6, text: ''),
          PosColumn(width: 3, text: 'SGST 1.5%'),
          PosColumn(
            width: 3,
            text: formatNumber(payment.sgst ?? '0'),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      } else {
        bytes += generator.row([
          PosColumn(width: 4, text: ''),
          PosColumn(width: 4, text: 'IGST 3%'),
          PosColumn(
            width: 4,
            text: formatNumber(payment.igst ?? '0'),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      // Net
      bytes += generator.row([
        PosColumn(width: 4, text: ''),
        PosColumn(width: 4, text: 'Nett'),
        PosColumn(
          width: 4,
          text: formatNumber(payment.nettGst ?? '0'),
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }

    bytes += generator.hr();

    // OLD GOLD VALUATION SECTION
    if (salesRecord.oldGolds != null && salesRecord.oldGolds!.isNotEmpty) {
      bytes += generator.text(
        'Valuation.',
        styles: const PosStyles(align: PosAlign.left),
      );

      // Table header for old gold
      bytes += generator.row([
        PosColumn(width: 2, text: 'Item Wt.'),
        PosColumn(width: 2, text: 'Dust'),
        PosColumn(
          width: 2,
          text: 'Wst.',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: 'Rt',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: '+/-',
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          width: 2,
          text: 'Amt.',
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      double totalOldGoldWeight = 0;
      double totalOldGoldAmount = 0;

      // Old gold items
      for (var oldGold in salesRecord.oldGolds!) {
        double grossWeight = double.tryParse(oldGold.grossWeight ?? '0') ?? 0;
        double less = double.tryParse(oldGold.less ?? '0') ?? 0;
        double amountValue = double.tryParse(oldGold.amount ?? '0') ?? 0;
        double rateValue = double.tryParse(oldGold.rate ?? '0') ?? 0;

        // Format rate to max 1 decimal or no decimal
        String formattedRate =
            rateValue % 1 == 0
                ? rateValue.toInt().toString()
                : rateValue.toStringAsFixed(1);

        // Print ornament name if available
        if (oldGold.ornamentName != null && oldGold.ornamentName!.isNotEmpty) {
          bytes += generator.text(
            oldGold.ornamentName!.toUpperCase(),
            styles: const PosStyles(align: PosAlign.left),
          );
        }

        bytes += generator.row([
          PosColumn(
            width: 2,
            text: grossWeight.toStringAsFixed(3),
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            width: 2,
            text: less.toStringAsFixed(3),
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            width: 2,
            text: '${oldGold.purityType ?? ""}%',
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: formattedRate,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: '0',
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 2,
            text: amountValue.ceil().toString(),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);

        // Add description if available
        if (oldGold.description != null && oldGold.description!.isNotEmpty) {
          bytes += generator.text(
            oldGold.description!,
            styles: const PosStyles(align: PosAlign.left),
          );
        }

        totalOldGoldWeight += grossWeight;
        totalOldGoldAmount += amountValue.ceilToDouble();
      }

      // Total old gold weight and amount
      bytes += generator.row([
        PosColumn(
          width: 2,
          text: totalOldGoldWeight.toStringAsFixed(3),
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(width: 2, text: ''),
        PosColumn(width: 2, text: ''),
        PosColumn(width: 2, text: ''),
        PosColumn(width: 2, text: ''),
        PosColumn(
          width: 2,
          text: totalOldGoldAmount.ceil().toString(),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      bytes += generator.row([
        PosColumn(width: 6, text: ''),
        PosColumn(width: 3, text: 'Exch.'),
        PosColumn(
          width: 3,
          text: totalOldGoldAmount.ceil().toString(),
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (salesRecord.paymentDetails?.isNotEmpty ?? false) {
        final payment = salesRecord.paymentDetails!.first;
        double nettAmount = double.tryParse(payment.nettGst ?? '0') ?? 0;
        double finalAmount = nettAmount - totalOldGoldAmount;

        bytes += generator.row([
          PosColumn(width: 6, text: ''),
          PosColumn(width: 3, text: 'Nett.'),
          PosColumn(
            width: 3,
            text: finalAmount.ceil().toString(),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    bytes += generator.hr();

    // Footer
    String time =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    String invoiceNumber = salesRecord.saleNumber ?? "";
    String user = "X";
    String system = "X";

    bytes += generator.text(
      '$time/$user/$system/$invoiceNumber',
      styles: const PosStyles(align: PosAlign.left),
    );

    // bytes += generator.text('SUBJECT TO BILLING ON APPROVAL..',
    //     styles: const PosStyles(align: PosAlign.center));

    // // Additional message if enabled
    // if (estimatePrintTemplate?.showAdditionalMessage == true &&
    //     estimatePrintTemplate?.additionalMessage?.isNotEmpty == true) {
    //   bytes += generator.text(
    //     estimatePrintTemplate!.additionalMessage!,
    //     styles: const PosStyles(align: PosAlign.center),
    //   );
    // }

    // // Barcode
    // if (salesRecord.saleNumber != null) {
    //   bytes += generator.barcode(
    //     Barcode.code39(salesRecord.saleNumber!.split('')),
    //     height: 50,
    //     width: 2,
    //     textPos: BarcodeText.none,
    //   );
    // }

    bytes += generator.feed(1);
    bytes += generator.cut();

    await sendDataToPrint(bytes);
  }

  Future<void> printItemDifferenceSlip({
    required GetSalesRecordByIdAggregateResponse salesRecord,
  }) async {
    log("Print item difference slip called");

    // First, check if there's any item with difference > 0
    bool hasDifference = false;
    for (var lineItem in salesRecord.lineItems ?? []) {
      double taggingWeight =
          double.tryParse(lineItem.taggingNetWeight ?? '0') ?? 0;
      double finalWeight = double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0;
      double difference = taggingWeight - finalWeight;

      if (difference > 0) {
        hasDifference = true;
        break;
      }
    }

    // If no difference found, don't print
    if (!hasDifference) {
      log(
        "No weight difference found. Skipping item difference slip printing.",
      );
      return;
    }

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // Header
    bytes += generator.text(
      'Diff Wt.',
      styles: const PosStyles(align: PosAlign.left, bold: true),
    );

    bytes += generator.hr();

    // Table Header
    bytes += generator.row([
      PosColumn(width: 3, text: 'Tag'),
      PosColumn(
        width: 3,
        text: 'Wt.',
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        width: 3,
        text: 'Sold',
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        width: 3,
        text: 'Diff.',
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr();

    // Line Items - only print items with difference > 0
    for (var lineItem in salesRecord.lineItems ?? []) {
      // Calculate difference
      double taggingWeight =
          double.tryParse(lineItem.taggingNetWeight ?? '0') ?? 0;
      double finalWeight = double.tryParse(lineItem.finalNetWeight ?? '0') ?? 0;
      double difference = taggingWeight - finalWeight;

      // Only print if difference > 0
      if (difference > 0) {
        // Create tag identifier
        String tag = '${lineItem.code ?? ""}-${lineItem.tag ?? ""}';

        bytes += generator.row([
          PosColumn(width: 3, text: tag),
          PosColumn(
            width: 3,
            text: taggingWeight.toStringAsFixed(3),
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 3,
            text: finalWeight.toStringAsFixed(3),
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            width: 3,
            text: difference.toStringAsFixed(3),
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    bytes += generator.hr();

    // Footer with time/user/system/invoice/date
    String time =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    String user = "X"; // Replace with actual user if available
    String system = "X"; // Replace with actual system if available
    String invoiceNumber = salesRecord.saleNumber ?? "";

    bytes += generator.text(
      '*.$time/$user/$system/$invoiceNumber',
      styles: const PosStyles(align: PosAlign.left),
    );

    bytes += generator.feed(1);
    bytes += generator.cut();

    await sendDataToPrint(bytes);
  }

  Future<void> sendDataToPrint(List<int> bytes) async {
    try {
      await loadPrinter();
      if (printer != null) {
        bool connected = await _checkConnection(input: printer!.input);
        if (connected) {
          await _sendBytesToPrint(bytes, printer!.input.printerType);
          Get.back();
        } else {
          showErrorToast(message: "Failed to connect printer.");
        }
      }
    } catch (e) {
      showErrorToast(message: e.toString());
    }
  }
}
