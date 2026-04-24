import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase/purchase_invoice_listing/invoice_listing_customer&vendor/view/invoice_listing.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/purchase_return/purchase_return_listing/view/purchase_return_listing_screen.dart';
import 'package:jewellery_erp_frontend_tab_version/feature/reports/daily_report/view_model/daily_report_view_model.dart';
import 'package:jewellery_erp_frontend_tab_version/utils/widgets/custom_dashed_line_widget.dart';

class PurchaseSummaryWidget extends StatelessWidget {
  const PurchaseSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // SidebarController sidebarController = Get.find();
    return GetBuilder<DailyReportViewModel>(
      builder: (controller) {
        final purchase = controller.dailyReportResponse.value.data?.purchase;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Purchase Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPurchaseCard(
                            'Vendor Purchase (${purchase?.vendorPurchase?.invoiceCount ?? '0'})',
                            purchase?.vendorPurchase?.amount ?? '0',
                            '${purchase?.vendorPurchase?.weight ?? "0"} Gms',
                            'Avg rate ${purchase?.vendorPurchase?.averageRate ?? "0"}',
                            () => Get.to(
                              () => const InvoiceListingPage(
                                isToday: true,
                                wantBackButton: true,
                              ),
                            ),
                          ),
                          _buildVerticalDivider(),
                          _buildPurchaseCard(
                            'Customer Purchase (${purchase?.customerPurchase?.invoiceCount ?? '0'})',
                            purchase?.customerPurchase?.amount ?? '0',
                            '${purchase?.customerPurchase?.weight ?? "0"} Gms',
                            'Avg rate ${purchase?.customerPurchase?.averageRate ?? "0"}',
                            () => Get.to(
                              () => const InvoiceListingPage(
                                isToday: true,
                                wantBackButton: true,
                              ),
                            ),
                          ),
                          _buildVerticalDivider(),
                          // _buildPurchaseCard(
                          //     'Correction Weight (${purchase?.correctionWeight?.invoiceCount ?? '0'})',
                          //     purchase?.correctionWeight?.amount ?? '0',
                          //     '${purchase?.correctionWeight?.weight ?? "0"} Gms',
                          //     purchase?.correctionWeight?.averageRate ?? "0",
                          //     null),
                          // _buildVerticalDivider(),
                          _buildPurchaseCard(
                            'Cancelled Invoice',
                            purchase?.cancelledInvoice?.amount ?? '0',
                            '${purchase?.cancelledInvoice?.weight ?? "0"} Gms',
                            purchase?.cancelledInvoice?.averageRate ?? "0",
                            () => Get.to(
                              () => const InvoiceListingPage(
                                isToday: true,
                                wantBackButton: true,
                              ),
                            ),
                          ),
                          _buildVerticalDivider(),
                          _buildPurchaseCard(
                            'Purchase Return',
                            purchase?.purchaseReturn?.amount ?? '0',
                            '${purchase?.purchaseReturn?.weight ?? "0"} Gms',
                            purchase?.purchaseReturn?.averageRate ?? "0",
                            () => Get.to(
                              () => const PurchaseReturnInvoiceListingPage(
                                wantBackButton: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomDashedLineWidget(width: double.infinity),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (purchase?.transactions != null)
                              ...purchase!.transactions!.asMap().entries.map((
                                entry,
                              ) {
                                final transaction = entry.value;
                                return Row(
                                  children: [
                                    _buildPaymentMethod(
                                      transaction.type ?? '',
                                      transaction.amount ?? '0',
                                    ),
                                    if (entry.key !=
                                        purchase.transactions!.length - 1)
                                      _buildVerticalDivider(height: 48),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // sidebarController.selectSubMenuItem(
                  //     'stock', 'stock_purchase');
                  Get.to(
                    () => const InvoiceListingPage(
                      isToday: true,
                      wantBackButton: true,
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'View Detailed Report',
                        style: TextStyle(
                          color: Color(0xFF4758EC),
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF4758EC),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPurchaseCard(
    String title,
    String amount,
    String weight,
    String rate,
    VoidCallback? onArrowPress,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4758EC),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onArrowPress != null)
                InkWell(
                  onTap: onArrowPress,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF4758EC),
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF28328B),
              fontSize: 32,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weight,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rate,
                style: const TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String method, String amount) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _getPaymentIcon(method),
              const Icon(Icons.payment, color: Color(0xFF9F9F9F), size: 16),
              const SizedBox(width: 4),
              Text(
                method,
                style: const TextStyle(
                  color: Color(0xFF9F9F9F),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF111111),
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider({double height = 135}) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        color: const Color(0xFF111111).withOpacity(0.1),
        thickness: 1,
        width: 1,
      ),
    );
  }
}
