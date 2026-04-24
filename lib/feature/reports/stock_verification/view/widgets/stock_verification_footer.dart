import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/res/colors/app_color.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/stock_verification/view_model/stock_verification_report_view_model.dart';

class StockVerificationFooter extends StatelessWidget {
  const StockVerificationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final StockVerificationReportViewModel viewModel = Get.find();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1428328B),
            blurRadius: 12,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Get.width * 0.15,
            child: TextField(
              controller: viewModel.barcodeTextController,
              focusNode: viewModel.barcodeFocusNode,
              decoration: InputDecoration(
                hintText: 'Scan barcode to verify',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                suffixIcon: Obx(
                  () =>
                      viewModel.barcodeInput.value.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              viewModel.barcodeTextController.clear();
                              viewModel.barcodeInput.value = '';
                            },
                          )
                          : const SizedBox.shrink(),
                ),
              ),
              onChanged: viewModel.onBarcodeInputChanged,
              onEditingComplete: () {},
              autofocus: true,
            ),
          ),
          const SizedBox(width: 16),
          _buildScanStatusInfo(viewModel),
          const Spacer(),
          const SizedBox(width: 16),
          _buildActionButtons(viewModel),
        ],
      ),
    );
  }

  Widget _buildScanStatusInfo(StockVerificationReportViewModel viewModel) {
    return Obx(() {
      final totalItems =
          viewModel.stockVerificationList.value.data?.length ?? 0;
      final scannedItems = viewModel.getScannedItemsCount();
      final balanceItems = totalItems - scannedItems;

      return Row(
        children: [
          Column(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                totalItems.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              const Text(
                'Scanned',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                scannedItems.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              const Text(
                'Balance',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                balanceItems.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildActionButtons(StockVerificationReportViewModel viewModel) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              log("Discard button pressed");
              // Reset all scanned status
              viewModel.resetScannedItems();
            },
            borderRadius: BorderRadius.circular(8),
            child: Ink(
              height: 38,
              width: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: const Center(
                child: Text(
                  "Discard",
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Obx(() {
          final isLoading = viewModel.isSaving.value;
          final scannedCount = viewModel.getScannedItemsCount();

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap:
                  scannedCount > 0 && !isLoading
                      ? () => viewModel.saveStockVerification()
                      : null,
              child: Ink(
                height: 38,
                width: 140,
                decoration: BoxDecoration(
                  color:
                      scannedCount > 0
                          ? primaryColor
                          : primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Text(
                        "Save",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (isLoading) const SizedBox(width: 8),
                    if (isLoading)
                      const Text(
                        "Saving...",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
