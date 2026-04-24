// Updated view_sales_return_item_details_controller.dart with debugging
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/sales/new_sales_return/view_sales_return_record/model/get_sales_return_record_by_id_response.dart';

class ViewSalesReturnItemDetailsController extends GetxController {
  final headers = [
    'Sn',
    'Item Code',
    'Tag No',
    "Description",
    'Pcs',
    'G.Wt. (gm)',
    'N.Wt. (gm)',
    'VA (₹)',
    'MC (₹)',
    'Stone Cost(₹)',
    'Hall Mark',
    'Discount',
    'Sales Amount',
    'Total',
    '',
  ];

  // Column widths matching the sales table
  final columnWidths = [
    0.08, // Sn
    0.3, // Item Code
    0.2, // Tag No
    0.3, // Description
    0.2, // Pcs
    0.3, // G.Wt.
    0.3, // N.Wt.
    0.3, // VA
    0.3, // MC
    0.2, // Stone Cost
    0.2, // Hall Mark
    0.2, // Discount
    0.3, // Sales Amount
    0.3, // Total
    0.1, // Empty (for actions)
  ];

  final RxList<String> totalHeadersValue =
      <String>[
        "",
        "Total",
        "",
        "",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "0",
        "",
      ].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isItemDetailsVisible = false.obs;
  final currentRowIndex = 0.obs;

  void showItemDetails({required int index}) {
    currentRowIndex.value = index;
    isItemDetailsVisible.value = true;
  }

  void hideItemDetails() {
    isItemDetailsVisible.value = false;
  }

  void updateTotalsFromLineItems(
    List<GetSalesReturnRecordByIdResponseLineItem> lineItems,
  ) {
    log('=== Starting Totals Calculation ===');
    log('Line items count: ${lineItems.length}');

    double totalPcs = 0;
    double totalGWt = 0;
    double totalNWt = 0;
    double totalVA = 0;
    double totalMC = 0;
    double totalStone = 0;
    double totalHallMark = 0;
    double totalDiscount = 0;
    double totalSalesAmount = 0;
    double totalFinalAmount = 0;

    for (int i = 0; i < lineItems.length; i++) {
      var item = lineItems[i];
      log('Item $i:');
      log('  - pieces: ${item.pieces}');
      log('  - grossWeight: ${item.grossWeight}');
      log('  - netWeight: ${item.netWeight}');
      log('  - finalVa: ${item.finalVa}');
      log('  - finalMc: ${item.finalMc}');
      log('  - stoneCost: ${item.stoneCost}');
      log('  - hallMark: ${item.hallMark}');
      log('  - discount: ${item.discount}');
      log('  - salesAmount: ${item.salesAmount}');
      log('  - totalAmount: ${item.totalAmount}');

      totalPcs += double.tryParse(item.pieces?.toString() ?? '0') ?? 0;
      totalGWt += double.tryParse(item.grossWeight ?? '0') ?? 0;
      totalNWt += double.tryParse(item.netWeight ?? '0') ?? 0;
      totalVA += double.tryParse(item.finalVa ?? '0') ?? 0;
      totalMC += double.tryParse(item.finalMc ?? '0') ?? 0;
      totalStone += double.tryParse(item.stoneCost ?? '0') ?? 0;
      totalHallMark += double.tryParse(item.hallMark ?? '0') ?? 0;
      totalDiscount += double.tryParse(item.discount ?? '0') ?? 0;
      totalSalesAmount += double.tryParse(item.salesAmount ?? '0') ?? 0;
      totalFinalAmount += double.tryParse(item.totalAmount ?? '0') ?? 0;
    }

    log('=== Calculated Totals ===');
    log('totalPcs: $totalPcs');
    log('totalGWt: $totalGWt');
    log('totalNWt: $totalNWt');
    log('totalVA: $totalVA');
    log('totalMC: $totalMC');
    log('totalStone: $totalStone');
    log('totalHallMark: $totalHallMark');
    log('totalDiscount: $totalDiscount');
    log('totalSalesAmount: $totalSalesAmount');
    log('totalFinalAmount: $totalFinalAmount');

    totalHeadersValue.value = [
      "", // Sn
      "Total", // Item Code
      "", // Tag No
      "", // Description
      totalPcs.toStringAsFixed(2), // Pcs
      totalGWt.toStringAsFixed(3), // G.Wt
      totalNWt.toStringAsFixed(3), // N.Wt
      totalVA.toStringAsFixed(2), // VA
      totalMC.toStringAsFixed(2), // MC
      totalStone.toStringAsFixed(2), // Stone Cost
      totalHallMark.toStringAsFixed(2), // Hall Mark
      totalDiscount.toStringAsFixed(2), // Discount
      totalSalesAmount.toStringAsFixed(2), // Sales Amount
      totalFinalAmount.toStringAsFixed(2), // Total
      "", // Actions
    ];

    log('=== Final totalHeadersValue ===');
    for (int i = 0; i < totalHeadersValue.length; i++) {
      log('[$i]: ${totalHeadersValue[i]}');
    }

    update();
    totalHeadersValue.refresh();
    log('=== Totals calculation completed ===');
  }

  void clearControllers() {
    currentRowIndex.value = 0;
    totalHeadersValue.value = [
      "",
      "Total",
      "",
      "",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "",
    ];
  }

  @override
  void onInit() {
    super.onInit();
    clearControllers();
    log('ViewSalesReturnItemDetailsController initialized');
  }
}
